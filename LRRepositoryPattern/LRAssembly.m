// LRAssembly.m
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

#import "LRAssembly.h"
#import "LRTVShowsListViewController.h"
#import "LRTVShowRepository.h"
#import "LRTVShowMemStorage.h"
#import "LRTVShowDiskStorage.h"
#import "LRTVShowNetworkStorage.h"
#import "LRTVShowParser.h"
#import "LRDownloadShowsInteractor.h"
#import "LRSeeTVShowDetailInteractor.h"
#import "LRTVShowsTableViewController.h"
#import "LRTVShowsListView.h"
#import "LRTVShowDetailViewController.h"
#import "LRTVShowDetailView.h"
#import "LRDownloadFancyGrayImageInteractor.h"


@implementation LRAssembly

- (id)tvshowsListViewController
{
    return [TyphoonDefinition withClass:[LRTVShowsListViewController class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithDownloadTVShowsInteractor:seeTVShowDetailInteractor:tvshowsTableViewController:showsListView:showDetailViewControllerProvider:);
        [initializer injectWithDefinition:[self downloadShowsInteractor]];
        [initializer injectWithDefinition:[self seeTVShowDetailInteractor]];
        [initializer injectWithDefinition:[self tvshowsTableViewController]];
        [initializer injectWithDefinition:[self tvshowsListView]];
        [initializer injectWithDefinition:[self tvshowDetailViewControllerProvider]];
    }];
}

- (id)downloadShowsInteractor
{
    return [TyphoonDefinition withClass:[LRDownloadShowsInteractor class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithTVShowRepository:);
        [initializer injectWithDefinition:[self tvshowRepository]];
    }];
}

- (id)seeTVShowDetailInteractor
{
    return [TyphoonDefinition withClass:[LRSeeTVShowDetailInteractor class]];;
}

- (id)tvshowsTableViewController
{
    return [TyphoonDefinition withClass:[LRTVShowsTableViewController class]];
}

- (id)tvshowsListView
{
    return [TyphoonDefinition withClass:[LRTVShowsListView class]];
}

- (id)tvshowDetailViewControllerProvider
{
    return [TyphoonDefinition withClass:[LRTVShowDetailViewControllerProvider class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithShowDetailView:downloadFancyGrayImageInteractor:);
        [initializer injectWithDefinition:[self tvshowDetailView]];
        [initializer injectWithDefinition:[self downloadFancyGrayImageInteractor]];
    }];
}

- (id)tvshowDetailView
{
    return [TyphoonDefinition withClass:[LRTVShowDetailView class]];
}

- (id)downloadFancyGrayImageInteractor
{
    return [TyphoonDefinition withClass:[LRDownloadFancyGrayImageInteractor class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithImageManager:);
        [initializer injectWithDefinition:[self imageManager]];
    }];
}

- (id)imageManager
{
    return [TyphoonDefinition withClass:[LRImageManager class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(init);
    } properties:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)tvshowRepository
{
    return [TyphoonDefinition withClass:[LRTVShowRepository class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithFirstLevelCacheStorage:secondLevelCacheStorage:thirdLevelCacheStorage:backgroundObserver:);
        [initializer injectWithDefinition:[self firstLevelCacheStorage]];
        [initializer injectWithDefinition:[self secondLevelCacheStorage]];
        [initializer injectWithDefinition:[self thirdLevelCacheStorage]];
        [initializer injectWithDefinition:[self backgroundObserver]];
    }];
}

- (id)firstLevelCacheStorage
{
    return [TyphoonDefinition withClass:[LRTVShowMemStorage class]];
}

- (id)secondLevelCacheStorage
{
    return [TyphoonDefinition withClass:[LRTVShowDiskStorage class]];
}

- (id)thirdLevelCacheStorage
{
    return [TyphoonDefinition withClass:[LRTVShowNetworkStorage class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithURLSession:tvshowParser:);
        [initializer injectWithDefinition:[self urlSession]];
        [initializer injectWithDefinition:[self tvshowParser]];
    }];
}

- (id)backgroundObserver
{
    return [TyphoonDefinition withClass:[LRNotificationObserver class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithNotificationCenter:);
        [initializer injectWithDefinition:[self notificationCenter]];
    }];
}

- (id)notificationCenter
{
    return [TyphoonDefinition withClass:[NSNotificationCenter class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(defaultCenter);
    }];
}

- (id)urlSession
{
    return [TyphoonDefinition withClass:[NSURLSession class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(sharedSession);
    }];
}

- (id)tvshowParser
{
    return [TyphoonDefinition withClass:[LRTVShowParser class]];
}

@end
