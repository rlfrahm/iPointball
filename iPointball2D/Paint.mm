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
    paintFixtureDef.filter.maskBits = 0x0004 | 0x0001 | 0x0016;
    
    //paintShapeDef.friction = 0.0f;
    //paintShapeDef.restitution = 1.0f;
    
    self.body->CreateFixture(&paintFixtureDef);
}

-(void)fireToLocation:(CGPoint)point withAngle:(CGFloat)shootAngle
{
    int power = 2;
    float x1 = cos(shootAngle);
    float y1 = sin(shootAngle);
    
    b2Vec2 force = b2Vec2(x1*power,y1*power);
    //paintBody->ApplyForceToCenter(force);
    self.body->ApplyLinearImpulse(force, self.body->GetWorldCenter());
}

-(void)fireToLocationWithNormal:(b2Vec2)normal andPower:(float)power
{
    b2Vec2 force = b2Cross(normal, power);
    self.body->ApplyLinearImpulse(force, self.body->GetWorldCenter());
}

@end
