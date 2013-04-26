//
//  GameLevelLayer.h
//  iPointball2D
//
//  Created by Ryan Frahm on 4/6/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "MyContactListener.h"
#import "GLES-Render.h"
#import "Bunker.h"
#import "Player.h"
#import "Computer.h"
#import "Paint.h"
#import "Gun.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

@interface GameLevelLayer : CCLayerColor {
    NSMutableArray *_enemiesAlive;
    NSMutableArray *_paint;
    NSMutableArray *_bunkers;
    int _monstersDestroyed;
    CCSprite *player;
    CCSprite *enemy;
    CCSprite *bunker;
    CCSprite *paint;
    NSInteger gameState;
    b2World *world;
    b2Body *groundBody;
    b2Body *playerBody;
    b2Body *enemyBody;
    b2Body *bunkerBody;
    //CCTexture2D *spriteTexture_;
    b2MouseJoint *_mouseJoint;
    b2Fixture *_groundFixture;
    b2Fixture *_playerFixture;
    b2Fixture *enemyFixture;
    b2Fixture *paintFixture;
    b2Fixture *bunkerFixture;
    MyContactListener *contactListener;
    GLESDebugDraw *_debugDraw;
    CCArray *_cache;
    BOOL playerFlag;
    b2Body *paintBod[100];
}

@property(retain)CCArray *cache;

+ (CCScene *) scene;

@end
