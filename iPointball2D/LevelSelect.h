//
//  LevelSelect.h  <-- RENAME THIS
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "SceneManager.h"
#import "Level.h"
#import "Levels.h"
#import "LevelParser.h"
#import "GameData.h"
#import "GameDataParser.h"

@interface LevelSelect : CCLayerColor {
    
}

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString* device;

@end
