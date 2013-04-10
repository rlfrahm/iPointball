//
//  AIPlayer.h
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"

@class AIState;

@interface AIPlayer : Player

-(id)initWithLayer:(GameLevelLayer *)layer;

-(NSString *)stateName;
-(void)changeState:(AIState *)state;

@end
