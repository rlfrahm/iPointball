//
//  AIStateMass.m
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "AIStateMass.h"
#import "AIPlayer.h"
#import "GameLevelLayer.h"
#import "AIStateDefend.h"
#import "SimpleAudioEngine.h"
#import "AIStateRush.h"

@implementation AIStateMass

-(NSString *)name {
    return @"mass";
}

-(void)enter:(AIPlayer *)player {
    // Play audio
}

-(void)execute:(AIPlayer *)player {
    // Check if should change state
}

-(void)exit:(AIPlayer *)player {
    
}

@end
