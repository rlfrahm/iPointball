//
//  AIPlayer.m
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "AIPlayer.h"
#import "GameLevelLayer.h"
#import "AIState.h"
#import "AIStateMass.h"

@implementation AIPlayer {
    AIState *currentState;
}

-(id)initWithLayer:(GameLevelLayer *)layer {
    if ((self = [super initWithSpriteFrameName:@"Target.png" layer:layer])) {
        self.team = 2;
        currentState = [[AIStateMass alloc] init];
    }
    return self;
}

-(void)setAttacking:(BOOL)attacking {
    [super setAttacking:attacking];
    // Do stuff if true/false
}

-(void)update:(ccTime)delta {
    [currentState execute:self];
    [super update:delta];
}

-(NSString *)stateName {
    return currentState.name;
}

-(void)changeState:(AIState *)state {
    [currentState exit:self];
    currentState = state;
    [currentState enter:self];
}

@end
