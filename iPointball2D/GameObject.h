//
//  PhysicsObject.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "CCSprite.h"
#import "Box2D.h"
@class GameScene;
@class Level;

@interface GameObject : CCSprite

@property(nonatomic, assign) CCSprite* sprite;

-(id)initWithSprite:(NSString *)file layer:(GameScene*)layer andPosition:(CGPoint)position;
-(void)setPosition:(CGPoint)position;

@property(assign) int currHP;
@property(assign) int maxHP;
@property(nonatomic,assign) BOOL alive;
@property(assign) int team;
@property (assign) BOOL offense;
@property (nonatomic, assign) GameScene* layer;
@property(nonatomic,assign) b2Body* body;
@property(nonatomic,assign) b2Fixture* fixture;
@property(nonatomic,assign) b2BodyDef bodyDef;
@property(nonatomic,assign) b2PolygonShape shape;
@property(nonatomic,assign) b2FixtureDef fixtureDef;
@property(nonatomic,assign) b2FixtureDef touchFixtureDef;
@property (nonatomic, assign) b2World* world;

@end
