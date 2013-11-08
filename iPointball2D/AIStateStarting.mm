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
    // NSArray* enemies = [player.layer enemiesWithinRange:200 ofPlayer:player];
    if(player.knownNumberOfPlayers == 0)
    {
        [player changeState:[[AIStateRush alloc]init]];
        return;
    } else if (_bunker != NULL){
        if([player.layer isNextToBunker:_bunker player:player]) {
            [player stopMovement];
            [player changeState:[[AIStateDefensive alloc]init]];
        } else {
            [player moveToVector:_bunker->GetPosition()];
        }
    } else {
        // Ray cast to look for cover
        
        // Then Move to cover
        
        // Ray cast to look for enemies
        _bunker = [player.layer getBunker];
    } 
    
    // Is the enemy shooting at me?
}

@end
