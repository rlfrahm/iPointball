//
//  Player.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"
#import "Paint.h"

#define MOVE_WINDOW_Y 20
#define MOVE_WINDOW_X 20

@implementation Player {
    Paint* _paint;
    int paintInHopper;
    float _angle2;
}

-(id)initWithSprite:(NSString *)file layer:(GameScene *)layer andPosition:(CGPoint)position
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        self.currHP = 100;
        self.maxHP = 100;
        self.offense = NO;
        self.reloading = NO;
    }
    return self;
}

-(void)shootPaintToLocation:(CGPoint)location {
    CGPoint shootVector = ccpSub(location, self.sprite.position);
    CGFloat shootAngle = ccpToAngle(shootVector);
    if(shootAngle - _angle2 > 0.2 || shootAngle - _angle2 < -0.2) {_angle2 = shootAngle;return;}
    shootAngle = shootAngle + boris_random(-self.marker.accuracy, self.marker.accuracy);
    if([self.marker getPaintLeftInHopper] > 0) {
        [self createMovingPaintToLocation:location withAngle:shootAngle];
    } else {
        NSLog(@"Reload!");
    }
    _angle2 = shootAngle;
}

-(void)createMovingPaintToLocation:(CGPoint)location withAngle:(CGFloat)angle
{
    CGPoint point = self.sprite.position;
    _paint = [[Paint alloc] initWithLayer:self.layer forWorld:self.world position:point andTeam:self.team + 2];
    
    //[_batchNode addChild:_paint];
    
    [_paint fireToLocation:location withAngle:angle];
    [self.marker setPaintLeftInHopper:[self.marker getPaintLeftInHopper]-1];
}

-(void)reloadPaint {
    if(self.pods > 0) {
        self.reloadAccumulator = 0;
        self.reloading = YES;
        float interval = 3 - (self.reload/4);
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(reloadPaintNow:) userInfo:Nil repeats:YES];
    } else {
        // The player is out of paint!
        NSLog(@"Out of paint!");
    }
}

-(void)reloadPaintNow:(NSTimer*)timer {
    if (self.reloadAccumulator >= 3) {
        if([self getPaintLeftInHopper] + [self.pod getCapacity] > [self.marker getHopperCapacity]) {
            [self.marker setPaintLeftInHopper:[self.marker getHopperCapacity]];
        } else {
            [self.marker setPaintLeftInHopper:([self.marker getPaintLeftInHopper] + [self.pod getCapacity])];
        }
        [timer invalidate];
        self.reloading = NO;
    } else {
        self.reloadAccumulator++;
    }
}

/**
 * Fire the paint to a location
 *
 * @param point The point that you want the point to move through
 * @param shootAngle The angle that you want the paint to use in
 * order to move through that point
 */
-(void)fireToLocation:(CGPoint)point withAngle:(CGFloat)shootAngle
{
    float x1 = cos(shootAngle);
    float y1 = sin(shootAngle);
    
    b2Vec2 force = b2Vec2(x1*_paint.power,y1*_paint.power);
    //paintBody->ApplyForceToCenter(force);
    _paint.body->ApplyLinearImpulse(force, _paint.body->GetWorldCenter());
}

/**
 * Fire the paint to a location using a normalized vector
 *
 * @param normal The normalized vector (vector.Normalize())
 */
-(void)fireToLocationWithNormal:(b2Vec2)normal
{
    b2Vec2 force = b2Vec2(normal.x * _paint.power, normal.y * _paint.power);
    _paint.body->ApplyLinearImpulse(force, _paint.body->GetWorldCenter());
}

-(void)setMovementWindow:(CGPoint)point
{
    self.topY = point.y + MOVE_WINDOW_Y;
    self.btmY = point.y - MOVE_WINDOW_Y;
    self.leftX = point.x - MOVE_WINDOW_X;
}

-(void)moveWithVector:(b2Vec2)vector
{
    vector.Normalize();
    float speed = self.body->GetMass() * self.speed * 0.01;
    vector = b2Vec2(vector.x * speed, vector.y * speed);
    self.body->SetLinearVelocity(vector);
}

-(void)moveToPoint:(CGPoint)point
{
    b2Vec2 p1 = self.body->GetPosition();
    b2Vec2 v = b2Vec2(point.x - p1.x, point.y - p1.y);
    CCLOG(@"%f, %f",v.x, v.y);
    [self moveWithVector:v];
}

-(void)moveToVector:(b2Vec2)vector
{
    b2Vec2 p1 = self.body->GetPosition();
    b2Vec2 v = b2Vec2(vector.x - p1.x, vector.y - p1.y);
    [self moveWithVector:v];
}

-(void)stopMovement
{
    self.body->SetLinearVelocity(b2Vec2(0, 0));
}

-(int)getPaintLeftInHopper {
    return [self.marker getPaintLeftInHopper];
}

@end
