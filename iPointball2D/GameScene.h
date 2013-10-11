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
#import "Player.h"

@class Player;
@class GameObject;
@class Paint;

@interface GameScene : CCLayerColor {
    b2Body* groundBody;
    GLESDebugDraw *_debugDraw;
    CGPoint origin;
    b2MouseJoint* _mouseJoint;
    CCSprite* enemy;
    b2Body* enemyBody;
    b2Fixture* enemyFixture;
    b2Vec2 moveToLocation;
    BOOL firing;
    
    NSMutableArray *_enemiesAlive;
}

@property (nonatomic, assign) BOOL iPad;

-(void)removeGameObject:(GameObject*)gameObject;

@end
