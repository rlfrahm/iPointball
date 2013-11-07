//
//  Player.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "GameObject.h"
#import "cocos2d.h"

@interface Player : GameObject

@property (nonatomic, assign) float speed;
@property (nonatomic, assign) CGFloat topY;
@property (nonatomic, assign) CGFloat btmY;
@property (nonatomic, assign) CGFloat leftX;
@property (nonatomic, assign) BOOL snapped;

-(void)setMovementWindow:(CGPoint)point;
-(void)moveToPoint:(CGPoint)point;
-(void)moveToVector:(b2Vec2)vector;

@end
