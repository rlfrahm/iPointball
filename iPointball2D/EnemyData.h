//
//  EnemyData.h
//  iPointball2D
//
//  Created by Ryan Frahm on 9/28/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnemyData : NSObject

@property CGPoint eye;
@property CGPoint target;
@property BOOL canSeePlayer;
@property BOOL canSeeCover;
@property double lastShot;

@end
