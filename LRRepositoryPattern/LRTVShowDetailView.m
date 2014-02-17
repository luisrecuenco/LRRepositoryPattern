// LRTVShowDetailView.m
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

#import "LRTVShowDetailView.h"

static CGFloat const kLabelInsetMargin = 20.0f;
static CGFloat const kPosterImageOverlayAllpha = 0.7f;

@implementation LRTVShowDetailView

@synthesize posterImageView = _posterImageView;
@synthesize overviewLabel = _overviewLabel;
@synthesize posterImageOverlay = _posterImageOverlay;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];

    _posterImageView = [[UIImageView alloc] init];
    _posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    _posterImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    _posterImageOverlay = [[UIView alloc] init];
    _posterImageOverlay.backgroundColor = [UIColor blackColor];
    _posterImageOverlay.alpha = kPosterImageOverlayAllpha;
    _posterImageOverlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _overviewLabel = [[UILabel alloc] init];
    _overviewLabel.numberOfLines = 0;
    _overviewLabel.textAlignment = NSTextAlignmentCenter;
    _overviewLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:_posterImageView];
    [self addSubview:_posterImageOverlay];
    [self addSubview:_overviewLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.overviewLabel.frame = ({
        CGRect frame = self.view.frame;
        frame.size.width -= kLabelInsetMargin * 2;
        frame.origin.x = kLabelInsetMargin;
        frame.size.height /= 2;
        frame.origin.y = frame.size.height / 2;
        frame;
    });
}

- (UIView *)view
{
    return self;
}

@end
