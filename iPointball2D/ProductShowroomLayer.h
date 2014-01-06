//
//  UpgradeDetailLayer.h
//  iPointball2D
//
//  Created by Ryan Frahm on 1/3/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "cocos2d.h"

@protocol ProductShowroomLayerDelegate;

@interface ProductShowroomLayer : CCLayer<UIAlertViewDelegate>

@property (nonatomic, assign) id<ProductShowroomLayerDelegate> delegate;

-(void)constructShowroom;
-(void)showMarkerWithIndex:(NSUInteger)idx;

@end

@protocol ProductShowroomLayerDelegate <NSObject>

-(void)buyItemAtIndex:(NSUInteger)idx andNetDollars:(int)dollars;
-(void)sellItemAtIndex:(NSUInteger)idx andNetDollars:(int)dollars;

@end
