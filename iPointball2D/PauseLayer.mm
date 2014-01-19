//
//  PauseLayer.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/27/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "PauseLayer.h"
#import "SceneManager.h"

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
        [paused setPosition:ccp(winsize.width - 70, 0)];
        [self addChild:paused];
        
        CCMenuItemFont* quitMenuItem = [CCMenuItemFont itemWithString:@"Quit" block:^(id sender){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirm Quit"
                                                            message:@"Are you sure you want to quit?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Yes"
                                                  otherButtonTitles:@"No", nil];
            [alert show];
            [alert release];
        }];
        CCMenu* menu = [CCMenu menuWithItems:quitMenuItem, nil];
        [menu setPosition:CGPointMake(SCREEN.width/2, 20)];
        [self addChild:menu];
    }
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch* touch in touches)
    {
        [_gs resume];
        [self.parent removeChild:self cleanup:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* button = [alertView buttonTitleAtIndex:buttonIndex];
    if([button isEqualToString:@"Yes"]) {
        [_gs resume];
        [self.parent removeChild:self cleanup:YES];
        [self.parent.parent removeChild:self.parent cleanup:YES];
        [SceneManager goLevelSelect];
    } else {
        
    }
}

-(void) dealloc
{
    [super dealloc];
}

@end
