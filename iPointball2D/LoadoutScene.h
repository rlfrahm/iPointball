//
//  SceneName.h  <-- RENAME THIS
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SceneManager.h"
#import "CollectionView.h"

@interface LoadoutScene : CCLayerColor<CollectionViewDelegate>

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) CCMenuItemFont* marker;
@property (nonatomic, assign) CCMenuItemFont* barrel;
@property (nonatomic, assign) CCMenuItemFont* hopper;
@property (nonatomic, assign) CCMenuItemFont* pod;

@end
