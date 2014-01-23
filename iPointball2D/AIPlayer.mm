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
#import "Marker.h"

#define RAYS 10
#define FOURTY_FIVE_DEGREES 0.785
#define NINETY_DEGRESS 1.57

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
    float _angle2;
}

@synthesize  eye,target,canSeePlayer,lastShot,rayAngle;

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
        _delta = 3 / RAYS;
        self.coverOptions = [[NSMutableArray alloc]init];
        self.targetOptions = [[NSMutableArray alloc]init];
        self.rayVectors = [[NSMutableArray alloc] initWithCapacity:RAYS];
        [self initRays];
        self.marker = [[Marker alloc] initWithAccuracy:10];
        [self.marker setHopperCapacity:50];
        [self.marker setPaintLeftInHopper:[self.marker getHopperCapacity]];
        self.pods = 3;
        self.speed = 1 + (10/10);
        self.reload = 10;
        self.pod = [[Pod alloc] init];
        self.pod.capacity = 40;
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
    enemyFixtureDef.filter.categoryBits = kCategoryBitsAiPlayer;
    enemyFixtureDef.filter.maskBits = kCategoryBitsWorld | kCategoryBitsHumanPlayer | kCategoryBitsHumanPaint | kCategoryBitsBunker;
    
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

-(void)rayCastMultiple {
    [self.targetOptions removeAllObjects];
    [self.rayVectors removeAllObjects];
    
    b2Vec2 p1 = self.body->GetWorldCenter();
    float startAngle = self.eyesight - FOURTY_FIVE_DEGREES, raylength = 10;
    
    for(int i=0; i<RAYS; i++) {
        _rays[i] = startAngle + (_delta * i);
        b2Vec2 pt = (p1 + raylength * b2Vec2(sinf(_rays[i]), cosf(_rays[i])));
        [self.rayVectors addObject:[NSValue valueWithCGPoint:ccp(pt.x, pt.y)]];
    }
    
    self.eye = ccp(p1.x*PTM_RATIO, p1.y*PTM_RATIO);
}

-(void)rayCast
{
    //[self.targetOptions removeAllObjects];
    
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
    CGPoint pt;
    NSString* type = @"none";
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
                //CCLOG(@"%f",output.fraction);
                //CCLOG(@"Output Fraction: %f", output.fraction);
                //CCLOG(@"Closest Fraction: %f", closestFraction);
                closestFraction = fabsf(output.fraction);
                intersectionNormal = output.normal;
                if(b->GetUserData() != NULL) {
                    CCSprite* s = (CCSprite*)b->GetUserData();
                    if(s.tag == 1) { // If the ray is intersecting a human player
                        b2Vec2 ip(p1 + closestFraction * (p2 - p1));
                        pt = ccp(ip.x*PTM_RATIO, ip.y*PTM_RATIO);
                        type = @"target";
                    } else if(s.tag == 4) { // If the ray is intersecting a bunker
                        b2Vec2 ip(p1 + closestFraction * (p2 - p1));
                        pt = ccp(ip.x, ip.y);
                        type = @"cover";
                    } else if(s.tag == 3){ // If the ray is intersecting paint
                        type = @"paint";
                    } else {
                        
                    }
                }
                break;
            }
            break;
        }
    }
    
    if([type hasPrefix:@"t"]) {
        [self.targetOptions setObject:[NSValue valueWithCGPoint:pt] atIndexedSubscript:0];
        self.canSeePlayer = YES;
    } else if([type hasPrefix:@"c"]) {
        [self.coverOptions addObject:[NSValue valueWithCGPoint:pt]];
        self.canSeePlayer = NO;
    } else {
        self.canSeePlayer = NO;
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
    
    if(self.canSeePlayer == YES)
    {
        if(_count == 5) {
            [self shootPaintToLocation:[[self.targetOptions objectAtIndex:0] CGPointValue]];
            _count = 0;
        }
        _count++;
    } else {
        self.canSeePlayer = NO;
    }
    //*/
}

-(void)scheduleRaycast:(CGPoint)pt
{
    
}

-(void)scanTheField
{
    if(_cw) {
        self.eyesight += 360 / 100.0 / 60.0;
    } else {
        self.eyesight -= 360 / 100.0 / 60.0;
    }
    
    if(self.eyesight >  self.rayAngle + 0.7854) {
        self.eyesight = self.rayAngle + 0.7854;
        _cw = false;
    } else if(self.eyesight < self.rayAngle - 0.7854) {
        self.eyesight = self.rayAngle - 0.7854;
        _cw = true;
    }
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
    //[self rayCastMultiple];
    [self rayCast];
    [_currentState execute:self];
}

@end
