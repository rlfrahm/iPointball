//
//  Player.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"

#define MOVE_WINDOW_Y 20
#define MOVE_WINDOW_X 20

@implementation Player

-(id)initWithSprite:(NSString *)file layer:(GameScene *)layer andPosition:(CGPoint)position
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        self.currHP = 100;
        self.maxHP = 100;
        self.offense = NO;
    }
    return self;
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

@end
