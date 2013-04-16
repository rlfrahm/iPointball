//
//  HumanPlayer.m
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "HumanPlayer.h"

@implementation HumanPlayer

-(id)initWithLayer:(GameLevelLayer *)layer {
    if ((self = [super initWithSpriteFrameName:@"Player.png" layer:layer])) {
        self.team = 1;
    }
    return self;
}

-(void)setAttacking:(BOOL)attacking {
    [super setAttacking:attacking];
    if(attacking)
    {
        // set to attack sprite
    } else
    {
        // Set to other sprite
    }
}

@end
