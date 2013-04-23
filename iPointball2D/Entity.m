//
//  Entity.m
//  iPointball2D
//
//  Created by Ryan Frahm on 4/22/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Entity.h"

@implementation Entity : NSObject{
    uint32_t _eid;
}

-(id)initWithEid:(uint32_t)eid{
    if((self = [super init])){
        _eid = eid;
    }
    return self;
}

-(uint32_t)eid{
    return _eid;
}

@end
