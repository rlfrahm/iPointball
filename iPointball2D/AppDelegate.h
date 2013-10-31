//
//  AppDelegate.h
//  iPointball2D
//
//  Created by Ryan Frahm on 4/6/13.
//  Copyright Ryan Frahm 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
	
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, assign) BOOL paused;

+(AppController *)get;
-(void)pause;
-(void)resume;

@end
