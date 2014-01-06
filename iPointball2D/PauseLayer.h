//
//  PauseLayer.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/27/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"

@interface PauseLayer : CCLayerColor<UIAlertViewDelegate> {
    
}

-(id) initWithColor:(ccColor4B)color andScene:(GameScene*)scene;

@end
