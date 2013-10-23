//
//  AIPlayer.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/9/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "AIPlayer.h"
#import "GameScene.h"
#import "Box2D.h"
#import "AIState.h"
#import "AIStateStarting.h"

#define PTM_RATIO 32

/*typedef enum {
    StateStarting = 0,
    StateOffensive,
    StateDefensive,
    StateCTF
}State;*/

@implementation AIPlayer {
    b2World* _world;
    AIState* _currentState;
}

-(id)initWithLayer:(GameScene *)layer andFile:(NSString *)file forWorld:(b2World *)world andPosition:(CGPoint)position wNumOnOppTeam:(int)number
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        self.team = 2;
        [self createBodyForWorld:world];
        self.knownNumberOfPlayers = number;
        _currentState = [[AIStateStarting alloc] init];
        //[self scheduleUpdate];
    }
    return self;
}

-(void)createBodyForWorld:(b2World*)world
{
    _world = world;
    // Define the dynamic body
    // Set up a box in the physics world
    self.sprite.tag = 2;
    b2BodyDef enemyBodyDef;
    enemyBodyDef.type = b2_dynamicBody;
    enemyBodyDef.position.Set(self.sprite.position.x/PTM_RATIO, self.sprite.position.y/PTM_RATIO);
    enemyBodyDef.userData = self.sprite;
    enemyBodyDef.fixedRotation = true;
    self.body = world->CreateBody(&enemyBodyDef);
    
    // Create player shape
    b2PolygonShape enemyShape;
    enemyShape.SetAsBox(self.sprite.contentSize.width/PTM_RATIO/2, self.sprite.contentSize.height/PTM_RATIO/2);
    
    // Create shape definition and add to body
    b2FixtureDef enemyFixtureDef;
    enemyFixtureDef.shape = &enemyShape;
    enemyFixtureDef.density = 1000.0f;
    enemyFixtureDef.friction = 0.4f;
    enemyFixtureDef.restitution = 0.1f;
    enemyFixtureDef.filter.categoryBits = 0x0004;
    enemyFixtureDef.filter.maskBits = 0x0008 | 0x0001 | 0x0016 | 0x0002;
    
    self.fixture = self.body->CreateFixture(&enemyFixtureDef);
}

-(void)changeState:(id)state
{
    [_currentState exit:self];
    _currentState = state;
    [_currentState enter:self];
}

-(void)update:(ccTime)delta
{
    [_currentState execute:self];
    [super update:delta];
}

@end
