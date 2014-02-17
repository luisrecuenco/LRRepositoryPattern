// LRTVShow.m
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

#import "LRTVShow.h"

@interface LRTVShow ()

@property (nonatomic, copy) NSString *premiereDateString;
@property (nonatomic, copy) NSString *traktURLString;
@property (nonatomic, copy) NSString *posterURLString;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *overview;
@property (nonatomic, copy) NSString *network;
@property (nonatomic, strong) NSDate *premiereDate;
@property (nonatomic, strong) NSURL *traktURL;
@property (nonatomic, strong) NSURL *posterURL;

@end

@implementation LRTVShow

+ (instancetype)tvshowWithDictionary:(NSDictionary *)dictionary
{
    return [self baseModelWithDictionary:dictionary];
}

#pragma mark - JSON data mapping

- (void)setPremiereDateString:(NSString *)premiereDateString
{
    _premiereDate = [NSDate dateWithTimeIntervalSince1970:[premiereDateString doubleValue]];
}

- (void)setTraktURLString:(NSString *)traktURLString
{
    _traktURL = [NSURL URLWithString:traktURLString];
}

- (void)setPosterURLString:(NSString *)posterURLString
{
    _posterURL = [NSURL URLWithString:posterURLString];
}

#pragma mark - LRBaseModelMappings

- (NSDictionary *)mappings
{
    return @{ @"title" : @"title",
              @"overview" : @"overview",
              @"network" : @"network",
              @"first_aired" : @"premiereDateString",
              @"url" : @"traktURLString",
              @"poster" : @"posterURLString",
              };
}

#pragma mark - LRBaseModelSerializable

static NSString *const kTitleKey = @"kTitleKey";
static NSString *const kOverviewKey = @"kOverviewKey";
static NSString *const kNetworkKey = @"kNetworkKey";
static NSString *const kPremiereDateKey = @"kPremiereDateKey";
static NSString *const kTraktURLKey = @"kTraktURLKey";
static NSString *const kPosterURLKey = @"kPosterURLKey";

+ (LRTVShow *)deserialize:(NSDictionary *)dictionary
{
    LRTVShow *show = [[LRTVShow alloc] init];
    
    show.title = LREmptyStringToNil(dictionary[kTitleKey]);
    show.overview = LREmptyStringToNil(dictionary[kOverviewKey]);
    show.network = LREmptyStringToNil(dictionary[kNetworkKey]);
    show.premiereDate = LREmptyStringToNil(dictionary[kPremiereDateKey]);
    show.traktURL = [NSURL URLWithString:LREmptyStringToNil(dictionary[kTraktURLKey])];
    show.posterURL = [NSURL URLWithString:LREmptyStringToNil(dictionary[kPosterURLKey])];
    
    return show;
}

- (NSDictionary *)serialize
{
    return @{ kTitleKey : LRNilToEmptyString(self.title),
              kOverviewKey : LRNilToEmptyString(self.overview),
              kNetworkKey : LRNilToEmptyString(self.network),
              kPremiereDateKey : LRNilToEmptyString(self.premiereDate),
              kTraktURLKey : LRNilToEmptyString([self.traktURL absoluteString]),
              kPosterURLKey : LRNilToEmptyString([self.posterURL absoluteString]),
              };
}

@end
