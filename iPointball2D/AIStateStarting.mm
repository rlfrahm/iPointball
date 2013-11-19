//
//  AIStateStarting.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/11/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//
//  The starting state is reserved for the initial break
//  at the beginning of the game.
//
//  This state's main purpose is to get to cover, however
//  this state will also shoot if a target is visible
//

#import "AIStateStarting.h"
#import "AIPlayer.h"
#import "GameScene.h"
#import "AIStateDefensive.h"
#import "AIStateOffensive.h"
#import "AIStateRush.h"
#import "Bunker.h"

@implementation AIStateStarting {
    Bunker* _bunker;
    CGPoint _bunkerPt;
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
        // The other team's players have been eliminated
        [player changeState:[[AIStateRush alloc]init]];
        return;
    } else if (_bunkerPt.x > 0 && _bunkerPt.y > 0){
        if(ccpDistance(_bunkerPt, player.sprite.position) < 300) {
            // Stop and change to defensive mentality
            [player stopMovement];
            [player changeState:[[AIStateDefensive alloc]init]];
        } else {
            // Keep moving for cover
            //[player moveToVector:_bunker.body->GetPosition()];
            [player moveToPoint:_bunkerPt];
            if(player.targetOptions.count > 0) {
                // Shoot if a target is visible.
                int r = arc4random_uniform(player.targetOptions.count);
                NSValue* v = [player.targetOptions objectAtIndex:r];
                CGPoint pt = [v CGPointValue];
                [player fireToPoint:pt];
            }
        }
    } else {
        // Decide on some cover
        if([player.coverOptions count] > 0) {
            int r = arc4random_uniform(player.coverOptions.count);
            NSValue* v = [player.coverOptions objectAtIndex:r];
            _bunkerPt = [v CGPointValue];
            player.coverLocale = _bunkerPt;
        }
    } 
    
    // Is the enemy shooting at me?
}

@end
