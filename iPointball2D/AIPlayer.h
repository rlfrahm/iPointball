//
//  AIPlayer.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/9/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"

@interface AIPlayer : Player

-(id)initWithLayer:(GameScene*)layer andFile:(NSString*)file forWorld:(b2World*)world andPosition:(CGPoint)position;

//State stuff

@end
