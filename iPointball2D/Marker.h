//
//  Marker.h
//  iPointball2D
//
//  Created by Ryan Frahm on 1/20/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "CCNode.h"
@class Hopper;
@class Barrel;

@interface Marker : CCNode

@property (nonatomic, assign) Hopper* hopper;
@property (nonatomic, assign) Barrel* barrel;
@property (nonatomic, assign) float accuracy;

-(id)initWithAccuracy:(int)acc;
-(int)getPaintLeftInHopper;
-(void)setPaintLeftInHopper:(int)amount;
-(void)setHopperCapacity:(int)capacity;
-(int)getHopperCapacity;

@end
