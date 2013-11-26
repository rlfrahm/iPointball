//
//  PauseLayer.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/27/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "PauseLayer.h"

#define PTM_RATIO 32

@implementation PauseLayer {
    GameScene* _gs;
}

-(id) initWithColor:(ccColor4B)color andScene:(GameScene *)scene
{
    if((self = [super initWithColor:color]))
    {
        _gs = scene;
        self.touchEnabled = YES;
        CGSize winsize = [[CCDirector sharedDirector] winSize];
        CCSprite* paused = [CCSprite spriteWithFile:@"paused.png"];
        [paused setPosition:ccp(460, 0)];
        [self addChild:paused];
    }
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch* touch in touches)
    {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        [_gs resume];
        [self.parent removeChild:self cleanup:YES];
    }
}

-(void) dealloc
{
    [super dealloc];
}

@end
