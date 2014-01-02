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
    BOOL _movingback2cover;
    BOOL _behindcover;
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
        _movedone = YES;
    } else {
        // If we are still moving to our  destination..
        [player moveToVector:_p2];
        _movedone = NO;
    }
}

-(void)movebackToCover:(AIPlayer*)player
{
    _timerStarted = YES;
    if(_i > 20 && !_movingback2cover) {
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
        _movingback2cover = YES;
        _i=0;
        return;
    } else if(_movingback2cover) {
        [self move:player];
    } else if(_movePlans && !_movedone) {
        [player stopMovement];
    }
    _i++;
}

-(void)amIWhereINeedToBe:(AIPlayer*)player
{
    float d = ccpDistance(player.sprite.position, player.coverLocale);
    if(ccpDistance(player.sprite.position, player.coverLocale) < 340  && _movingback2cover && !_movedone) {
        // We should be back behind cover
        //CCLOG(@"%f", ccpDistance(player.sprite.position, player.coverLocale));
        [player stopMovement];
        _movePlans = NO;
        _movingback2cover = NO;
        _movedone = YES;
        _behindcover = YES;
        return;
    } else if(ccpDistance(player.sprite.position, player.coverLocale) < 312 || ccpDistance(player.sprite.position, player.coverLocale) > 350) {
        // We are far away from the bunker and should come back
        [player stopMovement];
        _movePlans = YES;
        _movedone = NO;
        _behindcover = NO;
    }
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
    [self amIWhereINeedToBe:player];
    
    if(!_movePlans) {
        [self peekDirection];
        [self move:player];
    } else {
        if(player.targetAcquired) {
            if(_behindcover) { // ****************
                [self move:player];
            } else {
                [self movebackToCover:player];
            }
        } else {
            if(_behindcover) {
                
            } else {
                
            }
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
        [player scheduleRaycast:_target];
        return;
    }
}
@end
