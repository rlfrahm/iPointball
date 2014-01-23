//
//  HudLayer.m
//  iPointball2D
//
//  Created by Ryan Frahm on 12/1/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//  http://iphonegamekit.com/how-to-program-a-d-pad-joystick-for-iphone/
//

#import "HudLayer.h"
#import "Constants.h"
#import "PauseLayer.h"

#define kJoybtnRadiusSquared 100
#define kJoybtnRadius 10

@implementation HudLayer

- (id)init
{
    self = [super init];
    if (self != NULL) {
        self.touchEnabled = YES;
        joybtn = [CCSprite spriteWithFile:@"joybtn.png"];
        joybtn.position = ccp(50, 50);
        [self addChild:joybtn z:1];
    }
    return self;
}

-(void)pauseGame {
    
}

-(void) addOptionsMenu
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int tinyFont = winSize.width/kFontScaleTiny;
    
    [CCMenuItemFont setFontName:@"Marker Felt"];
    [CCMenuItemFont setFontSize:tinyFont];
    
    //CCMenuItemLabel* item1 = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(onBack:)];
    CCMenuItemLabel* item1 = [CCMenuItemFont itemWithString:@"O" target:self selector:@selector(pauseGame)];
    
    item1.color = ccRED;
    item1.scale = kGameSpriteDefaultScale;
    //item2.color = ccRED;
    
    CCMenu* menu = [CCMenu menuWithItems:item1, nil];
    [menu setPosition:ccp(item1.contentSize.width,winSize.height-item1.contentSize.height/3)];
    [menu alignItemsHorizontally];
    [self addChild:menu];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(!isMovingJoybtn && [self isTouchingJoybtn:touch]) {
        touchPos = joybtn.position;
        [self moveJoyBtn:touch];
        isMovingJoybtn = YES;
    }
    return YES;
}
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(isMovingJoybtn) {
        [self moveJoyBtn:touch];
    }
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self stop];
}
-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self stop];
}

-(BOOL) isTouchingJoybtn:(UITouch *)touch {
    float c2 = [self distanceFromJoybtnSquared:[self touchToPoint:touch]];
    return (c2 < kJoybtnRadiusSquared);
}

-(void) moveJoyBtn:(UITouch *)touch {
    CGPoint prev = (isMovingJoybtn ? [self touchToPreviousPoint:touch] : joybtn.position);
    CGPoint offset = ccpSub([self touchToPoint:touch], prev);
    if(offset.x || offset.y) {
        touchPos = ccpAdd(touchPos, offset);
        CGPoint delta = ccpSub(touchPos, joybtn.position);
        CGPoint newPos = touchPos;
        joybtnAngle = ccpToAngle(delta);
        joybtnDisSquared = [self distanceFromJoybtnSquared:newPos];
        if(joybtnDisSquared > kJoybtnRadiusSquared) {
            newPos = ccpAdd(joybtn.position, ccpMult(ccpForAngle(joybtnAngle), kJoybtnRadius));
            joybtnDisSquared = kJoybtnRadiusSquared;
        }
        [joybtn setPosition:newPos];
    }
}

-(float) distanceFromJoybtnSquared:(CGPoint)p {
    return ccpLengthSQ(ccpSub(p, joybtn.position));
}

-(CGPoint) touchToPoint:(UITouch *)touch {
    return [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
}

-(CGPoint) touchToPreviousPoint:(UITouch *)touch {
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    return ccpSub(location, touchPos);
}

-(void) stop {
    isMovingJoybtn = NO;
    joybtn.position = ccp(50, 50);
}

@end
