// LRTVShowsTableViewController.m
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

#import "LRTVShowsTableViewController.h"
#import "LRTVShow.h"
#import "LRTVShowTableViewCell.h"
#import "UITableViewCell+LRCellReuse.h"
#import "LRTVShow.h"

@implementation LRTVShowsTableViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tvshows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LRTVShowTableViewCell *cell = (LRTVShowTableViewCell *)[LRTVShowTableViewCell lr_dequeueReusableCellFromTableView:tableView];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(LRTVShowTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LRTVShow *tvshow = self.tvshows[indexPath.row];
    
    [cell.posterImageView setImageWithURL:tvshow.posterURL];
    cell.nameLabel.text = tvshow.title;
    cell.ageLabel.text = tvshow.network;
    cell.sexLabel.text = tvshow.overview;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate tvshowsTableViewController:self didSelectTVShow:self.tvshows[indexPath.row]];
}

@end
