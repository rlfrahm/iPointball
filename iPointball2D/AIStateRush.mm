//
//  AIStateRush.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/11/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "AIStateRush.h"
#import "AIPlayer.h"
#import "GameScene.h"
#import "AIStateDefensive.h"
#import "AIStateOffensive.h"

@implementation AIStateRush

-(NSString*)name
{
    return @"Rushing";
}

-(void)enter:(AIPlayer *)player
{
    // Sounds
}

-(void)execute:(AIPlayer *)player
{
    // Check if we should change state
    NSArray* enemies = [player.layer enemiesWithinRange:200 ofPlayer:player];
    if(enemies.count > 0)
    {
        // No human players within range
        // We should move up
        [player changeState:[[AIStateOffensive alloc] init]];
        return;
    } else if(player.knownNumberOfPlayers > 0)
    {
        [player changeState:[[AIStateDefensive alloc] init]];
        return;
    }
    
    // Rush to place
}

@end
