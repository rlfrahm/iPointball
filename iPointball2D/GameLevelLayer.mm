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
        
#if 1
        // Batch node. Faster
        CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"player.png" capacity:100];
        spriteTexture_ = [parent texture];
#else
        // doesn't use batch node. Slower
        spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"player.png"];
        CCNode *parent = [CCNode node];
#endif
        [self addChild:parent z:0 tag:kTagParentNode];
        
        [self addNewPlayerAtPosition:ccp(10, winSize.height/2)];
        
        [self scheduleUpdate];
        
        //[player setPosition:ccp(player.contentSize.width/2, winSize.height/2)];
        
        // Add bunkers
    }
    return self;
}

-(void) dealloc{
    delete world;
    world = NULL;
    
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
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
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
    // Define the dynamic body.
    // Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    b2Body *body = world->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body
    b2PolygonShape dynamicBox;
    dynamicBox.SetAsBox(.5f, .5f); // These are mid points for our 1m box
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;
    body->CreateFixture(&fixtureDef);
    
    CCNode *parent = [self getChildByTag:kTagParentNode];
    
    // We have a 64 x 64 sprite sheet with 4 different 32 x 32 images.
    CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithTexture:spriteTexture_];
    [parent addChild:sprite];
    
    [sprite setPTMRatio:PTM_RATIO];
    [sprite setB2Body:body];
    [sprite setPosition:ccp(p.x,p.y)];
    
}

-(void) addNewEnemyAtPosition:(CGPoint)p{
    CCLOG(@"Add enemy %0.2f x %0.2f", p.x,p.y);
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CCLOG(@"Touch Began");
    NSArray *touchArray = [touches allObjects];
    
    // only run the following code if there is more than one touch
    if([touchArray count]>0)
    {
        // Choose one of the touches to work with
        UITouch *touch1 = [touchArray objectAtIndex:0];
        CGPoint location1 = [self convertTouchToNodeSpace:touch1];
        
        // Shoot Stuff!
        
        // Set up initial loaction of projectile
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // Shoot projectile
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


-(void) createMenu{
    
}

-(void) update:(ccTime)dt{
    [self enemyMoveDecision];
    
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    
    world->Step(dt, velocityIterations, positionIterations);
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
