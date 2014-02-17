//
//  UITableViewCell+LRCellReuse.m
//  LRRepositoryPatternTest
//
//  Created by Luis Recuenco on 16/02/14.
//  Copyright (c) 2014 Luis Recuenco. All rights reserved.
//

#import "UITableViewCell+LRCellReuse.h"

@implementation UITableViewCell (LRCellReuse)

+ (void)lr_registerToTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil]
    forCellReuseIdentifier:NSStringFromClass(self)];
}

+ (UITableViewCell *)lr_dequeueReusableCellFromTableView:(UITableView *)tableView
{
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
}

@end
