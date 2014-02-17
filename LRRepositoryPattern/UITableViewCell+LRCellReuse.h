//
//  UITableViewCell+LRCellReuse.h
//  LRRepositoryPatternTest
//
//  Created by Luis Recuenco on 16/02/14.
//  Copyright (c) 2014 Luis Recuenco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (LRCellReuse)

+ (void)lr_registerToTableView:(UITableView *)tableView;

+ (UITableViewCell *)lr_dequeueReusableCellFromTableView:(UITableView *)tableView;

@end
