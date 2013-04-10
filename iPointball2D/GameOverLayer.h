//
//  GameOverLayer.h
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
    
}

+(CCScene *)sceneWithWon:(BOOL)won;
-(id)initWithWon:(BOOL)won;

@end
