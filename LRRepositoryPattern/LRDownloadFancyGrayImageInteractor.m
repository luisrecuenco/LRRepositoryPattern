// LRDownloadFancyGrayImageInteractor.m
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

#import "LRDownloadFancyGrayImageInteractor.h"

static CGFloat const kImageViewFadeAnimation = 0.25f;
static CGFloat const kBlurRadius = 3.0f;
static CGFloat const kBlurIterations = 5;

@implementation LRDownloadFancyGrayImageInteractor

- (instancetype)initWithImageManager:(LRImageManager *)imageManager
{
    if (!(self = [super init])) return nil;
    
    _imageManager = imageManager;
    
    return self;
}

- (void)downloadGrayImagefromURL:(NSURL *)url
                applyOnImageView:(UIImageView *)imageView
{
    __weak UIImageView *wImageView = imageView;
    
    [self.imageManager imageFromURL:url
                               size:CGSizeZero
                  completionHandler:^(UIImage *image, NSError *error) {
                      
                      __strong UIImageView *sImageView = wImageView;
                      
                      UIGraphicsBeginImageContextWithOptions(image.size, YES, 0.0);
                      CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
                      [image drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
                      UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
                      UIGraphicsEndImageContext();
                      
                      UIImage *blurredImage = [filteredImage blurredImageWithRadius:kBlurRadius
                                                                         iterations:kBlurIterations
                                                                          tintColor:nil];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [UIView transitionWithView:sImageView
                                            duration:kImageViewFadeAnimation
                                             options:UIViewAnimationOptionTransitionCrossDissolve
                                          animations:^{
                                              sImageView.image = blurredImage;
                                          } completion:NULL];
                      });
                  }];
}

- (void)cancelDownloadFromURL:(NSURL *)url
{
    [_imageManager cancelImageRequestFromURL:url size:CGSizeZero];
}

@end
