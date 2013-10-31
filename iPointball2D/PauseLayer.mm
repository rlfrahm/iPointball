//
//  PauseLayer.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/27/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "PauseLayer.h"

@implementation PauseLayer

-(id) initWithColor:(ccColor4B)color
{
    if((self = [super initWithColor:color]))
    {
        self.touchEnabled = YES;
        CGSize winsize = [[CCDirector sharedDirector] winSize];
        CCSprite* paused = [CCSprite spriteWithFile:@"paused.png"];
        [paused setPosition:ccp(winsize.width/2, winsize.height/2)];
        [self.parent addChild:paused];
    }
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch* touch in touches)
    {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        GameScene* gs;
        [gs resume];
        [self.parent removeChild:self cleanup:YES];
    }
}

-(void) dealloc
{
    [super dealloc];
}

@end
