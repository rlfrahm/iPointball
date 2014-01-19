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
        
    }
    return self;
}

-(CGSize)cellSize {
    return CGSizeMake(100, 100);
}

-(void)cellTouchedAtIndex:(NSUInteger)idx {
    
}

@end
