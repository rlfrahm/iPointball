//
//  AIState.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/11/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AIPlayer;

@interface AIState : NSObject

-(void)enter:(AIPlayer*)player;
-(void)execute:(AIPlayer*)player;
-(void)exit:(AIPlayer*)player;
-(NSString*)name;

@end
