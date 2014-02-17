// LRTVShowsListViewController.m
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

#import "LRTVShowsListViewController.h"
#import "LRDownloadShowsInteractor.h"
#import "LRSeeTVShowDetailInteractor.h"
#import "LRTVShowsTableViewController.h"
#import "LRTVShowTableViewCell.h"
#import "LRTVShowsListView.h"
#import "UITableViewCell+LRCellReuse.h"
#import "LRTVShowDetailViewController.h"

@implementation LRTVShowsListViewController

- (instancetype)initWithDownloadTVShowsInteractor:(LRDownloadShowsInteractor *)downloadShowsInteractor
                        seeTVShowDetailInteractor:(LRSeeTVShowDetailInteractor *)seeTVShowDetailInteractor
                       tvshowsTableViewController:(LRTVShowsTableViewController *)tvshowsTableViewController
                                    showsListView:(id<LRTVShowsListView>)showsListView
                 showDetailViewControllerProvider:(LRTVShowDetailViewControllerProvider *)showDetailViewControllerProvider;
{
    if (!(self = [super init])) return nil;
    
    _downloadShowsInteractor = downloadShowsInteractor;
    _seeTVShowDetailInteractor = seeTVShowDetailInteractor;
    _tvshowsTableViewController = tvshowsTableViewController;
    _showsListView = showsListView;
    _showDetailViewControllerProvider = showDetailViewControllerProvider;
    
    self.title = NSLocalizedString(@"Trending TV Shows", nil);
    
    [self configureTableViewController];
    
    return self;
}

- (void)configureTableViewController
{
    _tvshowsTableViewController.delegate = self;
    _showsListView.tableView.dataSource = _tvshowsTableViewController;
    _showsListView.tableView.delegate = _tvshowsTableViewController;
    _showsListView.tableView.rowHeight = LRTVShowTableViewCellHeight;
    
    [LRTVShowTableViewCell lr_registerToTableView:_showsListView.tableView];
}

#pragma mark - Lifecycle

- (void)loadView
{
    self.view = self.showsListView.view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof (self) wself = self;
    [self.downloadShowsInteractor downloadTVShowsInQueue:[NSOperationQueue mainQueue]
                                         completionBlock:^(NSArray *tvshows, BOOL success) {
                                             __strong typeof (wself) sself = wself;
                                             sself.tvshowsTableViewController.tvshows = tvshows;
                                             [sself.showsListView reloadData];
                                         }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.showsListView deselectSelectedRow];
}

#pragma mark - LRTVShowsTableViewControllerDelegate

- (void)tvshowsTableViewController:(LRTVShowsTableViewController *)controller
                   didSelectTVShow:(LRTVShow *)tvshow
{
    LRTVShowDetailViewController *showDetailViewController = [self.showDetailViewControllerProvider tvshowDetailViewController];
    
    [self.seeTVShowDetailInteractor seeShowDetailForTVShow:tvshow
                                  showDetailViewController:showDetailViewController
                                      navigationController:self.navigationController];
}

@end
