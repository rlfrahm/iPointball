//
//  System.m
//  iPointball2D
//
//  Created by Ryan Frahm on 4/22/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "System.h"

@implementation System

-(id)initWithEntityManager:(EntityManager *)entityManager{
    if((self = [super init])){
        self.entityManager = entityManager;
    }
    return self;
}

-(void)update:(float)dt{
    
}

@end
