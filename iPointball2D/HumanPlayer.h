//
//  HumanPlayer.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/9/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"
#import "Box2D.h"

@class Level;

@interface HumanPlayer : Player

-(id)initWithLayer:(GameScene*)layer andFile:(NSString*)file forWorld:(b2World*)world andPosition:(CGPoint)position;

@end
