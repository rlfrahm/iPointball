//
//  Player.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"

#define PTM_RATIO 32

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

-(void)shootPaintToPoint:(CGPoint)point
{
    
}

@end
