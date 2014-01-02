//
//  HudLayer.h
//  iPointball2D
//
//  Created by Ryan Frahm on 12/1/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface HudLayer : CCLayer {
    CCSprite* joybtn;
    CGPoint touchPos;
    float joybtnDisSquared, joybtnAngle;
    BOOL isMovingJoybtn;
}

@end
