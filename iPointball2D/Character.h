//
//  Character.h
//  iPointball2D
//
//  Created by Ryan Frahm on 4/26/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PhysicsObject.h"

@interface Character : PhysicsObject {
    NSString *team;
    
    // Skills
    float accuracy; // accuracy
    float quickness; // speed and agility
    float reloading; // reloading speed
}

-(void)setAccuracy;
-(float)getAccuracy;

-(void)setQuickness;
-(float)getQuickness;

-(void)setReloadSpeed;
-(float)getReloadSpeed;

-(void)setTeam;
-(NSString*)getTeam;

@end
