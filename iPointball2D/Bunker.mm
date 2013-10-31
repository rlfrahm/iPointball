//
//  Object.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Bunker.h"
#import "Box2D.h"

#define PTM_RATIO 32

@implementation Bunker {
    b2World* _world;
}

-(id)initWithLayer:(GameScene *)layer andFile:(NSString *)file forWorld:(b2World *)world andPosition:(CGPoint)position
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        [self createBodyForWorld:world];
        [self createSnapPoints];
    }
    return self;
}

-(void)createBodyForWorld:(b2World*)world
{
    _world = world;
    // Define the dynamic body.
    // Set up a 1m squared box in the physics world
    self.sprite.tag = 4;
    b2BodyDef bunkerBodyDef;
    bunkerBodyDef.type = b2_staticBody;
    bunkerBodyDef.position.Set(self.sprite.position.x/PTM_RATIO, self.sprite.position.y/PTM_RATIO);
    bunkerBodyDef.userData = self.sprite;
    self.body = world->CreateBody(&bunkerBodyDef);
    
    b2PolygonShape bunkerShape;
    bunkerShape.SetAsBox(self.sprite.contentSize.width/PTM_RATIO/2, self.sprite.contentSize.height/PTM_RATIO/2);
    
    b2FixtureDef bunkerFixtureDef;
    bunkerFixtureDef.shape = &bunkerShape;
    bunkerFixtureDef.density = 1.0f;
    bunkerFixtureDef.restitution = 0.1f;
    bunkerFixtureDef.filter.categoryBits = 0x0016;
    bunkerFixtureDef.filter.maskBits = 0x0002 | 0x0004 | 0x0008;
    
    b2CircleShape playerTouchShape;
    playerTouchShape.m_radius = 1.0f;
    
    b2FixtureDef playerTouchFixtureDef;
    playerTouchFixtureDef.shape = &playerTouchShape;
    playerTouchFixtureDef.density = 1.0f;
    playerTouchFixtureDef.filter.categoryBits = 0x0016;
    playerTouchFixtureDef.filter.maskBits = 0x0001;
    
    self.fixture = self.body->CreateFixture(&playerTouchFixtureDef);
    
    self.body->CreateFixture(&bunkerFixtureDef);
}

-(void)createSnapPoints
{
    
}

@end
