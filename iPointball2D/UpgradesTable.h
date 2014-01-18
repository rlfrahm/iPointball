//
//  UpgradesTable.h
//  iPointball2D
//
//  Created by Ryan Frahm on 1/18/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "cocos2d.h"
#import "SWTableView.h"

@protocol UpgradesTableDelegate;

@interface UpgradesTable : CCNode<SWTableViewDataSource, SWTableViewDelegate>

@property (nonatomic, assign) id<UpgradesTableDelegate> delegate;
@property (nonatomic, assign) NSMutableArray* upgrades;

@end

@protocol UpgradesTableDelegate <NSObject>

-(void)UpgradesTableView:(SWTableView*)table didSelectCell:(SWTableViewCell*)cell atIndex:(NSUInteger)idx;

@end
