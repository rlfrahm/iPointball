//
//  Player.h
//  iPointball2D
//
//  Created by Ryan Frahm on 10/3/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "GameObject.h"
#import "cocos2d.h"
#import "Marker.h"
#import "Pod.h"

@interface Player : GameObject

@property (nonatomic, assign) int speed;
@property (nonatomic, assign) CGFloat topY;
@property (nonatomic, assign) CGFloat btmY;
@property (nonatomic, assign) CGFloat leftX;
@property (nonatomic, assign) BOOL snapped;
@property (nonatomic, assign) int ammo;
@property (nonatomic, assign) int markerAccuracy;
@property (nonatomic, assign) Marker* marker;
@property (nonatomic, assign) int pods;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) int reloadAccumulator;
@property (nonatomic, assign) int reload;
@property (nonatomic, assign) Pod* pod;

-(void)setMovementWindow:(CGPoint)point;
-(void)moveToPoint:(CGPoint)point;
-(void)moveToVector:(b2Vec2)vector;
-(void)stopMovement;
-(void)shootPaintToLocation:(CGPoint)location;
-(int)getPaintLeftInHopper;
-(void)reloadPaint;

@end
