//
//  SceneName.h  <-- RENAME THIS
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "SceneManager.h"
#import "ProductShowroomLayer.h"
#import "UpgradesTable.h"

@interface UpgradeScene : CCLayerColor<ProductShowroomLayerDelegate, UpgradesTableDelegate> {
    
}

@property (nonatomic, assign) BOOL iPad;

//-(void)updateProductShowRoomWithType:(NSString*)type andIndex:(NSUInteger)idx;

@end
