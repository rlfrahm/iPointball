//
//  AIPlayer.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/9/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"

@class AIState;

@interface AIPlayer : Player

-(id)initWithLayer:(GameScene*)layer andFile:(NSString*)file forWorld:(b2World*)world andPosition:(CGPoint)position wNumOnOppTeam:(int)number;
-(void)changeState:(AIState*)state;

@property (nonatomic,assign) int knownNumberOfPlayers;

//State stuff

@end