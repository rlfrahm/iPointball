//
//  GameObject.h
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import "cocos2d.h"

@class GameLevelLayer;

@interface GameObject : CCSprite

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName layer:(GameLevelLayer *)layer;

@property(assign) BOOL alive;

@property(assign) int team;
@property(assign) BOOL attacking;

@property(strong) GameLevelLayer *layer;

@end
