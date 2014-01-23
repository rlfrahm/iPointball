//
//  Marker.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/20/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "Marker.h"
#import "Hopper.h"
#import "Barrel.h"

@implementation Marker

-(id)initWithAccuracy:(int)acc {
    self = [super init];
    if(self) {
        self.hopper = [[Hopper alloc] init];
        self.barrel = [[Barrel alloc] init];
        self.accuracy = (110 - (acc*10));
        self.accuracy = self.accuracy / 400;
    }
    return self;
}

-(void)setPaintLeftInHopper:(int)amount {
    self.hopper.paintLeft = amount;
}

-(int)getPaintLeftInHopper {
    return self.hopper.paintLeft;
}

-(void)setHopperCapacity:(int)capacity {
    self.hopper.capacity = capacity;
}

-(int)getHopperCapacity {
    return self.hopper.capacity;
}

@end
