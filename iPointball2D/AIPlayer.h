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
-(NSString*)stateName;
-(void)think;
-(void)scheduleRaycast:(CGPoint)pt;

@property (nonatomic,assign) int knownNumberOfPlayers;
@property CGPoint eye;
@property CGPoint target;
@property BOOL color;
@property float rayAngle;
@property BOOL canSeePlayer;
@property double lastShot;
@property (nonatomic, copy) NSString* file;
@property float eyesight;
@property (nonatomic, assign) NSMutableArray* coverOptions;
@property (nonatomic, assign) NSMutableArray* targetOptions;
@property BOOL targetAcquired;
@property CGPoint coverLocale;
@property (nonatomic, assign) NSMutableArray* rayVectors;

//State stuff

@end
