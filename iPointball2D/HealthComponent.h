//
//  HealthComponent.h
//  iPointball2D
//
//  Created by Ryan Frahm on 4/22/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Component.h"

@interface HealthComponent : Component

@property (assign) float curHp;
@property (assign) float maxHp;
@property (assign) BOOL alive;

-(id)initWithCurHp:(float)curHp maxHp:(float)maxHp;

@end
