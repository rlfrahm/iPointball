//
//  CollectionViewCell.h
//  iPointball2D
//
//  Created by Ryan Frahm on 1/6/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "cocos2d.h"

@protocol CollectionViewCellDelegate;

@interface CollectionViewCell : CCLayerColor

@property (nonatomic) NSUInteger idx;
@property (nonatomic, assign) id<CollectionViewCellDelegate> delegate;

-(CGSize)cellSize;

@end

@protocol CollectionViewCellDelegate <NSObject>

-(void)cellTouchedAtIndex:(NSUInteger)idx;

@end