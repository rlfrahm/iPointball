//
//  Paint.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/5/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Paint.h"
#import "Box2D.h"
#import "CGPointExtension.h"

@implementation Paint {
    b2World* _world;
}

-(id)initWithLayer:(GameScene *)layer forWorld:(b2World *)world position:(CGPoint)position andTeam:(int)team
{
    if((self = [super initWithSprite:@"Projectile.png" layer:layer andPosition:position]))
    {
        self.team = team;
        [self createBodyForWorld:world];
        self.power = 2;
        self.sprite.tag = team;
    }
    return self;
}

-(void)createBodyForWorld:(b2World*)world
{
    _world = world;
    // body definition
    
    b2BodyDef paintBodyDef;
    paintBodyDef.type = b2_dynamicBody;
    paintBodyDef.position.Set(self.sprite.position.x/PTM_RATIO, self.sprite.position.y/PTM_RATIO);
    paintBodyDef.userData = self.sprite;
    paintBodyDef.bullet = true;
    //paintBodyDef.angularDamping = 1.0f;
    self.body = _world->CreateBody(&paintBodyDef);
    
    // shape definiation
    b2CircleShape paintShape;
    paintShape.m_radius = 5.0/PTM_RATIO;
    
    // Create shape definition and add to body
    b2FixtureDef paintFixtureDef;
    paintFixtureDef.shape = &paintShape;
    paintFixtureDef.density = 1.0f;
    paintFixtureDef.friction = 0.5f;
    paintFixtureDef.restitution = .01f;
    if(self.team == 3) {
        self.sprite.tag = 3;
        paintFixtureDef.filter.categoryBits = kCategoryBitsHumanPaint;
        paintFixtureDef.filter.maskBits = kCategoryBitsAiPlayer | kCategoryBitsBunker | kCategoryBitsHumanPaint | kCategoryBitsAiPaint;
    } else {
        self.sprite.tag = 4;
        paintFixtureDef.filter.categoryBits = kCategoryBitsAiPlayer;
        paintFixtureDef.filter.maskBits = kCategoryBitsHumanPlayer | kCategoryBitsBunker | kCategoryBitsHumanPaint | kCategoryBitsAiPaint;
    }
    //paintShapeDef.friction = 0.0f;
    //paintShapeDef.restitution = 1.0f;
    
    self.body->CreateFixture(&paintFixtureDef);
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
    
    b2Vec2 force = b2Vec2(x1*self.power,y1*self.power);
    //paintBody->ApplyForceToCenter(force);
    self.body->ApplyLinearImpulse(force, self.body->GetWorldCenter());
}

/**
 * Fire the paint to a location using a normalized vector
 *
 * @param normal The normalized vector (vector.Normalize())
 */
-(void)fireToLocationWithNormal:(b2Vec2)normal
{
    b2Vec2 force = b2Vec2(normal.x * self.power, normal.y * self.power);
    self.body->ApplyLinearImpulse(force, self.body->GetWorldCenter());
}

@end
