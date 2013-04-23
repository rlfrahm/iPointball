//
//  System.h
//  iPointball2D
//
//  Created by Ryan Frahm on 4/22/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EntityManager;

@interface System : NSObject

@property (strong) EntityManager *entityManager;

-(id)initWithEntityManager:(EntityManager *)entityManager;

-(void)update:(float)dt;

@end
