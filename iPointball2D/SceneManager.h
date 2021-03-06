//
//  SceneManager.h
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainMenu.h"
#import "ChapterSelect.h"
#import "OptionsMenu.h"
#import "LevelSelect.h"
#import "GameScene.h"
#import "UpgradeScene.h"
#import "LoadoutScene.h"

@interface SceneManager : NSObject

+(void) goMainMenu;
+(void) goChapterSelect;
+(void) goOptionsMenu;
+(void) goLevelSelect;
+(void) goGameScene;
+(void) goUpgradeMenu;
+(void) goLoadoutMenu;

@end
