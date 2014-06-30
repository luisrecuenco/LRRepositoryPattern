// LRTVShowRepository.m
//
// Copyright (c) 2014 Luis Recuenco
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LRTVShowRepository.h"
#import "LRTVShowStorage.h"

@interface LRTVShowRepository ()

@property (nonatomic, strong) NSMutableDictionary *storages;
@property (nonatomic, strong) LRNotificationObserver *backgroundObserver;

@property (nonatomic, copy) NSArray *tvShows;

@end

@implementation LRTVShowRepository

- (instancetype)initWithFirstLevelCacheStorage:(id<LRTVShowStorage>)firstLevelCacheStorage
                       secondLevelCacheStorage:(id<LRTVShowStorage>)secondLevelCacheStorage
                        thirdLevelCacheStorage:(id<LRTVShowStorage>)thirdLevelCacheStorage
                            backgroundObserver:(LRNotificationObserver *)backgroundObserver
{
    if (!(self = [super init])) return nil;
    
    _storages = [NSMutableDictionary dictionaryWithCapacity:LRTVShowRepositoryCacheLevelTotal];
    
    _storages[@(LRTVShowRepositoryCacheLevelFirst)] = firstLevelCacheStorage;
    _storages[@(LRTVShowRepositoryCacheLevelSecond)] = secondLevelCacheStorage;
    _storages[@(LRTVShowRepositoryCacheLevelThird)] = thirdLevelCacheStorage;
    
    _backgroundObserver = backgroundObserver;
    
    [_backgroundObserver configureForName:UIApplicationDidEnterBackgroundNotification
                                   target:self
                                   action:@selector(handleBackgroundTask)];
    
    return self;
}

#pragma mark - Retrieving

- (void)retrieveTVShowsInQueue:(NSOperationQueue *)queue
               completionBlock:(LRTVShowRepositoryRetrieveCompletionBlock)block
{
    __weak typeof (self) wself = self;
    [self retrieveTVShowsStartingInCacheLevel:LRTVShowRepositoryCacheLevelFirst
                                       queue:queue
                             completionBlock:^(NSArray *tvshows, NSError *error) {
                                 
                                 __strong typeof (wself) sself = wself;
                                 sself.tvShows = tvshows;
                                 [sself saveTVShows:tvshows queue:nil completionBlock:NULL];
                                 if (block) block(tvshows, error == nil);
                             }];
}

- (void)retrieveTVShowsStartingInCacheLevel:(LRTVShowRepositoryCacheLevel)cacheLevel
                                     queue:(NSOperationQueue *)queue
                           completionBlock:(LRRetrieveTVShowsCompletionBlock)block
{
    id<LRTVShowStorage> storage = self.storages[@(cacheLevel)];
    
    __block LRTVShowRepositoryCacheLevel _cacheLevel = cacheLevel;
    
    [storage retrieveTVShowsInQueue:queue completionBlock:^(NSArray *tvshows, NSError *error) {
        
        if (!tvshows || error)
        {
            LRTVShowRepositoryCacheLevel nextCacheLevel = ++_cacheLevel;
            
            [self retrieveTVShowsStartingInCacheLevel:nextCacheLevel
                                               queue:queue
                                     completionBlock:block];
        }
        else
        {
            block(tvshows, nil);
        }
    }];
}

#pragma mark - Saving

- (void)saveTVShows:(NSArray *)tvshows
              queue:(NSOperationQueue *)queue
    completionBlock:(LRTVShowRepositorySaveCompletionBlock)block
{
    NSMutableArray *storagesToSave = [NSMutableArray array];
    
    [self.storages enumerateKeysAndObjectsUsingBlock:^(id key, id<LRTVShowStorage> storage, BOOL *stop) {
        
        if ([storage respondsToSelector:@selector(saveTVShows:queue:completionBlock:)])
        {
            [storagesToSave addObject:storage];
        }
    }];
    
    __block NSError *_error = nil;
    __block NSUInteger numberOfFinishedSaves = 0;
    
    for (id<LRTVShowStorage> storage in storagesToSave)
    {
        [storage saveTVShows:tvshows queue:queue completionBlock:^(NSError *error) {
            
            numberOfFinishedSaves++;
            
            if (error)
            {
                _error = error;
            }
            
            if ([storagesToSave count] == numberOfFinishedSaves)
            {
                if (block) block(_error == nil);
            }
        }];
    }
}

#pragma mark - Background saving

- (void)handleBackgroundTask
{
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    [self saveTVShows:self.tvShows queue:[NSOperationQueue currentQueue] completionBlock:^(BOOL success) {
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

@end
