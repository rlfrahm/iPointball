//
//  HumanPlayer.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/9/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "HumanPlayer.h"
#import "cocos2d.h"

@implementation HumanPlayer {
    b2World* _world;
};

-(id)initWithLayer:(GameScene *)layer andFile:(NSString *)file forWorld:(b2World*)world andPosition:(CGPoint)position
{
    if((self = [super initWithSprite:file layer:layer andPosition:position]))
    {
        self.team = 1;
        [self createBodyForWorld:world];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        self.marker = [[Marker alloc] initWithAccuracy:[defaults integerForKey:@"marker_accuracy"]];
        [self.marker setHopperCapacity:[defaults integerForKey:@"hopper_capacity"]];
        [self.marker setPaintLeftInHopper:[defaults integerForKey:@"hopper_capacity"]];
        self.pods = [defaults integerForKey:@"player_pods"];
        self.speed = 1 + ([defaults integerForKey:@"player_speed"]/10);
        self.reload = [defaults integerForKey:@"player_reload"];
        self.pod = [[Pod alloc] init];
        self.pod.capacity = [defaults integerForKey:@"pods_capacity"];
    }
    return self;
}

-(void)createBodyForWorld:(b2World*)world
{
    _world = world;
    // Define the dynamic body.
    // Set up a 1m squared box in the physics world
    self.sprite.tag = 1;
    self.sprite.scaleX = kGameSpriteDefaultScale;
    self.sprite.scaleY = kGameSpriteDefaultScale;
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(self.sprite.position.x/PTM_RATIO, self.sprite.position.y/PTM_RATIO);
    bodyDef.userData = self.sprite;
    bodyDef.angle = 0;
    bodyDef.fixedRotation = true;
    bodyDef.angularDamping = 1000.0f;
    bodyDef.linearDamping = 4.0f;
    self.bodyDef = bodyDef;
    self.body = _world->CreateBody(&bodyDef);
    
    // Create player shape
    b2PolygonShape playerShape;
    playerShape.SetAsBox(self.contentSize.width/PTM_RATIO/2 * kGameSpriteDefaultScale, self.contentSize.height/PTM_RATIO/2 * kGameSpriteDefaultScale); // These are mid points for our 1m box
    
    // Create shape definition and add to body
    b2FixtureDef playerFixtureDef;
    playerFixtureDef.shape = &playerShape;
    playerFixtureDef.density = 1000.0f;
    playerFixtureDef.friction = 0.4f;
    playerFixtureDef.restitution = 0.1f;
    playerFixtureDef.filter.categoryBits = kCategoryBitsHumanPlayer;
    playerFixtureDef.filter.maskBits = kCategoryBitsWorld | kCategoryBitsAiPlayer | kCategoryBitsBunker;
    self.fixtureDef = playerFixtureDef;
    
    b2CircleShape playerTouchShape;
    playerTouchShape.m_radius = 1.0f;
    
    b2FixtureDef playerTouchFixtureDef;
    playerTouchFixtureDef.shape = &playerTouchShape;
    playerTouchFixtureDef.density = 1.0f;
    //playerTouchFixtureDef.filter.categoryBits = kCategoryBitsHumanPlayer;
    //playerTouchFixtureDef.filter.maskBits = kCategoryBitsWorld | kCategoryBitsAiPlayer | kCategoryBitsBunker | kCategoryBitsAiPaint;
    
    self.fixture = self.body->CreateFixture(&playerTouchFixtureDef);
    self.body->CreateFixture(&playerFixtureDef);
}

@end
