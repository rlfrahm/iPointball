//
//  EntityManager.h
//  iPointball2D
//
//  Created by Ryan Frahm on 4/22/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Entity.h"
#import "Component.h"

@interface EntityManager : NSObject

-(uint32_t)generateNewEid;
-(Entity *)createEntity;
-(void)addComponent:(Component *)component toEntity:(Entity *)entity;
//-(Component *)getComponentOfClass:(Class)class forEntity:(Entity *)entity;
-(void)removeEntity:(Entity *)entity;
//-(NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)class;

@end
