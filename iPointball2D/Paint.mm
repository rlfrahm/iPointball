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

#define PTM_RATIO 32

@implementation Paint {
    b2World* _world;
}

-(id)initWithLayer:(GameScene *)layer andFile:(NSString *)file forWorld:(b2World *)world andPosition:(CGPoint)position
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        [self createBodyForWorld:world];
        self.power = 2;
    }
    return self;
}

-(void)createBodyForWorld:(b2World*)world
{
    _world = world;
    // body definition
    
    self.sprite.tag = 3;
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
    paintFixtureDef.filter.categoryBits = 0x0008;
    paintFixtureDef.filter.maskBits = 0x0001 | 0x0016;
    
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
