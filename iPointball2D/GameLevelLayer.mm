//
//  GameLevelLayer.mm
//  iPointball2D
//
//  Created by Ryan Frahm on 4/6/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import "GameLevelLayer.h"

#import "CCPhysicsSprite.h"

enum {
    kTagParentNode = 1,
};

#pragma mark - GameLevelLayer

#define PAINTFPS 680 // pixels/sec

@interface GameLevelLayer()
-(void) initPhysics;
-(void) addNewPlayerAtPosition:(CGPoint)p;
-(void) addNewEnemyAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation GameLevelLayer

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
        
        [self addNewPlayerAtPosition:ccp(10, winSize.height/2)];
        
        [self scheduleUpdate];
        
        //[player setPosition:ccp(player.contentSize.width/2, winSize.height/2)];
        
        // Add bunkers
        
        // collision detection
        contactListener = new MyContactListener();
        world->SetContactListener(contactListener);
    }
    return self;
}

-(void) dealloc{
    delete world;
    world = NULL;
    
    delete contactListener;
    
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
    
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    //		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	//m_debugDraw->SetFlags(flags);
    
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
    CCLOG(@"Add player %0.2f x %0.2f",p.x,p.y);
    
    // Create player and add it to the layer
    player = [CCSprite spriteWithFile:@"player.png"];
    player.position = p;
    [self addChild:player];
    
    // Define the dynamic body.
    // Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    bodyDef.userData = player;
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
    enemy = [CCSprite spriteWithFile:@"enemy.png"];
    enemy.position = p;
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
}

- (void) addNewMovingPaintToLocation:(CGPoint)p{
    // Adds a bullet animation from the player or enemy towards p
    CCLOG(@"Paint is moving towards: %0.2f x %0.2f", p.x,p.y);
    
    // Create paint and add it to the layer
    paint = [CCSprite spriteWithFile:@"Projectile.png"];
    paint.position = player.position;
    [self addChild:paint];
    
    // Define the dynamic body
    b2BodyDef paintBodyDef;
    paintBodyDef.type = b2_dynamicBody;
    paintBodyDef.position.Set(paint.position.x/PTM_RATIO, paint.position.y/PTM_RATIO);
    paintBodyDef.userData = enemy;
    paintBody = world->CreateBody(&paintBodyDef);
    
    // Create player shape
    b2PolygonShape paintShape;
    //
    //
    // NEEDS TO BE CIRCLE SHAPE!!!********************************************
    //
    //
    paintShape.SetAsBox(paint.contentSize.width/PTM_RATIO/2, paint.contentSize.height/PTM_RATIO/2);
    
    // Create shape definition and add to body
    b2FixtureDef paintShapeDef;
    paintShapeDef.shape = &paintShape;
    paintShapeDef.density = 10.0f;
    paintShapeDef.friction = 0.4f;
    paintShapeDef.restitution = 0.1f;
    paintFixture = paintBody->CreateFixture(&paintShapeDef);
    
    //
    // Shoot the paint
    //
    
    // Using Physics
    // Determine offset between the paint and destination p
    CGPoint offset = ccpSub(p, player.position);
    b2Vec2 impulse = b2Vec2(offset.x,offset.y);
    b2Vec2 point = b2Vec2(paintBody->GetWorldCenter().x, paintBody->GetWorldCenter().y);
    paintBody->ApplyLinearImpulse(impulse, point);
    
    // Using Animations
    /*CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    float ratio = offset.y/offset.x;
    float xTravelLength = winSize.width - player.position.x;
    float yTravelLength = ratio * xTravelLength + player.position.y;
    // Pythagorean theorem
    float distance = sqrtf((offset.x*offset.x) + (offset.y*offset.y));
    float paintTravelTime = distance/PAINTFPS;
    
    CGPoint realDest = ccp(p.x,p.y);
    
    // Move paint to actual endpoint
    [paint runAction:[CCSequence actions:[CCMoveTo actionWithDuration:paintTravelTime position:realDest], [CCCallBlockN actionWithBlock:^(CCNode *node) {
        //
        // Destroy paint
        //
        [node removeFromParentAndCleanup:YES];
    }], nil]];*/
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
        CGPoint location1 = [touch1 locationInView:[touch1 view]];
        location1 = [[CCDirector sharedDirector] convertToGL:location1];
        b2Vec2 locationWorld = b2Vec2(location1.x/PTM_RATIO, location1.y/PTM_RATIO);
        
        if (_playerFixture->TestPoint(locationWorld)) {
            b2MouseJointDef md;
            md.bodyA = groundBody;
            md.bodyB = playerBody;
            md.target = locationWorld;
            md.collideConnected = true;
            md.maxForce = 1000.0f * playerBody->GetMass();
            
            _mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
            playerBody->SetAwake(true);
        }
        
        // Shoot Stuff!
        
        // Set up initial loaction of projectile
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // Shoot projectile
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CCLOG(@"Touch Moved");
    
    if (_mouseJoint == NULL) return;
    
    NSArray *touchArray = [touches allObjects];
    
    if([touchArray count]>0)
    {
        UITouch *touch1 = [touchArray objectAtIndex:0];
        CGPoint location1 = [touch1 locationInView:[touch1 view]];
        location1 = [[CCDirector sharedDirector] convertToGL:location1];
        b2Vec2 locationWorld = b2Vec2(location1.x/PTM_RATIO, location1.y/PTM_RATIO);
        
        _mouseJoint->SetTarget(locationWorld);
    }
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
    
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    
    world->Step(dt, velocityIterations, positionIterations);
    
    std::vector<MyContact>::iterator pos;
    for(pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        // TODO Finish
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
