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
#import "AIStateDefensive.h"
#import "Paint.h"

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
    GameScene* _layer;
    BOOL _cw;
    int _count;
}

@synthesize  eye,target,canSeePlayer,lastShot,rayAngle,file;

-(id)initWithLayer:(GameScene *)layer andFile:(NSString *)file forWorld:(b2World *)world andPosition:(CGPoint)position wNumOnOppTeam:(int)number
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        self.team = 2;
        [self createBodyForWorld:world];
        self.knownNumberOfPlayers = number;
        //_currentState = [[AIStateStarting alloc] init];
        _currentState = [[AIStateDefensive alloc] init];
        self.lineOfSight = -1.57;
        self.rayAngle = -2;
        _layer = layer;
        CCLOG(@"%@", [self stateName]);
        _cw = true;
        _count = 0;
        //[super onEnter];
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
    enemyFixtureDef.filter.maskBits = 0x0001 | 0x0016 | 0x0002;
    
    self.fixture = self.body->CreateFixture(&enemyFixtureDef);
}

-(void)changeState:(id)state
{
    [_currentState exit:self];
    _currentState = state;
    CCLOG(@"%@",state);
    [_currentState enter:self];
}

-(NSString*)stateName
{
    return _currentState.name;
}

-(void)rayCast
{
    b2Vec2 p1 = self.body->GetWorldCenter();
    
    if(_cw) {
        self.rayAngle += 360 / 100.0 / 60.0;
    } else {
        self.rayAngle -= 360 / 100.0 / 60.0;
    }
     //*/
    
    if(self.rayAngle > self.lineOfSight + 0.7854) {
        _cw = false;
    } else if(self.rayAngle < self.lineOfSight - 0.7854) {
        _cw = true;
    }
    
    float rayLength = 25;
    b2Vec2 p2 = p1 + rayLength*b2Vec2(sinf(self.rayAngle), cosf(self.rayAngle));
    
    self.eye = ccp(p1.x*PTM_RATIO, p1.y*PTM_RATIO);
    //self.target = ccp(p2.x*PTM_RATIO, p2.y*PTM_RATIO);
    
    b2RayCastInput input;
    input.p1 = p1;
    input.p2 = p2;
    input.maxFraction = 1;
    
    float closestFraction = 1;
    b2Vec2 intersectionNormal(0,0);
    for(b2Body* b = _world->GetBodyList();b; b = b->GetNext())
    {
        for(b2Fixture* f = b->GetFixtureList(); f; f->GetNext())
        {
            b2RayCastOutput output;
            if(!f->RayCast(&output, input, 0))
            {
                //self.canSeePlayer = NO;
                //continue;
            }
            if(output.fraction < closestFraction)
            {
                closestFraction = output.fraction;
                intersectionNormal = output.normal;
                //self.canSeePlayer = YES;
                break;
            }
        }
        break;
    }
    
    b2Vec2 intersectionPoint = p1 + closestFraction * (p2 - p1);
    self.target = ccp(intersectionPoint.x, intersectionPoint.y);
    intersectionNormal = b2Vec2(intersectionNormal.x * -1, intersectionNormal.y * -1);
    
    if(self.canSeePlayer == YES)
    {
        if(_count == 10) {
            Paint* paint = [[Paint alloc] initWithLayer:self.layer andFile:file forWorld:_world andPosition:self.sprite.position];
            [paint fireToLocationWithNormal:intersectionNormal];
            _count = 0;
        }
        
        _count++;
        self.color = YES; //;
    } else {
        self.color = NO; //
    }
    //*/
}

-(void)think
{
    [self rayCast];
    
    [_currentState execute:self];
}

@end
