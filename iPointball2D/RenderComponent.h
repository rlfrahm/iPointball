//
//  RenderComponent.h
//  iPointball2D
//
//  Created by Ryan Frahm on 4/22/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Component.h"
#import "cocos2d.h"

@interface RenderComponent : Component

@property (strong) CCSprite* node;

-(id) initWithNode:(CCSprite *)node;

@end
