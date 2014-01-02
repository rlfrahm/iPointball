//
//  MainMenu.h
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SceneManager.h"
//#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "Box2D.h"
#import "GLES-Render.h"

@interface MainMenu : CCLayerColor {
    CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
}

@property (nonatomic, assign) BOOL iPad;

@end
