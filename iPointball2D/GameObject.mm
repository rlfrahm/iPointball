//
//  GameObject.m
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "GameObject.h"
#import "GameScene.h"

@implementation GameObject
@synthesize body,bodyDef,fixture,fixtureDef,sprite;

-(id)initWithSprite:(NSString *)file layer:(GameScene *)layer andPosition:(CGPoint)position
{
    if ((self = [super initWithFile:file])) {
        self.sprite = [CCSprite spriteWithFile:file];
        [layer addChild:self.sprite];
        self.sprite.position = position;
        self.alive = YES;
        self.layer = layer;
        //[self scheduleUpdateWithPriority:1];
    }
    return self;
}

-(void)draw
{
    if (self.alive == NO) return;
}

-(void)update:(ccTime)delta
{
    if(!self.alive) return;
    if(self.maxHP==0) return;
    
    if(self.currHP <= 0)
    {
        self.alive = NO;
        
        [self runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.5],
                         [CCCallBlock actionWithBlock:^{
                            [self.layer removeGameObject:self];
        }],nil]];
    }
}

-(void)setPosition:(CGPoint)position
{
    self.sprite.position = position;
}

@end
