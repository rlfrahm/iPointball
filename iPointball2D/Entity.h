//
//  Entity.h
//  iPointball2D
//
//  Created by Ryan Frahm on 4/22/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entity : NSObject

-(id)initWithEid:(uint32_t)eid;
-(uint32_t)eid;

@end
