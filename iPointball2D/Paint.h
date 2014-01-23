//
//  Paint.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/5/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "GameObject.h"

@interface Paint : GameObject

@property (nonatomic, assign) int power;

-(id)initWithLayer:(GameScene*)layer forWorld:(b2World*)world position:(CGPoint)position andTeam:(int)team;
-(void)fireToLocation:(CGPoint)point withAngle:(CGFloat)shootAngle;
-(void)fireToLocationWithNormal:(b2Vec2)normal;

@end
