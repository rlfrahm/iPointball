//
//  CollectionViewCell.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/6/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(id)init {
    self = [super initWithColor:ccc4(255, 151, 0, 255)];
    if(self) {
        self.touchEnabled = YES;
    }
    return self;
}

-(CGSize)cellSize {
    return CGSizeMake(100, 100);
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Here");
    if([self.delegate respondsToSelector:@selector(cellTouchedAtIndex:)]) {
        [self.delegate cellTouchedAtIndex:self.idx];
    }
}

-(void)cellTouchedAtIndex:(NSUInteger)idx {
    
}

@end
