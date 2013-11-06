//
//  AIStateStarting.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/11/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "AIStateStarting.h"
#import "AIPlayer.h"
#import "GameScene.h"
#import "AIStateDefensive.h"
#import "AIStateOffensive.h"
#import "AIStateRush.h"
#import "Bunker.h"

@implementation AIStateStarting {
    b2Body* _bunker;
}

-(NSString*)name
{
    return @"Starting";
}

-(void)enter:(AIPlayer *)player
{
    // Play sounds
}

-(void)execute:(AIPlayer *)player
{
    
    // Check if we should change state
    //NSArray* enemies = [player.layer enemiesWithinRange:200 ofPlayer:player];
    if(player.knownNumberOfPlayers == 0)
    {
        
        [player changeState:[[AIStateRush alloc]init]];
        return;
    } else if (_bunker != NULL){
        b2Vec2 p1 = player.body->GetPosition();
        b2Vec2 p2 = _bunker->GetPosition();
        b2Vec2 vector = b2Vec2(p2.x - p1.x, p2.y - p1.y);
        vector.Normalize();
        vector = b2Vec2(vector.x * player.speed, vector.y * player.speed);
        player.body->SetLinearVelocity(vector);
    } else {
        // Ray cast to look for cover
        
        // Then Move to cover
        
        // Ray cast to look for enemies
        for(Bunker* b in [player.layer bunkersWithinRange:200 ofPlayer:player]) {
            _bunker = b.body;
        }
    }
}

@end
