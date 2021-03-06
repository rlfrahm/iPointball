//
//  SceneName.m
//
// http://www.raywenderlich.com/32049/texture-packer-tutorial-how-to-create-and-optimize-sprite-sheets-in-cocos2d
//

#import "GameScene.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "HumanPlayer.h"
#import "AIPlayer.h"
#import "Bunker.h"
#import "Paint.h"
#import "PauseLayer.h"
#import "AppDelegate.h"
#import "HudLayer.h"

#define PAINTFPS 680 // pixels/sec

@implementation GameScene {
    NSMutableArray* _gameObjects;
    NSMutableArray* _aiplayers;
    HumanPlayer* _humanPlayer;
    CCSpriteBatchNode* _batchNode;
    AIPlayer* _aiPlayer;
    BOOL _gameOver;
    b2World* world;
    GameData* gameData;
    MyContactListener *contactListener;
    Level* levelData;
    Bunker* _bunker;
    Paint* _paint;
    Levels* levels;
    BOOL _moving;
    BOOL _moveToBunker;
    CGFloat _angle2;
    b2Body* _moveToBody;
    NSMutableArray* _objectsToDraw;
    NSUserDefaults* defaults;
    CCMenuItemFont* item2;
}
@synthesize iPad;

#pragma mark Touch Interaction methods

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //CCLOG(@"Touch Began");
    _moving = NO;
    NSArray *touchArray = [touches allObjects];
    // only run the following code if there is more than one touch
    if([touchArray count]>0)
    {
        // Choose one of the touches to work with
        for(UITouch* touch in [event allTouches]) {
            NSUInteger tapCount = [touch tapCount];
            CGPoint location = [touch locationInView:[touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
            if (_humanPlayer.fixture->TestPoint(locationWorld)) {
                b2MouseJointDef md;
                md.bodyA = groundBody;
                md.bodyB = _humanPlayer.body;
                md.target = locationWorld;
                md.collideConnected = false;
                md.maxForce = 20.0f * _humanPlayer.body->GetMass();
                _mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
                _humanPlayer.body->SetAwake(true);
            } else if(_bunker.fixture->TestPoint(locationWorld)) {
                if(tapCount == 2) {
                    [self doubleTap:location withBody:_bunker.body];
                }
            } else {
                if(!_humanPlayer.reloading) {
                    [self singleTap:location];
                }
            }
        }
    }
}

-(void)singleTap:(CGPoint)location
{
    //CCLOG(@"Single Tap!");
    origin = location;
    // Shoot Stuff!
    [_humanPlayer shootPaintToLocation:location];
    [item2 setString:[NSString stringWithFormat:@"%i",[_humanPlayer.marker getPaintLeftInHopper]]];
    
    firing = YES;
}

-(void)doubleTap:(CGPoint)location withBody:(b2Body*)bodyB
{
    CCLOG(@"Double Tap!");
    _moveToBunker = YES;
    [self moveToBunkerWithBody:bodyB];
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint location1 = [myTouch locationInView:[myTouch view]];
    if (_mouseJoint == NULL) return;
    _moving = YES;
    location1 = [[CCDirector sharedDirector] convertToGL:location1];
    // Insert speed here!
    moveToLocation = b2Vec2((location1.x/PTM_RATIO)*_humanPlayer.speed, (location1.y/PTM_RATIO)*_humanPlayer.speed);
    _mouseJoint->SetTarget(moveToLocation);
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

-(void)moveToBunkerWithBody:(b2Body*)body
{
    if(body->GetUserData() == NULL) {return;}
    if(_moveToBunker)
    {
        if(_humanPlayer.snapped) {_humanPlayer.snapped = NO;}
        CCSprite* sprite = (CCSprite*) body->GetUserData();
        //CCLOG(@"Distance: %f",ccpDistance(sprite.position, _humanPlayer.sprite.position));
        if(ccpDistance(sprite.position, _humanPlayer.sprite.position) < 25) {
            _humanPlayer.body->SetLinearVelocity(b2Vec2(0, 0));
            _moveToBunker = NO;
            _humanPlayer.snapped = YES;
            [_humanPlayer setMovementWindow:sprite.position];
            CCLOG(@"%hhd",_moveToBunker);
            return;
        }
        // Calculate unit vector
        
        //CCLOG(@"%f",ccpDistance(_humanPlayer.sprite.position, sprite.position));
        b2Vec2 vector = b2Vec2(sprite.position.x - _humanPlayer.sprite.position.x, sprite.position.y - _humanPlayer.sprite.position.y);
        //CCLOG(@"Vector -> %f : %f",vector.x, vector.y);
        vector.Normalize();
        //CCLOG(@"Normal -> %f : %f",vector.x, vector.y);
        // Then multiply is by _aiplayer.speed
        float massSpeed = _humanPlayer.body->GetMass() * _humanPlayer.speed;
        vector = b2Vec2(vector.x * massSpeed, vector.y * massSpeed);
        //vector = b2Cross(vector, massSpeed);
        //CCLOG(@"Crossed -> %f : %f",vector.x, vector.y);
        _humanPlayer.body->ApplyLinearImpulse(vector, _humanPlayer.body->GetWorldCenter());
        
        _moveToBody = body;
    }
}

# pragma mark Scene Transition methods

-(void)onOptions: (id) sender
{
    
}

- (void)onBack: (id) sender {
    /*
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goLevelSelect];
}

- (void)addBackButton {

    if (self.iPad) {
        // Create a menu image button for iPad
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Arrow-Normal-iPad.png"
                                                         selectedImage:@"Arrow-Selected-iPad.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(64, 64);
        
        // Add menu to this scene
        [self addChild: back];
    }
    else {
        // Create a menu image button for iPhone / iPod Touch
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Arrow-Normal-iPhone.png"
                                                         selectedImage:@"Arrow-Selected-iPhone.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(32, 32);

        // Add menu to this scene
        [self addChild: back];        
    }
}

# pragma mark Pause / Resume methods

-(void)pauseGame
{
    ccColor4B c = {100,100,0,100};
    PauseLayer* paused = [[[PauseLayer alloc] initWithColor:c andScene:self]autorelease];
    paused.position = ccp(0, 0);
    [self.parent addChild:paused z:10];
    [self onExit];
}

-(void)resume
{
    if(![AppController get].paused)
    {
        return;
    }
    [AppController get].paused = NO;
    
    [self onEnter];
}

-(void)onEnter
{
    if(![AppController get].paused)
    {
        [super onEnter];
    }
}

-(void) onExit
{
    if (![AppController get].paused)
    {
        [AppController get].paused = YES;
        [super onExit];
    }
}

# pragma mark Update methods

-(void) update:(ccTime)dt{
    
    int32 velocityIterations = 10;
    int32 positionIterations = 5;
    
    world->Step(dt, velocityIterations, positionIterations);
    
    // Update position of the texture for the bodies
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            /*
            if(sprite.tag == 3)
            {
                CGSize winsize = [[CCDirector sharedDirector] winSize];
                if(sprite.position.x - sprite.contentSize.width/2 <= 0)
                {
                    CCLOG(@"Destroy");
                }
                else if(sprite.position.x + sprite.contentSize.width/2 >= winsize.width)
                {
                    CCLOG(@"Destroy");
                }
                else if(sprite.position.y - sprite.contentSize.height/2 <= 0)
                {
                    CCLOG(@"Destroy");
                }
                else if(sprite.position.y + sprite.contentSize.height/2 >= winsize.height)
                {
                    CCLOG(@"Destroy");
                }
            }*/
        }
    }
    
    /*if(_humanPlayer.snapped == false && joybtn.tag == 1) {
        [self removeChild:joybtn cleanup:YES];
        joybtn.tag = 0;
    }
    
    if(_moveToBunker) {
        [self moveToBunkerWithBody:_moveToBody];
    }
    else if(_moveToBunker == NO && _humanPlayer.snapped) {
        if(_humanPlayer.sprite.position.y > _humanPlayer.topY) {
            _humanPlayer.body->SetLinearVelocity(b2Vec2(0,_humanPlayer.topY - _humanPlayer.sprite.position.y));
        } else if(_humanPlayer.sprite.position.y < _humanPlayer.btmY) {
            _humanPlayer.body->SetLinearVelocity(b2Vec2(0,_humanPlayer.btmY - _humanPlayer.sprite.position.y));
        }
        if (_humanPlayer.sprite.position.x < _humanPlayer.leftX) {
            _humanPlayer.body->SetLinearVelocity(b2Vec2(_humanPlayer.leftX - _humanPlayer.sprite.position.x,0));
        }
    }
    */
    for(AIPlayer* p in _aiplayers) [p think];
    
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        CCSprite *spriteA, *spriteB;
        b2Body *bodyA, *bodyB;
        
        bodyA = contact.fixtureA->GetBody();
        bodyB = contact.fixtureB->GetBody();
        
        
        
        if ((contact.fixtureA == _humanPlayer.fixture && contact.fixtureB == _bunker.fixture) || (contact.fixtureA == _bunker.fixture && contact.fixtureB == _humanPlayer.fixture))
        {
            //CCLOG(@"Player hit the bunker!");
            // Bounce off?
        }
        else if ((contact.fixtureA == _aiPlayer.fixture && contact.fixtureB == _bunker.fixture) || (contact.fixtureA == _bunker.fixture && contact.fixtureB == _aiPlayer.fixture))
        {
            //CCLOG(@"Enemy hit the bunker!");
            // Bounce off?
        }
        else if ((contact.fixtureA == _humanPlayer.fixture && contact.fixtureB == _paint.fixture) || (contact.fixtureA == _paint.fixture && contact.fixtureB == _humanPlayer.fixture))
        {
            //CCLOG(@"Player got hit by paint!");
            
            // Destroy Paint
            
            // Not sure if destroy player
            // Destroy paint
            //CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
            //[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
        else if ((contact.fixtureA == _aiPlayer.fixture && contact.fixtureB == _paint.fixture) || (contact.fixtureA == _paint.fixture && contact.fixtureB == _aiPlayer.fixture))
        {
            //CCLOG(@"Enemy got hit by paint!");
            
            //if (bodyB->GetUserData() != NULL) {
            //    CCSprite *sprite = (CCSprite *) bodyB->GetUserData();
            //    [self removeChild:sprite cleanup:YES];
            //    [_paint removeLastObject];
            //    world->DestroyBody(bodyB);
            //}
            
            
            
        }
        
        if(bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL)
        {
            spriteA = (CCSprite *) bodyA->GetUserData();
            spriteB = (CCSprite *) bodyB->GetUserData();
            //CCLOG(@"User data A:%@ B:%@", spriteA, spriteB);
            // spriteA = player, spriteB = paint
            if(bodyA == groundBody && bodyB == _paint.body)
            {
                CCLOG(@"Destroy paint! - 1");
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                {
                    toDestroy.push_back(bodyB);
                }
                
            }
            else if(bodyB == groundBody && bodyA == _paint.body)
            {
                CCLOG(@"Destroy paint! - 2");
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                {
                    toDestroy.push_back(bodyA);
                }
            }
            // player / enemy paint
            if(spriteA.tag == 1 && spriteB.tag == 4)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                 {
                 toDestroy.push_back(bodyB);
                 }
            }
            
            // spriteA = paint, spriteB = player
            else if(spriteA.tag == 4 && spriteB.tag == 1)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                 {
                 toDestroy.push_back(bodyA);
                 }
            }
            
            // spriteA = enemy, spriteB = paint
            else if(spriteA.tag == 2 && spriteB.tag == 3)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                {
                    toDestroy.push_back(bodyB);
                }
                /*if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                 {
                 toDestroy.push_back(bodyA);
                 [_enemiesAlive removeLastObject];
                 // Destroy enemy and paint
                 if ([_enemiesAlive count] == 0) {
                 CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
                 [[CCDirector sharedDirector] replaceScene:gameOverScene];
                 }
                 }*/
            }
            
            // spriteA = paint, spriteB = enemy
            else if(spriteA.tag == 3 && spriteB.tag == 2)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                {
                    toDestroy.push_back(bodyA);
                }
                /*if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                 {
                 toDestroy.push_back(bodyB);
                 [_enemiesAlive removeLastObject];
                 // Destroy enemy and paint
                 if ([_enemiesAlive count] == 0) {
                 CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
                 [[CCDirector sharedDirector] replaceScene:gameOverScene];
                 }
                 }*/
            }
            
            else if((spriteA.tag == 3 || spriteA.tag == 4) && spriteB.tag == 5)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                {
                    toDestroy.push_back(bodyA);
                }
            }
            
            else if (spriteA.tag == 5 && (spriteA.tag == 3 || spriteA.tag == 4))
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                {
                    toDestroy.push_back(bodyB);
                }
            }
            
            else if(spriteA.tag == 3)
            {
                b2Vec2 speed = _humanPlayer.body->GetLinearVelocity();
                if(speed.x < 0.3f || speed.y < 0.3f)
                {
                    if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end())
                    {
                        toDestroy.push_back(bodyA);
                    }
                }
            }
            
            else if(spriteB.tag == 3)
            {
                b2Vec2 speed = _humanPlayer.body->GetLinearVelocity();
                if(speed.x < 0.3f || speed.y < 0.3f)
                {
                    if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end())
                    {
                        toDestroy.push_back(bodyB);
                    }
                }
            }
        }
        else
        {
            //CCLOG(@"User data A:%@ B:%@", spriteA, spriteB);
        }
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

-(void)draw{
    [super draw];
    if(firing)
    {
        glLineWidth(3);
        ccDrawColor4F(0.0f, 1.0f, 0.0f, 1.0f);
        //ccDrawCircle( origin, 100, 0, 10, NO);
        ccDrawCircle(origin, 20, 0, 10, NO);
    }
    firing = NO;
    int i=0;
    for(AIPlayer* p in _aiplayers) {
        glLineWidth(2);
        ccPointSize(5.0f);
        ccDrawColor4F(1.0f, 0.0f, 0.0f, 1.0f);
        /*for(int i=0; i<p.rayVectors.count;i++) {
            CGPoint pt = [[p.rayVectors objectAtIndex:i] CGPointValue];
            ccDrawLine(p.eye, pt);
        }*/
        ccDrawLine(p.eye, p.target);
        ccDrawPoint(p.target);
        for(int i=0;i<p.targetOptions.count;i++) {
            ccDrawColor4F(0.0f, 1.0f, 0.0f, 1.0f);
            NSValue* v = [p.targetOptions objectAtIndex:i];
            CGPoint pt = [v CGPointValue];
            ccDrawLine(p.eye, pt);
            //[p.targetOptions removeObjectAtIndex:i];
        }//*/
        
        i++;
    }
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
    
    kmGLPushMatrix();
    world->DrawDebugData();
    
    kmGLPushMatrix();
}

# pragma mark Initialization methods

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
    //groundBodyDef.angularDamping = 0.1f;
    
    // Call the body factory which allocates memory for the ground body
    // from a pool that creates the ground box shape (also from a pool).
    // The body is also added to the world.
    groundBodyDef.userData = self;
    groundBody = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2EdgeShape groundBox;
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.friction = 0.3f;
    //groundFixtureDef.filter.maskBits = WORLD_CATEGORY_BITS;
    
    
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
    
    groundFixtureDef.shape = &groundBox;
    groundFixtureDef.filter.categoryBits = kCategoryBitsWorld;
    groundFixtureDef.filter.maskBits = kCategoryBitsAiPaint | kCategoryBitsAiPlayer | kCategoryBitsHumanPaint | kCategoryBitsHumanPlayer;
}

-(void)basicSetup
{
    [self initPhysics];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    int tinyFont = winSize.width/kFontScaleTiny;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    [CCMenuItemFont setFontName:@"Marker Felt"];
    [CCMenuItemFont setFontSize:tinyFont];
    [CCMenuItemFont setFontSize:22];
    
    //CCMenuItemLabel* item1 = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(onBack:)];
    //CCMenuItemLabel* item3 = [CCMenuItemFont itemWithString:@"O" target:self selector:@selector(pauseGame)];
    CCMenuItemImage* item1 = [CCMenuItemImage itemWithNormalImage:@"pause_game.png" selectedImage:@"pause_game.png" target:self selector:@selector(pauseGame)];
    item2 = [CCMenuItemFont itemWithString:[NSString stringWithFormat:@"%i", [defaults integerForKey:@"hopper_capacity"]] target:self selector:@selector(reloadPaint)];
    item1.color = ccRED;
    item2.color = ccRED;
    item1.scale = kGameSpriteTwentiethScale;
    
    CCMenu* menu = [CCMenu menuWithItems:item1,item2, nil];
    [menu setPosition:ccp(40,winSize.height-10)];
    [menu alignItemsHorizontally];
    [self addChild:menu z:1];
    
    gameData = [GameDataParser loadData];
    
    int selectedChapter = gameData.selectedChapter;
    int selectedLevel = gameData.selectedLevel;
    //self.player = [[Player alloc] initWithLayer:self world:world file:gameData.player];
    
    levels = [LevelParser loadLevelsForChapter:selectedChapter];
    
    _objectsToDraw = [[NSMutableArray alloc] init];
    
    for(Level* level in levels.levels)
    {
        if(level.number == selectedLevel)
        {
            levelData = level;
        }
    }
    _gameObjects = [[NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil] init];
    [self addBunkers];
    [self addEnemiesWithLevel:selectedLevel];
    
    // Load joystick but don't display
    
    
    // collision detection
    contactListener = new MyContactListener();
    world->SetContactListener(contactListener);
    
    self.touchEnabled = YES;
}

-(void)addEnemiesWithLevel:(int)selectedLevel
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _aiplayers = [[NSMutableArray alloc] init];
    for(Level* level in levels.levels)
    {
        if(level.number == selectedLevel)
        {
            for(int i=0; i<level.enemies; i++)
            {
                CGPoint point = ccp(winSize.width - 1.5*PTM_RATIO, winSize.height/2);
                _aiPlayer = [[AIPlayer alloc] initWithLayer:self andFile:level.enemy forWorld:world andPosition:point wNumOnOppTeam:1];
                _aiPlayer.world = world;
                _aiPlayer.layer = self;
                _aiPlayer.file = levelData.paint;
                _aiPlayer.speed = [defaults integerForKey:@"player_speed"];
                [_gameObjects[_aiPlayer.team-1] addObject:_aiPlayer];
                [_batchNode addChild:_aiPlayer];
                [_aiplayers addObject:_aiPlayer];
            }
        }
    }
}

-(void)addPlayers
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    _humanPlayer = [[HumanPlayer alloc] initWithLayer:self andFile:gameData.player forWorld:world andPosition:ccp(1.5*PTM_RATIO, winSize.height/2)];
    //_humanPlayer.sprite.position = ccp(1.5*PTM_RATIO, winSize.height/2);
    //[_humanPlayer setPosition:ccp(1.5*PTM_RATIO, winSize.height/2)];
    _humanPlayer.world = world;
    _humanPlayer.layer = self;
    [_gameObjects addObject:_humanPlayer];
    [_batchNode addChild:_humanPlayer];
}

-(void)addBunkers
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint pt = ccp(winSize.width/2, winSize.height/2);
    _bunker = [[Bunker alloc] initWithLayer:self andFile:levelData.bunker forWorld:world andPosition:pt];
    [_batchNode addChild:_bunker];
    [_gameObjects[2] addObject:_bunker];
}

- (id)init {
    if( (self=[super initWithColor:ccc4(0,201,13,255)])) {
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        [self basicSetup];
        [self addPlayers];
        [self scheduleUpdate];
    }
    return self;
}

-(void) dealloc{
    delete world;
    world = NULL;
    
    delete _debugDraw;
    
    delete contactListener;
    
    //[_cache release];
    //_cache = nil;
    
    [super dealloc];
}

# pragma mark Gameplay methods

-(void)reloadPaint {
    [_humanPlayer reloadPaint];
    [item2 setString:[NSString stringWithFormat:@"%i", [_humanPlayer getPaintLeftInHopper]]];
}

# pragma mark Helper methods

-(void)removeGameObject:(GameObject *)gameObject
{
    [_gameObjects[gameObject.team-1] removeObject:gameObject];
    [gameObject removeFromParentAndCleanup:YES];
}

-(void)setPlayer:(Player *)player attacking:(BOOL)attacking
{
    player.offense = attacking;
    for(AIPlayer* ai in _gameObjects[player.team - 1])
    {
        ai.offense = attacking;
    }
}

-(int)oppositeTeam:(int)team
{
    if(team == 1)
    {
        return 2;
    } else {
        return 1;
    }
}

-(NSArray*)enemiesOfTeam:(int)team
{
    int oppositeTeam = [self oppositeTeam:team];
    return _gameObjects[oppositeTeam-1];
}

-(NSArray*)enemiesWithinRange:(float)range ofPlayer:(Player *)player
{
    NSMutableArray* returnval = [NSMutableArray array];
    NSArray* enemies = [self enemiesOfTeam:player.team];
    for(GameObject* enemy in enemies)
    {
        float distance = ccpDistance(enemy.position, player.position);
        if(distance < range)
        {
            [returnval addObject:enemy];
        }
    }
    return returnval;
}

-(NSArray*)bunkersOnField {
    if(_gameObjects) {
        return NULL;
    } else {
        return _gameObjects[2];
    }
}

-(NSArray*)bunkersWithinRange:(float)range ofPlayer:(Player *)player
{
    NSMutableArray* returnval = [NSMutableArray array];
    NSArray* bunkers = [self bunkersOnField];
    for(GameObject* bunker in bunkers)
    {
        float distance = ccpDistance(bunker.position, player.position);
        //CCLOG(@"%f",distance);
        if(distance < range) {
            [returnval addObject:bunker];
        }
    }
    return returnval;
}

-(BOOL)isNextToBunker:(Bunker*)bunker player:(Player *)player {
    b2Body* b = [bunker getBody];
    if(b->GetUserData() == NULL) {
        return NULL;
    }
    CCSprite* sprite = (CCSprite*)bunker.body->GetUserData();
    //CGPoint p = sprite.position;
    float distance = ccpDistance(sprite.position, player.sprite.position);
    //CCLOG(@"%f",distance);
    if(distance < 20) {
        return YES;
    } else {
        return NO;
    }
}

-(b2Body*)getBunker {
    return _bunker.body;
}

-(Player*)getHumanPlayer{
    return _humanPlayer;
}

-(void)addGameObject:(GameObject *)gameObject
{
    [_gameObjects[3] addObject:gameObject];
}

-(void)addBatchNode:(Paint *)paint
{
    [_batchNode addChild:paint];
}

-(BOOL)paintIsNextToPlayer:(Player *)player
{
    return false;
}

@end
