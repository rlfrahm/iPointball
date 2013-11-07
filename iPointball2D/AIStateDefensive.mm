//
//  AIDefensive.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/11/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "AIStateDefensive.h"
#import "AIPlayer.h"
#import "GameScene.h"
#import "AIStateRush.h"
#import "AIStateOffensive.h"

@implementation AIStateDefensive

-(NSString*)name
{
    return @"Defend";
}

-(void)enter:(AIPlayer *)player
{
    // Player sound here
}

-(void)execute:(AIPlayer *)player
{
    // Check if we should change state
    //NSArray* enemies = [player.layer enemiesWithinRange:200 ofPlayer:player];
    Player* human = [player.layer getHumanPlayer];
    if(!human.alive)
    {
        // If we don't see any enemies
        // Move up
        [player changeState:[[AIStateOffensive alloc]init]];
        return;
    } else if(player.knownNumberOfPlayers == 0){
        // If we know there are no enemies left
        [player changeState:[[AIStateRush alloc]init]];
        return;
    }
    
    // Else we will keep defending
    //[player.layer setPlayer:player attacking:NO];
    
    int r = arc4random() % 2;
    if(r == 0) {
        b2Body* b = [player.layer getBunker]; // Needs changed once more bunkers are added
        float d = (b->GetPosition().y + 20) - player.sprite.position.y;
        [player moveToPoint:ccp(player.sprite.position.x, d)];
    } else {
        b2Body* b = [player.layer getBunker]; // Needs changed once more bunkers are added
        float d = (b->GetPosition().y - 20) - player.sprite.position.y;
        [player moveToPoint:ccp(player.sprite.position.x, d)];
    }
}

@end
