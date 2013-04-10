//
//  MyContactListener.m
//  iPointball2D
//
//  Created by  on 4/9/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//
// http://www.raywenderlich.com/28606/how-to-create-a-breakout-game-with-box2d-and-cocos2d-2-x-tutorial-part-2

#import "MyContactListener.h"

MyContactListener::MyContactListener() : _contacts() {
    
}

MyContactListener::~MyContactListener() {
    
}

void MyContactListener::BeginContact(b2Contact *contact) {
    // We need to copy out the data because the b2Contact passed in
    // is refused
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    _contacts.push_back(myContact);
}

void MyContactListener::EndContact(b2Contact *contact) {
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
    
}

void MyContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse* impulse) {
    
}