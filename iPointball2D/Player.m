//
//  Player.m
//  iPointball2D
//
//  Created by Ryan Frahm on 4/6/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"


@implementation Player

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName layer:(GameLevelLayer *)layer {
    if((self = [super initWithSpriteFrameName:spriteFrameName layer:layer]))
    {
        self.attacking = NO;
    }
    return self;
}

@end
