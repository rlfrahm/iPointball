//
//  Player.m
//  iPointball2D
//
//  Created by Ryan Frahm on 4/23/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"


@implementation Player

-(id)initWithWorld:(b2World *)world
{
    int32 count = 7;
    NSString *file= @"Player.png";
    b2Vec2 vertices[] = {
        // Vertices of collision box
    };
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    b2Body *body = [self createBodyForWorld:world position:b2Vec2(winSize.width/2/PTM_RATIO, winSize.height/2/PTM_RATIO) rotation:0 vertices:vertices vertexCount:count density:5.0 friction:0.2 restitution:0.2];
    
    if((self = [super initWithFile:file body:body original:YES]))
    {
        // Initialize more values for player
    }
    
    return self;
}

@end
