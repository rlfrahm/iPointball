//
//  RayCastCallback.h
//  iPointball2D
//
//  Created by Ryan Frahm on 9/28/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#ifndef iPointball2D_RayCastCallback_h
#define iPointball2D_RayCastCallback_h

#import "Box2D.h"

class RayCastCallback : public b2RayCastCallback
{
public:
    RayCastCallback() : m_fixture(NULL){}
        
    float32 ReportFixture(b2Fixture* fixture, const b2Vec2& point, const b2Vec2& normal, float32 fraction)
    {
        m_fixture = fixture;
        m_point = point;
        m_normal = normal;
        m_fraction = fraction;
        return fraction;
    }
            
    b2Fixture* m_fixture;
    b2Vec2 m_point;
    b2Vec2 m_normal;
    float32 m_fraction;
};


#endif
