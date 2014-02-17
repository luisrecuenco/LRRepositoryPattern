// LRTVShowDetailViewController.m
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

#import "LRTVShowDetailViewController.h"
#import "LRTVShowDetailView.h"
#import "LRTVShow.h"
#import "LRDownloadFancyGrayImageInteractor.h"

@interface LRTVShowDetailViewController ()

@property (nonatomic, strong) LRTVShow *tvshow;

@end

@implementation LRTVShowDetailViewController

- (instancetype)initWithShowDetailView:(id<LRTVShowDetailView>)showDetailView
      downloadFancyGrayImageInteractor:(LRDownloadFancyGrayImageInteractor *)downloadFancyGrayImageInteractor
{
    if (!(self = [super init])) return nil;
    
    _showDetailView = showDetailView;
    _downloadFancyGrayImageInteractor = downloadFancyGrayImageInteractor;
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)loadView
{
    self.view = self.showDetailView.view;
}

- (void)configureWithShow:(LRTVShow *)tvshow
{
    _tvshow = tvshow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showDetailView.overviewLabel.text = self.tvshow.overview;
    
    self.title = self.tvshow.title;
    
    self.showDetailView.posterImageView.image = nil;
    
    [self.downloadFancyGrayImageInteractor downloadGrayImagefromURL:self.tvshow.posterURL
                                                   applyOnImageView:self.showDetailView.posterImageView];
}

- (void)dealloc
{
    [_downloadFancyGrayImageInteractor cancelDownloadFromURL:_tvshow.posterURL];
}

@end

#pragma mark - LRTVShowDetailViewControllerProvider Implementation

@implementation LRTVShowDetailViewControllerProvider
{
    id<LRTVShowDetailView> _showDetailView;
    LRDownloadFancyGrayImageInteractor *_downloadFancyGrayImageInteractor;
}

- (instancetype)initWithShowDetailView:(id<LRTVShowDetailView>)showDetailView
      downloadFancyGrayImageInteractor:(LRDownloadFancyGrayImageInteractor *)downloadFancyGrayImageInteractor
{
    if (!(self = [super init])) return nil;
    
    _showDetailView = showDetailView;
    _downloadFancyGrayImageInteractor = downloadFancyGrayImageInteractor;
    
    return self;
}

- (LRTVShowDetailViewController *)tvshowDetailViewController
{
    return [[LRTVShowDetailViewController alloc] initWithShowDetailView:_showDetailView
                                       downloadFancyGrayImageInteractor:_downloadFancyGrayImageInteractor];
}

@end
