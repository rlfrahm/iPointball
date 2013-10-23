//
//  AIStateStarting.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/11/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "AIStateStarting.h"
#import "AIPlayer.h"
#import "GameScene.h"
#import "AIStateDefensive.h"
#import "AIStateOffensive.h"
#import "AIStateRush.h"

@implementation AIStateStarting

-(NSString*)name
{
    return @"Starting";
}

-(void)enter:(AIPlayer *)player
{
    // Play sounds
}

-(void)execute:(AIPlayer *)player
{
    // Check if we should change state
    NSArray* enemies = [player.layer enemiesWithinRange:200 ofPlayer:player];
    if(player.knownNumberOfPlayers == 0)
    {
        [player changeState:[[AIStateRush alloc]init]];
        return;
    } else {
        // Ray cast to look for enemies
    }
}

@end
