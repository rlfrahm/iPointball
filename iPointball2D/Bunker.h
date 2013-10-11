//
//  Object.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "GameObject.h"

@interface Bunker : GameObject

-(id)initWithLayer:(GameScene*)layer andFile:(NSString*)file forWorld:(b2World*)world andPosition:(CGPoint)position;



@end
