//
//  Player.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"

#define PTM_RATIO 32
#define MOVE_WINDOW_Y 20
#define MOVE_WINDOW_X 20

@implementation Player

-(id)initWithSprite:(NSString *)file layer:(GameScene *)layer andPosition:(CGPoint)position
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        self.currHP = 100;
        self.maxHP = 100;
        self.offense = NO;
    }
    return self;
}

-(void)setMovementWindow:(CGPoint)point
{
    self.topY = point.y + MOVE_WINDOW_Y;
    self.btmY = point.y - MOVE_WINDOW_Y;
    self.leftX = point.x - MOVE_WINDOW_X;
}

@end
