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
#define RAYS 10

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
    float _bounda;
    float _boundb;
    float _delta;
    float _rays[RAYS];
}

@synthesize  eye,target,canSeePlayer,lastShot,rayAngle,file;

-(id)initWithLayer:(GameScene *)layer andFile:(NSString *)file forWorld:(b2World *)world andPosition:(CGPoint)position wNumOnOppTeam:(int)number
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        self.team = 2;
        [self createBodyForWorld:world];
        self.knownNumberOfPlayers = number;
        _currentState = [[AIStateStarting alloc] init];
        self.eyesight = -1.57;
        self.rayAngle = -1.57;
        _layer = layer;
        CCLOG(@"%@", [self stateName]);
        _cw = true;
        _count = 0;
        _delta = 1.57 / RAYS;
        self.coverOptions = [[NSMutableArray alloc]init];
        self.targetOptions = [[NSMutableArray alloc]init];
        [self initRays];
        //[super onEnter];
    }
    return self;
}

-(void)initRays
{
    _rays[0] = _boundb;
    for(int i=1;i<RAYS;i++) {
        _rays[i] = _rays[i-1] + _delta;
    }
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
    _bounda = self.eyesight + 0.7854;
    _boundb = self.eyesight - 0.7854;
    
    [self scanTheField];
     //*/
    
    float rayLength = 10;
    
    b2Vec2 p2 = p1 + rayLength*b2Vec2(sinf(self.eyesight), cosf(self.eyesight));
    
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
            if(fabsf(output.fraction) < closestFraction && fabsf(output.fraction) > 0.001)
            {
                CCLOG(@"%f",output.fraction);
                //CCLOG(@"Output Fraction: %f", output.fraction);
                //CCLOG(@"Closest Fraction: %f", closestFraction);
                closestFraction = fabsf(output.fraction);
                intersectionNormal = output.normal;
                if(b->GetUserData() != NULL) {
                    CCSprite* s = (CCSprite*)b->GetUserData();
                    if(s.tag == 1) {
                        b2Vec2 ip(p1 + closestFraction * (p2 - p1));
                        CGPoint pt = ccp(ip.x*PTM_RATIO, ip.y*PTM_RATIO);
                        [self.targetOptions addObject:[NSValue valueWithCGPoint:pt]];
                        
                        // Make additional state decisions
                        
                        self.canSeePlayer = YES;
                    } else if(s.tag == 4) {
                        b2Vec2 ip(p1 + closestFraction * (p2 - p1));
                        CGPoint pt = ccp(ip.x, ip.y);
                        // Add ip to list of possible covers
                        //[self.coverOptions addObject:s];
                        [self.coverOptions addObject:[NSValue valueWithCGPoint:pt]];
                        
                        // Make additional state decisions
                        
                        self.canSeePlayer = NO;
                    } else {
                        // Make additional state decisions
                        
                        self.canSeePlayer = NO;
                    }
                }
                break;
            }
            break;
        }
    }
    //NSValue* v = [self.coverOptions objectAtIndex:0];
    //CGPoint pt = [v CGPointValue];
    //CCLOG(@"%f, %f", pt.x, pt.y);
    
    b2Vec2 intersectionPoint = p1 + closestFraction * (p2 - p1);
    
    self.target = ccp(intersectionPoint.x*PTM_RATIO, intersectionPoint.y*PTM_RATIO);
    intersectionNormal = b2Vec2(intersectionNormal.x * -1, intersectionNormal.y * -1);
    //*/
    self.eye = ccp(p1.x*PTM_RATIO, p1.y*PTM_RATIO);
    //self.target = ccp(p2.x*PTM_RATIO, p2.y*PTM_RATIO);
    
    /*if(self.canSeePlayer == YES)
    {
        if(_count == 10) {
            Paint* paint = [[Paint alloc] initWithLayer:self.layer andFile:file forWorld:_world andPosition:self.sprite.position];
            [paint fireToLocationWithNormal:intersectionNormal];
            _count = 0;
        }
        
        _count++;
    } else {
        self.canSeePlayer = NO;
    }
    //*/
}

-(void)scanTheField
{
    if(_cw) {
        self.eyesight += 360 / 100.0 / 60.0;
    } else {
        self.eyesight -= 360 / 100.0 / 60.0;
    }
    
    if(!self.canSeePlayer) {
        if(self.eyesight >  self.rayAngle + 0.7854) {
            self.eyesight = self.rayAngle + 0.7854;
            _cw = false;
        } else if(self.eyesight < self.rayAngle - 0.7854) {
            self.eyesight = self.rayAngle - 0.7854;
            _cw = true;
        }
    } else {
        //self.eyesight = (self.target.y - self.eye.y) / (self.target.x - self.eye.x);
    }
}

-(void)fireToPoint:(CGPoint)point
{
    Paint* paint = [[Paint alloc] initWithLayer:self.layer andFile:file forWorld:_world andPosition:self.sprite.position];
    float a = (point.y - self.eye.y) / (point.x - self.eye.x);
    [paint fireToLocation:point withAngle:a];
}

class MyQueryCallback : public b2QueryCallback {
public:
    std::vector<b2Body *>foundBodies;
    
    bool ReportFixture(b2Fixture* fixture){
        foundBodies.push_back(fixture->GetBody());
        return true;
    }
};

-(void)think
{
    [self rayCast];
    [_currentState execute:self];
}

@end
