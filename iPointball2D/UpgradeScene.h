//
//  SceneName.h  <-- RENAME THIS
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "SceneManager.h"
#import "MarkerTable.h"
#import "ProductShowroomLayer.h"

@interface UpgradeScene : CCLayerColor<MarkerTableDelegate, ProductShowroomLayerDelegate> {
    
}

@property (nonatomic, assign) BOOL iPad;

-(void)updateProductShowRoomWithType:(NSString*)type andIndex:(NSUInteger)idx;

@end
