//
//  Enemy.h
//  iPointball2D
//
//  Created by Ryan Frahm on 4/6/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import "GameObject.h"

@class GameLevelLayer;

@interface Enemy : GameObject

@property(assign) CGPoint velocity;
@property(assign) CGPoint acceleration;
@property(assign) float maxVelocity;
@property(assign) float maxAcceleration;

//@property(assign) NSString *shotSound;

@end
