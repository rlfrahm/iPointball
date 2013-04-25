//
//  GameLevelLayer.mm
//  iPointball2D
//
//  Created by Ryan Frahm on 4/6/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//
// Notes on removing bodies
// http://www.iforce2d.net/b2dtut/removing-bodies

#import "GameLevelLayer.h"
#import "GameOverLayer.h"
#import "CCPhysicsSprite.h"
#import "Player.h"

enum {
    kTagParentNode = 1,
};

enum CATEGORY_BITS
{
    PLAYER_CATEGORY_BITS = 0x00000001,
    ENEMY_CATEGORY_BITS = 0x00000002,
    PAINT_CATEGORY_BITS = 0x00000004,
};

#pragma mark - GameLevelLayer

#define PAINTFPS 680 // pixels/sec
#define PTM_RATIO 32 // pixels-meters

@interface GameLevelLayer()
-(void) initPhysics;
-(void) addNewPlayerAtPosition:(CGPoint)p;
-(void) addNewEnemyAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation GameLevelLayer

@synthesize cache = _cache;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLevelLayer *layer = [GameLevelLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) gameLogic:(ccTime)delta{
    
}

-(id) init{
    if (self = [super initWithColor:ccc4(255,255,255,255)]) {
        
        // enable events
        
        self.touchEnabled = YES;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // init physics
        [self initPhysics];
        
        // create menu
        // [self createMenu];
        
        // set up sprite
        
/*#if 1
        // Batch node. Faster
        CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"player.png" capacity:100];
        spriteTexture_ = [parent texture];
#else
        // doesn't use batch node. Slower
        spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"player.png"];
        CCNode *parent = [CCNode node];
#endif
        [self addChild:parent z:0 tag:kTagParentNode];*/
        
        [self addNewPlayerAtPosition:ccp(winSize.width/2, winSize.height/2)];
        
        //[self addNewEnemyAtPosition:ccp(470, winSize.height/2)];
        
        [self scheduleUpdate];
        
        //[player setPosition:ccp(player.contentSize.width/2, winSize.height/2)];
        
        // Add bunkers
        
        // collision detection
        contactListener = new MyContactListener();
        world->SetContactListener(contactListener);
    }
    return self;
}

-(void)draw{
    [super draw];
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
    
    kmGLPushMatrix();
    world->DrawDebugData();
    
    kmGLPushMatrix();
}

-(void) dealloc{
    delete world;
    world = NULL;
    
    delete _debugDraw;
    
    delete contactListener;
    
    [_cache release];
    _cache = nil;
    
    [super dealloc];
}

-(void) initPhysics{
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);
    world = new b2World(gravity);
    
    // Do we want to let bodies sleep?
    world->SetAllowSleeping(true);
    
    world->SetContinuousPhysics(true);
    
    _debugDraw = new GLESDebugDraw(PTM_RATIO);
    world->SetDebugDraw(_debugDraw);
    
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    //		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	_debugDraw->SetFlags(flags);
    
    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner
    
    // Call the body factory which allocates memory for the ground body
    // from a pool that creates the ground box shape (also from a pool).
    // The body is also added to the world.
    groundBody = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2EdgeShape groundBox;
    
    // bottom
    groundBox.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // top
    groundBox.Set(b2Vec2(0,winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO,winSize.height/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    // left
    groundBox.Set(b2Vec2(0,winSize.height/PTM_RATIO), b2Vec2(0,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // right
    groundBox.Set(b2Vec2(winSize.width/PTM_RATIO,winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
}

-(void) addNewPlayerAtPosition:(CGPoint)p{
    //CCLOG(@"Add player %0.2f x %0.2f",player.position.x/PTM_RATIO,player.position.y/PTM_RATIO);
    
    /*_cache = [[CCArray alloc] initWithCapacity:53];
    
    Sprite *player = [[Player alloc] initWithWorld:world];
    [self addChild:player z:1];
    [player activateCollisions];
    [_cache addObject:player];*/
    
    // Create player and add it to the layer
    player = [CCSprite spriteWithFile:@"Player.png"];
    player.position = p;
    player.tag = 1;
    [self addChild:player];
    
    // Define the dynamic body.
    // Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(player.position.x/PTM_RATIO, player.position.y/PTM_RATIO);
    bodyDef.userData = player;
    bodyDef.angle = 0;
    bodyDef.fixedRotation = true;
    playerBody = world->CreateBody(&bodyDef);
    
    // Create player shape
    b2PolygonShape playerShape;
    playerShape.SetAsBox(player.contentSize.width/PTM_RATIO/2, player.contentSize.height/PTM_RATIO/2); // These are mid points for our 1m box
    
    // Create shape definition and add to body
    b2FixtureDef playerShapeDef;
    playerShapeDef.shape = &playerShape;
    playerShapeDef.density = 10.0f;
    playerShapeDef.friction = 0.4f;
    playerShapeDef.restitution = 0.1f;
    _playerFixture = playerBody->CreateFixture(&playerShapeDef);
    
    /*
    CCNode *parent = [self getChildByTag:kTagParentNode];
    
    // We have a 64 x 64 sprite sheet with 4 different 32 x 32 images.
    CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithTexture:spriteTexture_];
    [parent addChild:sprite];
    
    [sprite setPTMRatio:PTM_RATIO];
    [sprite setB2Body:body];
    [sprite setPosition:ccp(p.x,p.y)];*/
    
}

-(void) addNewEnemyAtPosition:(CGPoint)p{
    CCLOG(@"Add enemy %0.2f x %0.2f", p.x,p.y);
    
    // Create enemy and add it to the layer
    enemy = [CCSprite spriteWithFile:@"Target.png"];
    enemy.position = p;
    enemy.tag = 2;
    [self addChild:enemy];
    
    // Define the dynamic body
    // Set up a box in the physics world
    b2BodyDef enemyBodyDef;
    enemyBodyDef.type = b2_dynamicBody;
    enemyBodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    enemyBodyDef.userData = enemy;
    enemyBody = world->CreateBody(&enemyBodyDef);
    
    // Create player shape
    b2PolygonShape enemyShape;
    enemyShape.SetAsBox(enemy.contentSize.width/PTM_RATIO/2, enemy.contentSize.height/PTM_RATIO/2);
    
    // Create shape definition and add to body
    b2FixtureDef enemyShapeDef;
    enemyShapeDef.shape = &enemyShape;
    enemyShapeDef.density = 10.0f;
    enemyShapeDef.friction = 0.4f;
    enemyShapeDef.restitution = 0.1f;
    enemyFixture = enemyBody->CreateFixture(&enemyShapeDef);
    
    [_enemiesAlive addObject:enemy];
}

- (void) addNewMovingPaintToLocation:(CGPoint)p :(CGFloat)shootAngle{
    // Adds a bullet animation from the player or enemy towards p
    CCLOG(@"Paint is moving towards: %0.2f x %0.2f", p.x,p.y);
    
    b2Body *paintBody;
    
    int power = 2;
    float x1 = cos(shootAngle);
    float y1 = sin(shootAngle);
    
    // Create paint and add it to the layer
    paint = [CCSprite spriteWithFile:@"Projectile.png"];
    paint.position = player.position;
    paint.tag = 3;
    [self addChild:paint];
    
    // body definition
    b2BodyDef paintBodyDef;
    paintBodyDef.type = b2_dynamicBody;
    paintBodyDef.position.Set(paint.position.x/PTM_RATIO, paint.position.y/PTM_RATIO);
    paintBodyDef.userData = paint;
    paintBodyDef.bullet = true;
    paintBody = world->CreateBody(&paintBodyDef);
    
    // shape definiation
    b2CircleShape paintShape;
    paintShape.m_radius = 7.0/PTM_RATIO;
    
    // Create shape definition and add to body
    b2FixtureDef paintFixtureDef;
    paintFixtureDef.shape = &paintShape;
    paintFixtureDef.density = 1.0f;
    //paintFixtureDef.filter.categoryBits = PAINT_CATEGORY_BITS;
    //paintFixtureDef.filter.maskBits = PAINT_CATEGORY_BITS | ENEMY_CATEGORY_BITS;
    //paintShapeDef.friction = 0.0f;
    //paintShapeDef.restitution = 1.0f;
    
    paintFixture = paintBody->CreateFixture(&paintFixtureDef);
    
    //
    // Shoot the paint
    //
    
    // Using Physics
    // Determine offset between the paint and destination p
    b2Vec2 force = b2Vec2(x1*power,y1*power);
    
    //paintBody->ApplyForceToCenter(force);
    paintBody->ApplyLinearImpulse(force, paintBody->GetWorldCenter());
    //CCLOG(@"Impulse: %0.2f x %0.2f, Point: %0.2f x %0.2f", impulse.x, impulse.y, p.x, p.y);
    
    [_paint addObject:paint];
}

- (void) addBunkerAtPosition:(CGPoint)p{
    
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CCLOG(@"Touch Began");
    NSArray *touchArray = [touches allObjects];
    
    // only run the following code if there is more than one touch
    if([touchArray count]>0)
    {
        // Choose one of the touches to work with
        UITouch *touch1 = [touchArray objectAtIndex:0];
        CGPoint location = [touch1 locationInView:[touch1 view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        CGPoint shootVector = ccpSub(location, paint.position);
        CGFloat shootAngle = ccpToAngle(shootVector);
        CGPoint normalizedShootVector = ccpNormalize(shootVector);
        CGPoint overshotVector = ccpMult(normalizedShootVector, 420);
        CGPoint offscreenPoint = ccpAdd(paint.position, overshotVector);
        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
        
        if (_playerFixture->TestPoint(locationWorld)) {
            b2MouseJointDef md;
            md.bodyA = groundBody;
            md.bodyB = playerBody;
            md.target = locationWorld;
            md.collideConnected = true;
            md.maxForce = 1000.0f * playerBody->GetMass();
            
            _mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
            playerBody->SetAwake(true);
        } else {
            // Shoot Stuff!
            [self addNewMovingPaintToLocation:location :shootAngle];
        }
        
        
        
        // Set up initial location of projectile
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
        // Shoot projectile
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CCLOG(@"Touch Moved");
    
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location1 = [myTouch locationInView:[myTouch view]];
    location1 = [[CCDirector sharedDirector] convertToGL:location1];
    b2Vec2 locationWorld = b2Vec2(location1.x/PTM_RATIO, location1.y/PTM_RATIO);
        
    _mouseJoint->SetTarget(locationWorld);
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_mouseJoint) {
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_mouseJoint){
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

- (void) handleTap:(UITapGestureRecognizer *)sender{
    // Enable double tap gesture recognizer to simulate a slide or something
}


-(void) createMenu{
    
}

-(void) update:(ccTime)dt{
    
    int32 velocityIterations = 10;
    int32 positionIterations = 5;
    
    world->Step(dt, velocityIterations, positionIterations);
    
    player.position = ccp(playerBody->GetPosition().x*PTM_RATIO, playerBody->GetPosition().y*PTM_RATIO);
    
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        CCSprite *spriteA, *spriteB;
        b2Body *bodyA, *bodyB;
        
        if ((contact.fixtureA == _playerFixture && contact.fixtureB == bunkerFixture) || (contact.fixtureA == bunkerFixture && contact.fixtureB == _playerFixture))
        {
            CCLOG(@"Player hit the bunker!");
            // Bounce off?
        }
        else if ((contact.fixtureA == enemyFixture && contact.fixtureB == bunkerFixture) || (contact.fixtureA == bunkerFixture && contact.fixtureB == enemyFixture))
        {
            CCLOG(@"Enemy hit the bunker!");
            // Bounce off?
        }
        else if ((contact.fixtureA == _playerFixture && contact.fixtureB == paintFixture) || (contact.fixtureA == paintFixture && contact.fixtureB == _playerFixture))
        {
            CCLOG(@"Player got hit by paint!");
            /*// Not sure if destroy player
            // Destroy paint
            CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
            
            bodyA = contact.fixtureA->GetBody();
            bodyB = contact.fixtureB->GetBody();*/
        }
        else if ((contact.fixtureA == enemyFixture && contact.fixtureB == paintFixture) || (contact.fixtureA == paintFixture && contact.fixtureB == enemyFixture))
        {
            CCLOG(@"Enemy got hit by paint!");
            // Destroy enemy and paint
            if ([_enemiesAlive count] == 0) {
                CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
            }
            
            bodyA = contact.fixtureA->GetBody();
            bodyB = contact.fixtureB->GetBody();
        }
        
        
        /*if(bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL)
        {
            spriteA = (CCSprite *) bodyA->GetUserData();
            spriteB = (CCSprite *) bodyB->GetUserData();
            CCLOG(@"User data A:%@ B:%@", spriteA, spriteB);
            // spriteA = player, spriteB = paint
            if(spriteA.tag == 1 && spriteB.tag == 3)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                {
                    toDestroy.push_back(bodyB);
                }
            }
            
            // spriteA = player, spriteB = paint
            else if(spriteA.tag == 3 && spriteB.tag == 1)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                {
                    toDestroy.push_back(bodyA);
                }
            }
            
            // spriteA = player, spriteB = paint
            else if(spriteA.tag == 2 && spriteB.tag == 3)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                {
                    toDestroy.push_back(bodyB);
                }
            }
            
            // spriteA = player, spriteB = paint
            else if(spriteA.tag == 3 && spriteB.tag == 2)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                {
                    toDestroy.push_back(bodyA);
                }
            }
            
        }
        else
        {
            CCLOG(@"User data A:%@ B:%@", spriteA, spriteB);
        }*/
    }
    
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2)
    {
        b2Body *body = *pos2;
        if(body ->GetUserData() != NULL)
        {
            CCSprite *sprite = (CCSprite *) body->GetUserData();
            [self removeChild:sprite cleanup:YES];
        }
        world->DestroyBody(body);
    }
}

-(void) enemyMoveDecision{
    CCLOG(@"Enemy is thinking..");
    
    // Determine where to spawn computer
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = 0;
    int maxY = winSize.height;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create computer on right edge of screen in random position
    enemy.position = ccp(winSize.width - enemy.contentSize.width/2, actualY);
    [self addChild:enemy];
    
    // Determine speed of the computer
    int minDuration = 8.0;
    int maxDuration = 10.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    /*CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-computer.contentSize.width/2, actualY)];
     CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
     [_computers removeObject:node];
     [node removeFromParentAndCleanup:YES];
     }];
     [computer runAction:[CCSequence actions:actionMove,actionMoveDone, nil]];*/
}

@end
