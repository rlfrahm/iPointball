//
//  UpgradeDetailLayer.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/3/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "ProductShowroomLayer.h"

@interface ProductShowroomLayer ()

@property (nonatomic, retain) NSDictionary* marker;
@property (nonatomic, retain) NSDictionary* upgrade;

@end

@implementation ProductShowroomLayer {
    CCLabelTTF* title;
    CCLabelTTF* description;
    CCLabelTTF* price;
    CCLabelTTF* resale;
    CCLabelTTF* netGivenPrice;
    CCLabelTTF* netGivenResale;
    
    CCMenuItemFont* equipMenuItem;
    CCMenuItemFont* buySellMenuItem;
    CCMenu* menu;
    
    CCSprite* markerSprite;
    CCSprite* upgradeSprite;
    
    BOOL owned;
    
    NSURL* file;
    NSArray* plistContent;
    NSUserDefaults* defaults;
    
    NSUInteger index;
}

@synthesize marker, upgrade;

-(void)constructShowroom {
    title = [self makeSmallLabelWithString:@"Title"];
    description = [self makeSmallLabelWithString:@"Description"];
    price = [self makeSmallLabelWithString:@"Price"];
    resale = [self makeSmallLabelWithString:@"Resale"];
    
    defaults = [NSUserDefaults standardUserDefaults];
    equipMenuItem = [CCMenuItemFont itemWithString:@"Equip" target:self selector:@selector(equipItem)];
    buySellMenuItem = [CCMenuItemFont itemWithString:@"Buy" block:^(id sender){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[title string]
                                                        message:@"Are you sure you want to buy this?"
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles: nil];
        [alert addButtonWithTitle:@"No"];
        if(owned) {
            [alert setMessage:@"Are you sure you want to sell this?"];
        }
        alert.delegate = self;
        [alert show];
        [alert release];
    }];
    menu = [CCMenu menuWithItems:equipMenuItem, buySellMenuItem, nil];
    [menu alignItemsHorizontallyWithPadding:40];
    [menu setPosition:ccp(50, 25)];
    [self addChild:menu];
    
    [title setPosition:ccp(100, 100)];
    [description setPosition:ccp(50, 75)];
    [price setPosition:ccp(50, 50)];
    [resale setPosition:ccp(100, 50)];
    
    [self addChild:title];
    [self addChild:description];
    [self addChild:price];
    [self addChild:resale];
}

-(void)equipItem {
    if(owned) {
        NSString* upgradeType = [upgrade objectForKey:@"type"];
        defaults = [NSUserDefaults standardUserDefaults];
        if([upgradeType hasPrefix:@"marker"]) {
            [defaults setObject:[upgrade objectForKey:@"title"] forKey:@"marker_title"];
            [defaults setObject:[upgrade objectForKey:@"description"] forKey:@"marker_description"];
            [defaults setInteger:[[upgrade objectForKey:@"accuracy"] integerValue] forKey:@"marker_accuracy"];
            [defaults setInteger:[[upgrade objectForKey:@"speed"] integerValue] forKey:@"marker_speed"];
            [defaults setInteger:[[upgrade objectForKey:@"quality"] integerValue] forKey:@"marker_quality"];
            [defaults synchronize];
            NSLog(@"Marker equipped..");
        } else if([upgradeType hasPrefix:@"barrel"]) {
            [defaults setObject:[upgrade objectForKey:@"title"] forKey:@"barrel_title"];
            [defaults setObject:[upgrade objectForKey:@"description"] forKey:@"barrel_description"];
            [defaults setInteger:[[upgrade objectForKey:@"accuracy"] integerValue] forKey:@"barrel_accuracy"];
            [defaults synchronize];
            NSLog(@"Barrel equipped..");
        } else if([upgradeType hasPrefix:@"hopper"]) {
            [defaults setObject:[upgrade objectForKey:@"title"] forKey:@"hopper_title"];
            [defaults setObject:[upgrade objectForKey:@"description"] forKey:@"hopper_description"];
            [defaults setInteger:[[upgrade objectForKey:@"capacity"] integerValue] forKey:@"hopper_capacity"];
            [defaults synchronize];
            NSLog(@"Hopper equipped..");
        } else if([upgradeType hasPrefix:@"pod"]) {
            [defaults setObject:[upgrade objectForKey:@"title"] forKey:@"pod_title"];
            [defaults setInteger:[[upgrade objectForKey:@"capacity"] integerValue] forKey:@"pod_capacity"];
            [defaults synchronize];
            NSLog(@"Pod equipped..");
        }
    } else {
        
    }
}

-(void)updatePlistWithBoughtMarker {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:[self filepath]];
    if(success) {
        NSMutableDictionary* tempRoot = [NSMutableDictionary dictionaryWithContentsOfFile:[self filepath]];
        NSMutableArray* tempMarkers = [tempRoot objectForKey:@"markers"];;
        NSMutableDictionary* tempMarker = [tempMarkers objectAtIndex:index];
        if(owned) {
            [tempMarker setObject:[NSNumber numberWithBool:YES] forKey:@"owned"];
        } else {
            [tempMarker setObject:[NSNumber numberWithBool:NO] forKey:@"owned"];
        }
        [tempMarkers removeObjectAtIndex:index];
        [tempMarkers insertObject:tempMarker atIndex:index];
        [tempRoot setObject:tempMarkers forKey:@"markers"];
        [tempRoot writeToFile:[self filepath] atomically:YES];
    } else {
        
    }
}

-(void)updatePlistWithSoldMarker {
    
}

-(NSString*)filepath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"upgrades.plist"];
}

-(void)showUpgradeAtIndex:(NSUInteger)idx fromUpgrades:(NSMutableArray *)upgrades {
    [self removeChild:upgradeSprite cleanup:YES];
    upgrade = [upgrades objectAtIndex:idx];
    //if(!upgrade || upgrade.count != 0) NSLog(@"Upgrade is nil or empty for the product showroom!"); return;
    [title setString:[upgrade objectForKey:@"title"]];
    [description setString:[upgrade objectForKey:@"description"]];
    [price setString:[NSString stringWithFormat:@"$%@",[upgrade objectForKey:@"price"]]];
    [resale setString:[NSString stringWithFormat:@"$%@",[upgrade objectForKey:@"resale"]]];
    owned = [[upgrade objectForKey:@"owned"] boolValue];
    upgradeSprite = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"%@",[upgrade objectForKey:@"file"]]];
    [upgradeSprite setPosition:ccp(0, 125)];
    [upgradeSprite setContentSize:CGSizeMake(50, 50)];
    upgradeSprite.scaleX = 0.1;
    upgradeSprite.scaleY = 0.1;
    [self addChild:upgradeSprite];
    if(owned) {
        [buySellMenuItem setString:@"Sell"];
    } else {
        [buySellMenuItem setString:@"Buy"];
    }
    
}

-(void)showMarkerWithIndex:(NSUInteger)idx {
    [self removeChild:markerSprite cleanup:YES];
    marker = [self getObjectForKey:@"markers" atIndex:idx];
    index = idx;
    //title = [self makeSmallLabelWithString:[marker objectForKey:@"title"]];
    //description = [self makeSmallLabelWithString:[marker objectForKey:@"description"]];
    //price = [self makeSmallLabelWithString:[marker objectForKey:@"price"]];
    //resale = [self makeSmallLabelWithString:[marker objectForKey:@"resale"]];
    [title setString:[marker objectForKey:@"title"]];
    [description setString:[marker objectForKey:@"description"]];
    [price setString:[NSString stringWithFormat:@"$%@",[marker objectForKey:@"price"]]];
    [resale setString:[NSString stringWithFormat:@"$%@",[marker objectForKey:@"resale"]]];
    owned = [[marker objectForKey:@"owned"] boolValue];
    markerSprite = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"%@",[marker objectForKey:@"file"]]];
    [markerSprite setPosition:ccp(0, 125)];
    [markerSprite setContentSize:CGSizeMake(50, 50)];
    markerSprite.scaleX = 0.4;
    markerSprite.scaleY = 0.4;
    [self addChild:markerSprite];
    
    if(owned) {
        [buySellMenuItem setString:@"Sell"];
    } else {
        [buySellMenuItem setString:@"Buy"];
    }
}

-(void)showBarrelWithIndex:(NSUInteger)idx {
    
}

-(NSDictionary*)getObjectForKey:(NSString*)key atIndex:(NSUInteger)idx {
    file = [[NSBundle mainBundle] URLForResource:@"upgrades" withExtension:@"plist"];
    NSDictionary* d = [NSDictionary dictionaryWithContentsOfURL:file];
    plistContent = [d objectForKey:key];
    return [plistContent objectAtIndex:idx];
}

-(CCLabelTTF*)makeSmallLabelWithString:(NSString*)string {
    return [CCLabelTTF labelWithString:string fontName:@"Palatino-Bold" fontSize:kFontSizeSmall dimensions:CGSizeMake(150, 48) hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeCharacterWrap];
}

-(void)buyItem {
    owned = YES;
    int dollars = [defaults integerForKey:@"player_dollars"];
    if(dollars >= [[price string] intValue]) {
        dollars = dollars - [[price string] intValue];
        [self updatePlistWithBoughtMarker];
        if([self.delegate respondsToSelector:@selector(buyItemAtIndex:andNetDollars:)]) {
            [self.delegate buyItemAtIndex:index andNetDollars:dollars];
        }
    }
    [buySellMenuItem setString:@"Sell"];
    [defaults setInteger:dollars forKey:@"player_dollars"];
}

-(void)sellItem {
    owned = NO;
    int dollars = [defaults integerForKey:@"player_dollars"] + [[resale string] intValue];
    [self updatePlistWithSoldMarker];
    if([self.delegate respondsToSelector:@selector(sellItemAtIndex:andNetDollars:)]) {
        [self.delegate sellItemAtIndex:index andNetDollars:dollars];
    }
    [buySellMenuItem setString:@"Buy"];
    [defaults setInteger:dollars forKey:@"player_dollars"];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* action = [alertView buttonTitleAtIndex:buttonIndex];
    if([action isEqualToString:@"Yes"]) {
        if(owned) {
            [self sellItem];
        } else {
            [self buyItem];
        }
    }
}

-(void)dealloc {
    [super dealloc];
    [marker release];
    [upgrade release];
}

@end
