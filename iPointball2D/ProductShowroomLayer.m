//
//  UpgradeDetailLayer.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/3/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "ProductShowroomLayer.h"

@implementation ProductShowroomLayer {
    CCLabelTTF* title;
    CCLabelTTF* description;
    CCLabelTTF* price;
    CCLabelTTF* resale;
    CCLabelTTF* netGivenPrice;
    CCLabelTTF* netGivenResale;
    
    BOOL owned;
    
    NSURL* file;
    NSDictionary* plistContent;
    NSArray* upgrades;
    NSUserDefaults* defaults;
}

-(void)constructShowroom {
    title = [self makeSmallLabelWithString:@"Title"];
    description = [self makeSmallLabelWithString:@"Description"];
    price = [self makeSmallLabelWithString:@"Price"];
    resale = [self makeSmallLabelWithString:@"Resale"];
    
    [title setPosition:ccp(100, 100)];
    [description setPosition:ccp(50, 75)];
    [price setPosition:ccp(50, 50)];
    [resale setPosition:ccp(100, 50)];
    
    [self addChild:title];
    [self addChild:description];
    [self addChild:price];
    [self addChild:resale];
}

-(void)showMarkerWithIndex:(NSUInteger)idx {
    NSDictionary* marker = [self getObjectForKey:@"markers" atIndex:idx];
    //title = [self makeSmallLabelWithString:[marker objectForKey:@"title"]];
    //description = [self makeSmallLabelWithString:[marker objectForKey:@"description"]];
    //price = [self makeSmallLabelWithString:[marker objectForKey:@"price"]];
    //resale = [self makeSmallLabelWithString:[marker objectForKey:@"resale"]];
    [title setString:[marker objectForKey:@"title"]];
    [description setString:[marker objectForKey:@"description"]];
    [price setString:[NSString stringWithFormat:@"%@",[marker objectForKey:@"price"]]];
    [resale setString:[NSString stringWithFormat:@"%@",[marker objectForKey:@"resale"]]];
}

-(NSDictionary*)getObjectForKey:(NSString*)key atIndex:(NSUInteger)idx {
    file = [[NSBundle mainBundle] URLForResource:@"store" withExtension:@"plist"];
    plistContent = [NSDictionary dictionaryWithContentsOfURL:file];
    upgrades = [plistContent objectForKey:key];
    return [upgrades objectAtIndex:idx];
}

-(CCLabelTTF*)makeSmallLabelWithString:(NSString*)string {
    return [CCLabelTTF labelWithString:string fontName:@"Palatino-Bold" fontSize:kFontSizeSmall dimensions:CGSizeMake(150, 48) hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeCharacterWrap];
}

@end
