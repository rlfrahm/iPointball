//
//  RenderComponent.m
//  iPointball2D
//
//  Created by Ryan Frahm on 4/22/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "RenderComponent.h"

@implementation RenderComponent

-(id)initWithNode:(CCSprite *)node{
    if((self = [super init])) {
        self.node = node;
    }
    return self;
}

@end
