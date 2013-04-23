//
//  HealthComponent.m
//  iPointball2D
//
//  Created by Ryan Frahm on 4/22/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "HealthComponent.h"

@implementation HealthComponent

-(id)initWithCurHp:(float)curHp maxHp:(float)maxHp{
    if((self = [super init])){
        self.curHp = curHp;
        self.maxHp = maxHp;
        self.alive = YES;
    }
    return self;
}

@end
