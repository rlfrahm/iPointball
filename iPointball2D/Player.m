//
//  Player.m
//  iPointball2D
//
//  Created by Ryan Frahm on 4/6/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import "Player.h"


@implementation Player

-(id) init{
    if(self = [super init])
    {
        [Player spriteWithFile:@"player.png"];
    }
    return self;
}

-(void) setPosition:(CGPoint) p{
    NSLog(@"Hello?");
    self.position = ccp(p.x,p.y);
    CCLOG(@"Player added at 0.2%f x 0.2%f",self.position.x,self.position.y);
}

@end
