//
//  AIState.h
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

@class AIPlayer;

@interface AIState : NSObject

-(void)enter:(AIPlayer *)player;
-(void)execute:(AIPlayer *)player;
-(void)exit:(AIPlayer *)player;
-(NSString *)name;

@end
