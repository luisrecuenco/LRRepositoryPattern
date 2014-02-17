// LRTVShowsListViewControllerTest.m
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

#import "Specta.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "LRTVShowsListViewController.h"
#import "LRDownloadShowsInteractor.h"
#import "LRSeeTVShowDetailInteractor.h"
#import "LRTVShowsTableViewController.h"
#import "LRTVShowsListView.h"
#import "LRTVShowDetailView.h"
#import "LRTVShowDetailViewController.h"
#import "LRTVShow.h"

SpecBegin(LRTVShowsListViewController)

__block LRTVShowsListViewController *sut = nil;

__block LRDownloadShowsInteractor *mockDownloadShowsInteractor;
__block LRSeeTVShowDetailInteractor *mockSeeTVShowDetailInteractor;
__block LRTVShowsTableViewController *mockTVShowsTableViewController;
__block id<LRTVShowsListView> mockTVShowsListView;
__block LRTVShowDetailViewControllerProvider *mockTVShowDetailViewControllerProvider;
__block LRTVShowDetailViewController *mockTVShowDetailViewController;
__block UIView *mockViewControllerView;
__block UITableView *mockTableView;

beforeEach(^{
    
    mockDownloadShowsInteractor = mock([LRDownloadShowsInteractor class]);
    mockSeeTVShowDetailInteractor = mock([LRSeeTVShowDetailInteractor class]);
    mockTVShowsTableViewController = mock([LRTVShowsTableViewController class]);
    mockTVShowsListView = mockProtocol(@protocol(LRTVShowsListView));
    mockTVShowDetailViewControllerProvider = mock([LRTVShowDetailViewControllerProvider class]);
    mockViewControllerView = mock([UIView class]);
    mockTVShowDetailViewController = mock([LRTVShowDetailViewController class]);
    mockTableView = mock([UITableView class]);
    
    [given([mockTVShowsListView view]) willReturn:mockViewControllerView];
    [given([mockTVShowsListView tableView]) willReturn:mockTableView];
    [given([mockTVShowDetailViewControllerProvider tvshowDetailViewController])
     willReturn:mockTVShowDetailViewController];
    
    sut = [[LRTVShowsListViewController alloc]
           initWithDownloadTVShowsInteractor:mockDownloadShowsInteractor
           seeTVShowDetailInteractor:mockSeeTVShowDetailInteractor
           tvshowsTableViewController:mockTVShowsTableViewController
           showsListView:mockTVShowsListView
           showDetailViewControllerProvider:mockTVShowDetailViewControllerProvider];
});

it(@"View should be the injected one", ^{
    expect(sut.view).to.beIdenticalTo(mockViewControllerView);
});

it(@"Should begin download of shows in viewDidLoad", ^{
    [sut viewDidLoad];
    [verify(mockDownloadShowsInteractor) downloadTVShowsInQueue:anything()
                                                completionBlock:anything()];
});

it(@"Should deselect selection in viewWillAppear", ^{
    [sut viewWillAppear:YES];
    [verify(mockTVShowsListView) deselectSelectedRow];
});

it(@"See TV Show Detail Interactor should be invoked when selecting a show", ^{
    LRTVShow *mockTVShow = mock([LRTVShow class]);
    [sut tvshowsTableViewController:mockTVShowsTableViewController didSelectTVShow:mockTVShow];
    [verify(mockSeeTVShowDetailInteractor) seeShowDetailForTVShow:mockTVShow
                                         showDetailViewController:mockTVShowDetailViewController
                                             navigationController:anything()];
});

it(@"Table View delegate and datasource are properly configured", ^{
    [verify(mockTableView) setDataSource:mockTVShowsTableViewController];
    [verify(mockTableView) setDelegate:mockTVShowsTableViewController];
});

SpecEnd
