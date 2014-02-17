// LRDownloadFancyGrayImageInteractorTest.m
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

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "OCMock.h"

#import "LRDownloadFancyGrayImageInteractor.h"
#import "LRImageManager.h"

SpecBegin(LRDownloadFancyGrayImageInteractorTest)

__block LRDownloadFancyGrayImageInteractor *sut;

it(@"Downloading gray image should start download from image manager", ^{
    
    NSURL *aURL = [NSURL URLWithString:@"http://idontcare.com"];
    
    id mockImageManager = [OCMockObject niceMockForClass:[LRImageManager class]];
    [[mockImageManager expect] imageFromURL:aURL
                                       size:CGSizeZero
                          completionHandler:anything()];
    
    sut = [[LRDownloadFancyGrayImageInteractor alloc] initWithImageManager:mockImageManager];;
    
    UIImageView *mockImageView = mock([UIImageView class]);
    [sut downloadGrayImagefromURL:aURL applyOnImageView:mockImageView];
    
    [mockImageManager verify];
});

SpecEnd
