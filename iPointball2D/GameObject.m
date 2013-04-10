//
//  GameObject.m
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import "GameObject.h"
#import "GameLevelLayer.h"
#import "SimpleAudioEngine.h"
#import "Player.h"


@implementation GameObject

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName layer:(GameLevelLayer *)layer{
    if ((self = [super initWithSpriteFrameName:spriteFrameName]))
    {
        self.layer = layer;
        self.alive = YES;
        [self scheduleUpdateWithPriority:1];
    }
    return self;
}

-(void)update:(ccTime)delta {
    if(!self.alive) return;
    
    // Audio
    
    // Collison detection
    
    // Body destruction
}

@end
