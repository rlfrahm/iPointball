//
//  MarkerTable.h
//  iPointball2D
//
//  Created by Ryan Frahm on 1/3/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SWTableView.h"

@protocol MarkerTableDelegate;

@interface MarkerTable : NSObject<SWTableViewDelegate, SWTableViewDataSource>

@property (nonatomic, assign) id<MarkerTableDelegate> delegate;

@end

@protocol MarkerTableDelegate <NSObject>

-(void)markerTableView:(SWTableView*)table didSelectCell:(SWTableViewCell*)cell atIndex:(NSUInteger)idx;

@end
