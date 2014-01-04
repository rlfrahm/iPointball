//
//  PlayerTable.h
//  iPointball2D
//
//  Created by Ryan Frahm on 1/3/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SWTableView.h"

@interface PlayerTable : NSObject<SWTableViewDataSource, SWTableViewDelegate>

@property (nonatomic) NSArray* upgrades;

@end
