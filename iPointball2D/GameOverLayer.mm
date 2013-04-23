//
//  GameOverLayer.m
//  iPointball2D
//
//  Created by  on 4/10/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameLevelLayer.h"

@implementation GameOverLayer

+(CCScene *) sceneWithWon:(BOOL)won{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won] autorelease];
    [scene addChild:layer];
    return scene;
}

-(id) initWithWon:(BOOL)won{
    if((self = [super initWithColor:ccc4(255, 255, 255, 255)])){
        NSString *msg;
        if(won){
            msg = @"All enemies cleared!";
        }
        else {
            msg = @"You were eliminated!";
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *label = [CCLabelTTF labelWithString:msg fontName:@"Arial" fontSize:32];
        label.color = ccc3(0, 0, 0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3], [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [[CCDirector sharedDirector] replaceScene:[GameLevelLayer scene]];
        }], nil]];
    }
    return self;
}

@end
