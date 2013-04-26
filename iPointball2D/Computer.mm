//
//  Computer.mm
//  iPointball2D
//
//  Created by Ryan Frahm on 4/26/13.
//  Copyright 2013 Ryan Frahm. All rights reserved.
//

#import "Computer.h"


@implementation Computer

-(id)initWithWorld:(b2World *)world
{
    NSString *file;
    if([[self getTeam] isEqual: @"BAD_GUYS"])
    {
        CCLOG(@"Enemy dressed in bad guy outfit");
        // Use bad guys outfit
        file = @"Target.png";
    } else
    {
        CCLOG(@"Enemy dressed in good guy outfit");
        // User good guys outfit
        file = @"Target.png";
    }
    
    int count = 7;
    
    b2Vec2 vertices[] = {
        
    };
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    b2Body *body = [self createBodyForWorld:world position:b2Vec2(winSize.width/PTM_RATIO - .5, winSize.height/PTM_RATIO/2) vertices:vertices withVertextCount:count rotation:0 density:5.0 friction:0.2 restitution:0.2 bullet:NO];
    
    if(self = [super initWithFile:file body:body original:YES])
    {
        // Set up attributes
    }
}

@end
