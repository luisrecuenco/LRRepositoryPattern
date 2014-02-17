// LRTVShowRepository.h
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

#import <Foundation/Foundation.h>

@protocol LRTVShowStorage;

#pragma mark - LRTVShowRepository Protocol

typedef void(^LRTVShowRepositoryRetrieveCompletionBlock)(NSArray *tvshows, BOOL success);
typedef void(^LRTVShowRepositorySaveCompletionBlock)(BOOL success);

@protocol LRTVShowRepository <NSObject>

- (void)retrieveTVShowsInQueue:(NSOperationQueue *)queue
               completionBlock:(LRTVShowRepositoryRetrieveCompletionBlock)block;

- (void)saveTVShows:(NSArray *)tvshows
              queue:(NSOperationQueue *)queue
    completionBlock:(LRTVShowRepositorySaveCompletionBlock)block;

@end

#pragma mark - LRTVShowRepository Interface

typedef NS_ENUM(NSUInteger, LRTVShowRepositoryCacheLevel)
{
    LRTVShowRepositoryCacheLevelFirst,
    LRTVShowRepositoryCacheLevelSecond,
    LRTVShowRepositoryCacheLevelThird,
    LRTVShowRepositoryCacheLevelTotal
};

@interface LRTVShowRepository : NSObject <LRTVShowRepository>

- (instancetype)initWithFirstLevelCacheStorage:(id<LRTVShowStorage>)firstLevelCacheStorage
                       secondLevelCacheStorage:(id<LRTVShowStorage>)secondLevelCacheStorage
                        thirdLevelCacheStorage:(id<LRTVShowStorage>)thirdLevelCacheStorage
                            backgroundObserver:(LRNotificationObserver *)backgroundObserver;

@end
