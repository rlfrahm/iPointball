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
@class Bunker;

@interface GameScene : CCLayerColor {
    b2Body* groundBody;
    GLESDebugDraw *_debugDraw;
    CGPoint origin;
    b2MouseJoint* _mouseJoint;
    b2Vec2 moveToLocation;
    BOOL firing;
    
    NSMutableArray *_enemiesAlive;
}

@property (nonatomic, assign) BOOL iPad;

-(void)removeGameObject:(GameObject*)gameObject;
-(void)setPlayer:(Player*)player attacking:(BOOL)attacking;
-(NSArray*)enemiesOfTeam:(int)team;
-(NSArray*)enemiesWithinRange:(float)range ofPlayer:(Player*)player;
-(NSArray*)bunkersWithinRange:(float)range ofPlayer:(Player*)player;
-(BOOL)isNextToBunker:(b2Body*)bunker player:(Player*)player;
-(BOOL)paintIsNextToPlayer:(Player*)player;
-(b2Body*)getBunker;
-(Player*)getHumanPlayer;
-(void)addGameObject:(GameObject*)gameObject;
-(void)resume;

@end
