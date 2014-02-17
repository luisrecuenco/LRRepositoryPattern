// LRTVShowDiskStorage.m
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

#import "LRTVShowDiskStorage.h"
#import "LRTVShow.h"

static NSString *const kLRTVShowsPersistenceFileName = @"kLRTVShowsPersistenceFileName";

@interface LRTVShowDiskStorage ()

@property (nonatomic, strong) dispatch_queue_t syncQueue;

@end

@implementation LRTVShowDiskStorage

#pragma mark - Retrieving TV Shows

- (void)retrieveTVShowsInQueue:(NSOperationQueue *)queue
               completionBlock:(LRRetrieveTVShowsCompletionBlock)block
{
    dispatch_async(self.syncQueue, ^{
        
        NSError *error;
        NSData *plistData = [NSData dataWithContentsOfFile:[self tvshowsDiskStoragePath]
                                                   options:0
                                                     error:&error];
        NSArray *tvshows = nil;
        
        if(!plistData || error)
        {
            NSLog(@"Unable to read plist data from disk: %@", [error localizedDescription]);
        }
        else
        {
            tvshows = [self tvshowsFromData:plistData error:&error];
        }
        
        [queue addOperationWithBlock:^{
            block(tvshows, error);
        }];
    });
}

- (NSArray *)tvshowsFromData:(NSData *)data error:(__autoreleasing NSError **)error
{
    NSArray *serializedEntries = [NSPropertyListSerialization propertyListWithData:data
                                                                           options:0
                                                                            format:NULL
                                                                             error:error];
    if(!serializedEntries || *error)
    {
        NSLog(@"Unable to decode plist from data: %@", *error);
        return nil;
    }
    
    NSMutableArray *mutableTVShows = [NSMutableArray arrayWithCapacity:[serializedEntries count]];
    
    for (NSDictionary *serializedEntry in serializedEntries)
    {
        [mutableTVShows addObject:[LRTVShow deserialize:serializedEntry]];
    }
    
    return [mutableTVShows copy];
}

#pragma mark - Saving TVShows

- (void)saveTVShows:(NSArray *)tvshows queue:(NSOperationQueue *)queue
    completionBlock:(LRSaveTVShowsCompletionBlock)block;
{
    dispatch_barrier_async(self.syncQueue, ^{
        
        NSError *error;
        
        NSData *plistData = [self plistDataForTVShows:tvshows error:&error];
        
        if (!plistData || error)
        {
            block(error);
            return;
        }
        
        BOOL success = [plistData writeToFile:[self tvshowsDiskStoragePath]
                                      options:NSDataWritingAtomic
                                        error:&error];
        
        if(!success || error)
        {
            NSLog(@"Unable to write plist data to disk: %@", [error localizedDescription]);
        }
        
        [queue addOperationWithBlock:^{
            block(error);
        }];
    });
}

- (NSData *)plistDataForTVShows:(NSArray *)tvshows error:(__autoreleasing NSError **)error
{
    NSMutableArray *mutableTVShows = [NSMutableArray arrayWithCapacity:[tvshows count]];
    
    for (LRTVShow *tvshow in tvshows)
    {
        [mutableTVShows addObject:[tvshow serialize]];
    }
    
    return [NSPropertyListSerialization
            dataWithPropertyList:mutableTVShows
            format:NSPropertyListBinaryFormat_v1_0
            options:0
            error:error];
}

#pragma mark - Persistence File URL

- (NSString *)tvshowsDiskStoragePath
{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                   NSUserDomainMask, YES) firstObject];
    
    return [docsDirectory stringByAppendingPathComponent:kLRTVShowsPersistenceFileName];
}

- (dispatch_queue_t)syncQueue
{
    if (!_syncQueue)
    {
        _syncQueue = dispatch_queue_create("com.LRRepositoryPatternExample.LRTVShowDiskStorage",
                                           DISPATCH_QUEUE_SERIAL);
    }
    return _syncQueue;
}

@end
