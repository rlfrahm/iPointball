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
#import "Player.h"
#import "Enemy.h"
#import "Bunker.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

@interface GameLevelLayer : CCLayerColor {
    NSMutableArray *_enemies;
    NSMutableArray *_paint;
    NSMutableArray *_coverChoices;
    int _monstersDestroyed;
    CCSprite *player;
    CCSprite *enemy;
    CCSprite *bunker;
    NSInteger gameState;
    b2World *world;
    CCTexture2D *spriteTexture_;
}

+ (CCScene *) scene;

@end
