//
//  AIStateDefend.m
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "AIStateDefend.h"
#import "AIPlayer.h"
#import "GameLevelLayer.h"
#import "AIStateCounter.h"
#import "AIStateMass.h"
#import "SimpleAudioEngine.h"
#import "AIStateRush.h"

@implementation AIStateDefend

-(NSString *)name {
    return @"defend";
}

-(void)enter:(AIPlayer *)player {
    // Play sound
}

-(void)execute:(AIPlayer *)player {
    // Check if should change state
    
    // Make decision
}

@end
