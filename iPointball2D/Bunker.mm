//
//  Object.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Bunker.h"
#import "Box2D.h"

@implementation Bunker {
    b2World* _world;
}

-(id)initWithLayer:(GameScene *)layer andFile:(NSString *)file forWorld:(b2World *)world andPosition:(CGPoint)position
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        [self createBodyForWorld:world];
        [self createSnapPoints];
        self.moveBounds = [NSArray arrayWithObjects:[NSNumber numberWithInt:20],[NSNumber numberWithInt:20], nil];
    }
    return self;
}

-(void)createBodyForWorld:(b2World*)world
{
    _world = world;
    // Define the dynamic body.
    // Set up a 1m squared box in the physics world
    self.sprite.tag = 5;
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
    bunkerFixtureDef.filter.categoryBits = kCategoryBitsBunker;
    bunkerFixtureDef.filter.maskBits = kCategoryBitsHumanPlayer | kCategoryBitsAiPlayer | kCategoryBitsHumanPaint | kCategoryBitsAiPaint;
    
    b2CircleShape playerTouchShape;
    playerTouchShape.m_radius = 1.0f;
    
    b2FixtureDef playerTouchFixtureDef;
    playerTouchFixtureDef.shape = &playerTouchShape;
    playerTouchFixtureDef.density = 1.0f;
    playerTouchFixtureDef.filter.categoryBits = kCategoryBitsBunker;
    playerTouchFixtureDef.filter.maskBits = kCategoryBitsWorld;
    
    self.fixture = self.body->CreateFixture(&playerTouchFixtureDef);
    
    self.body->CreateFixture(&bunkerFixtureDef);
}

-(void)createSnapPoints
{
    
}

-(b2Body*)getBody
{
    return self.body;
}

@end
