// LRTVShowNetworkStorage.m
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

#import "LRTVShowNetworkStorage.h"
#import "LRTVShowParser.h"

static NSString *const kTrendingShowsJSONURL = @"http://api.trakt.tv/shows/trending.json/8225c62957f0cae8b025e958f892dea7/";

@implementation LRTVShowNetworkStorage

- (instancetype)initWithURLSession:(NSURLSession *)urlSession
                      tvshowParser:(LRTVShowParser *)tvshowParser
{
    if (!(self = [super init])) return nil;
    
    _urlSession = urlSession;
    _tvshowParser = tvshowParser;
    
    return self;
}

- (void)retrieveTVShowsInQueue:(NSOperationQueue *)queue
               completionBlock:(LRRetrieveTVShowsCompletionBlock)block
{
    NSURL *url = [NSURL URLWithString:kTrendingShowsJSONURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak typeof (self) wself = self;
    NSURLSessionDownloadTask *downloadTask = [self.urlSession downloadTaskWithRequest:request
                                                                    completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                        __strong typeof (wself) sself = wself;
                                                                        NSData *data = [NSData dataWithContentsOfURL:location];
                                                                        NSArray *tvshows = [sself.tvshowParser tvshowsFromData:data error:&error];
                                                                        
                                                                        [queue addOperationWithBlock:^{
                                                                            block(tvshows, error);
                                                                        }];
                                                                    }];
    [downloadTask resume];
}

@end
