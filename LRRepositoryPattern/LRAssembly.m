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
    return [TyphoonDefinition withClass:[LRTVShowsListViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer: @selector(initWithDownloadTVShowsInteractor:seeTVShowDetailInteractor:tvshowsTableViewController:showsListView:showDetailViewControllerProvider:)
                        parameters: ^(TyphoonMethod *initializer)
         {
             [initializer injectParameterWith:[self downloadShowsInteractor]];
             [initializer injectParameterWith:[self seeTVShowDetailInteractor]];
             [initializer injectParameterWith:[self tvshowsTableViewController]];
             [initializer injectParameterWith:[self tvshowsListView]];
             [initializer injectParameterWith:[self tvshowDetailViewControllerProvider]];
             
         }];
    }];
}

- (id)downloadShowsInteractor {
    return [TyphoonDefinition withClass:[LRDownloadShowsInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer: @selector(initWithTVShowRepository:)
                        parameters: ^(TyphoonMethod *initializer)
         {
             [initializer injectParameterWith: [self tvshowRepository]];
         }
         ];
    }];
}


- (id)seeTVShowDetailInteractor
{
    return [TyphoonDefinition withClass:[LRSeeTVShowDetailInteractor class]];
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
    return [TyphoonDefinition withClass:[LRTVShowDetailViewControllerProvider class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer: @selector(initWithShowDetailView:downloadFancyGrayImageInteractor:)
                        parameters: ^(TyphoonMethod *initializer)
         {
             [initializer injectParameterWith: [self tvshowDetailView]];
             [initializer injectParameterWith: [self downloadFancyGrayImageInteractor]];
         }];
    }];
}

- (id)tvshowDetailView
{
    return [TyphoonDefinition withClass:[LRTVShowDetailView class]];
}

- (id)downloadFancyGrayImageInteractor
{
    return [TyphoonDefinition withClass:[LRDownloadFancyGrayImageInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer: @selector(initWithImageManager:)
                        parameters: ^(TyphoonMethod *initializer)
         {
             [initializer injectParameterWith: [self imageManager]];
         }];
    }];
}

- (id)imageManager
{
    return [TyphoonDefinition withClass:[LRImageManager class] configuration:^(TyphoonDefinition *definition) {
       // [definition useInitializer: @selector(init)];
        definition.scope = TyphoonScopeSingleton;
        
    }];
}

- (id)tvshowRepository
{
    return [TyphoonDefinition withClass:[LRTVShowRepository class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer: @selector(initWithFirstLevelCacheStorage:secondLevelCacheStorage:thirdLevelCacheStorage:backgroundObserver:)
                        parameters: ^(TyphoonMethod *initializer)
         {
             [initializer injectParameterWith: [self firstLevelCacheStorage]];
             [initializer injectParameterWith: [self secondLevelCacheStorage]];
             [initializer injectParameterWith: [self thirdLevelCacheStorage]];
             [initializer injectParameterWith: [self backgroundObserver]];
         }];
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
    return [TyphoonDefinition withClass:[LRTVShowNetworkStorage class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer: @selector(initWithURLSession:tvshowParser:)
                        parameters: ^(TyphoonMethod *initializer)
         {
             [initializer injectParameterWith: [self urlSession]];
             [initializer injectParameterWith: [self tvshowParser]];
         }];
    }];
}

- (id)backgroundObserver
{
    return [TyphoonDefinition withClass:[LRNotificationObserver class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer: @selector(initWithNotificationCenter:)
                        parameters: ^(TyphoonMethod *initializer)
         {
             [initializer injectParameterWith: [self notificationCenter]];
         }];
    }];
}

- (id)notificationCenter
{
    return [TyphoonDefinition withClass:[NSNotificationCenter class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(defaultCenter) ];
    }];
}

- (id)urlSession
{
    return [TyphoonDefinition withClass:[NSURLSession class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(sharedSession) ];
    }];
}

- (id)tvshowParser
{
    return [TyphoonDefinition withClass:[LRTVShowParser class]];
}

@end
