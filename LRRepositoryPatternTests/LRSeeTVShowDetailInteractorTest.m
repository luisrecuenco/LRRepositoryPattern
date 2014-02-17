// LRSeeTVShowDetailInteractorTest.m
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

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "LRSeeTVShowDetailInteractor.h"
#import "LRTVShowDetailViewController.h"
#import "LRTVShow.h"

SpecBegin(LRSeeTVShowDetailInteractorTest)

__block LRSeeTVShowDetailInteractor *sut;

it(@"Navigation controller should push detail controller when a show is selected", ^{
    
    sut = [[LRSeeTVShowDetailInteractor alloc] init];
    
    LRTVShowDetailViewController *mockDetailViewController = mock([LRTVShowDetailViewController class]);
    UINavigationController *mockNavController = mock([UINavigationController class]);
    LRTVShow *mockTVShow = mock([LRTVShow class]);
    
    [sut seeShowDetailForTVShow:mockTVShow
       showDetailViewController:mockDetailViewController
           navigationController:mockNavController];
    
    [verify(mockNavController) pushViewController:mockDetailViewController animated:YES];
});

SpecEnd
