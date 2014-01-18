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

@protocol BarrelTableDelegate;

@interface BarrelsTable : NSObject<SWTableViewDataSource, SWTableViewDelegate>

@property (nonatomic, assign) NSMutableArray* barrels;

@property (nonatomic,assign) id<BarrelTableDelegate> delegate;

@end

@protocol BarrelTableDelegate <NSObject>

-(void)barrelTableView:(SWTableView*)table didSelectCell:(SWTableViewCell*)cell atIndex:(NSUInteger)idx;

@end
