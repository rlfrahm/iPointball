//
//  AIDefensive.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/11/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//
//  The purpose of this state is for when the player
//  wants to hover behind cover and shoot at the other team.

#import "AIStateDefensive.h"
#import "AIPlayer.h"
#import "GameScene.h"
#import "AIStateRush.h"
#import "AIStateOffensive.h"

#define MOVE_DISTANCE 20

@implementation AIStateDefensive {
    b2Vec2 _p1;
    b2Vec2 _p2;
    float _d;
    BOOL _upwards;
    BOOL _movedone;
    CGPoint _target;
    int _i;
    BOOL _timerStarted;
    AIPlayer* _player;
    BOOL _movePlans;
}

-(NSString*)name
{
    return @"Defend";
}

-(void)enter:(AIPlayer *)player
{
    // Player sound here
}

-(void)peekDirection
{
    int r = arc4random_uniform(2);
    if(r == 0) {
        // Peek upwards
        _p2 = b2Vec2(_p1.x, _p1.y + MOVE_DISTANCE);
        _upwards = YES;
    } else {
        // Peek downwards
        _p2 = b2Vec2(_p1.x, _p1.y - MOVE_DISTANCE);
        _upwards = NO;
    }
    _movePlans = YES;
}

-(void)move:(AIPlayer *)player
{
    //CCLOG(@"Distance _p1 -> _p2: %f",b2Distance(_p1, _p2));
    if(b2Distance(_p1, _p2) < .01) {
        // If we are at our destination..
        [player stopMovement];
    } else {
        // If we are still moving to our  destination..
        [player moveToVector:_p2];
    }
}

-(void)movebackToCover:(AIPlayer*)player
{
    if(ccpDistance(player.sprite.position, player.coverLocale) < 300) {
        // We should be back behind cover
        CCLOG(@"%f", ccpDistance(player.sprite.position, player.coverLocale));
        [player stopMovement];
        _movePlans = NO;
        return;
    }
    
    _timerStarted = YES;
    if(_i > 4) {
        if(_upwards) {
            // Move down
            _p2 = b2Vec2(_p1.x, _p1.y - MOVE_DISTANCE);
        } else {
            // Move up
            _p2 = b2Vec2(_p1.x, _p1.y + MOVE_DISTANCE);
        }
        [self move:player];
        _movePlans = YES;
        _timerStarted = NO;
    } else if(_movePlans) {
        [player stopMovement];
    }
    _i++;
}

-(CGPoint)pickATarget:(AIPlayer*)player
{
    int r = arc4random_uniform([player.targetOptions count]);
    NSValue* v = [player.targetOptions objectAtIndex:r];
    player.targetAcquired = YES;
    return [v CGPointValue];
}

-(void)execute:(AIPlayer *)player
{
    _p1 = player.body->GetPosition();
    
    // Assumptions:
    // We are going to peek around the bag
    // If we shoot the player, player.targetAcquired = NO
    
    /**
     * Movement
     */
    // When we reach the bag...
    // If we don't have plans to move
    if(!_movePlans) {
        [self peekDirection];
        [self move:player];
    } else {
        if(player.targetAcquired) {
            [self movebackToCover:player];
        } else {
            [self move:player];
        }
    }
    
    /**
     * Targeting & Shooting
     */
    
    // If we don't have a target..
    if(!player.targetAcquired) {
        // If we see targets..
        if([player.targetOptions count] > 0) {
            // We want to pick a target..
            _target = [self pickATarget:player];
        }
        return;
    } else { // If we have a target..
        return;
    }
    
    /*
    if([player.targetOptions count] == 0) {
        CCLOG(@"No targets");
        // Peek around the bunker
        [self peekDirection];
        [self move:player];
    } else if([player.targetOptions count] > 0) {
        CCLOG(@"Targets visible");
        player.knownNumberOfPlayers = 1;
        _target = [self pickATarget:player];
        player.targetAcquired = YES;
        _i = 0;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(movebackToCover) userInfo:nil repeats:YES];
    }
    */
    // Check if we should change state
    //NSArray* enemies = [player.layer enemiesWithinRange:200 ofPlayer:player];
    /*if([player.targetOptions count] > 0)
    {
        player.knownNumberOfPlayers = 1;
        // We have targets. Pick one and shoot.
        [player stopMovement];
        if(_target.x == 0 && _target.y == 0) {
            _target = [self pickATarget:player];
            [player fireToPoint:_target];
        } else {
            
        }
        return;
    } else if([player.targetOptions count] == 0){
        //if(player.knownNumberOfPlayers > 0) {
        //    [player stopMovement];
        //    return;
        //}
        if(_movedone) {
            // We still can't see anbody
            if(_upwards) {
                _p2 = b2Vec2(_p1.x, _p1.y + 0.625);
                [player moveToVector:_p2];
                _movedone = NO;
            } else {
                _p2 = b2Vec2(_p1.x, _p1.y - 0.625);
                [player moveToVector:_p2];
                _movedone = NO;
            }
        }
        // We don't have targets. Lets peek around the bunker.
        _d = b2Distance(_p2, player.body->GetPosition());
        if(b2Distance(_p2, player.body->GetPosition()) < .01) {
            [player stopMovement];
            if(_timerStarted) {
                return;
            }
            _i = 0;
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(movebackToCover) userInfo:nil repeats:YES];
            _movedone = YES;
        } else {
            [player moveToVector:_p2];
            _movedone = NO;
        }
        return;
    }//*/
}
@end
