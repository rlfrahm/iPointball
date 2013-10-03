//
//  GameScene.h  <-- RENAME THIS
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "SceneManager.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"

@interface GameScene : CCLayerColor {
    b2World *world;
    b2Body* groundBody;
    GLESDebugDraw *_debugDraw;
    CCSprite* bunker;
    b2Body* bunkerBody;
    b2Fixture* bunkerFixture;
    CGPoint origin;
    CCSprite* player;
    b2Body* playerBody;
    b2Fixture* _playerFixture;
    b2MouseJoint* _mouseJoint;
    CCSprite* enemy;
    b2Body* enemyBody;
    b2Fixture* enemyFixture;
    CCSprite* paint;
    //b2Body* paintBody;
    b2Fixture* paintFixture;
    b2Vec2 moveToLocation;
    BOOL firing;
    MyContactListener *contactListener;
    NSMutableArray *_enemiesAlive;
}

@property (nonatomic, assign) BOOL iPad;

@end
