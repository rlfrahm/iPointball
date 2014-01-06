//
//  MarkerTable.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/3/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "MarkerTable.h"
#import "UpgradeCell.h"
#import "UpgradeScene.h"

@implementation MarkerTable {
    NSURL* file;
    NSMutableArray* plistContent;
    NSDictionary* markerN;
    NSUserDefaults* defaults;
}

-(id)init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

-(Class)cellClassForTable:(SWTableView*)table {
    return [UpgradeCell class];
}

-(CGSize)cellSizeForTable:(SWTableView *)table {
    return [UpgradeCell cellSize];
}

-(SWTableViewCell*)table:(SWTableView *)table cellAtIndex:(NSUInteger)idx {
    SWTableViewCell* cell = [table dequeueCell];
    // Create references to upgrades.plist
    file = [[NSBundle mainBundle] URLForResource:@"upgrades" withExtension:@"plist"];
    NSDictionary* d = [NSDictionary dictionaryWithContentsOfURL:file];
    plistContent = [NSMutableArray array];
    plistContent = [d objectForKey:@"markers"];
    
    markerN = [plistContent objectAtIndex:idx];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if(!cell) {
        cell = [[UpgradeCell new] autorelease];
        cell.anchorPoint = CGPointZero;
    } else {
        [cell.children removeAllObjects];
    }
    CGSize size = [UpgradeCell cellSize];
    
    CCSprite* sprite = [CCSprite node];
    
    sprite.color = ccc3(random_range(10, 100), random_range(10, 100), random_range(10, 100));
    sprite.textureRect = CGRectMake(0, 0, size.width, size.height);
    sprite.opacity = 100;
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", [markerN objectForKey:@"title"]] fontName:@"Palatino-Bold" fontSize:18];
    label.position = ccp(size.width/2 - 80,size.height/2);
    [sprite addChild:label z:0 tag:0];
    
    CCMenuItemFont* ownedLabel;
    BOOL owned = [[markerN objectForKey:@"owned"] boolValue];
    if(owned) {
        ownedLabel = [CCMenuItemFont itemWithString:@"equip" block:^(id sender){
            NSDictionary* marker = [NSDictionary dictionaryWithDictionary:markerN];
            NSString* title = [NSString stringWithFormat:@"%@", [marker objectForKey:@"title"]];
            [defaults setObject:title forKey:@"marker_title"];
            [defaults setObject:[NSString stringWithFormat:@"%@", [marker objectForKey:@"description"]] forKey:@"marker_description"];
            [defaults setInteger:[[marker objectForKey:@"speed"] integerValue] forKey:@"marker_speed"];
            [defaults setInteger:[[marker objectForKey:@"accuracy"] integerValue] forKey:@"marker_accuracy"];
            [defaults setInteger:[[marker objectForKey:@"quality"] integerValue] forKey:@"marker_quality"];
            [defaults synchronize];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                            message:[NSString stringWithFormat:@"Equipping %@", [[markerN objectForKey:@"title"] stringValue]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }];
        //ownedLabel = [CCLabelTTF labelWithString:@"owned" fontName:@"Palatino-Bold" fontSize:12];
    } else {
        ownedLabel = [CCMenuItemFont itemWithString:@"buy" block:^(id sender){
            
        }];
    }
    [ownedLabel setFontSize:12];
    CCMenu* menu = [CCMenu menuWithItems:ownedLabel, nil];
    menu.position = ccp(size.width - 20, size.height/2);
    [sprite addChild:menu];
    
    sprite.tag = 1;
    sprite.anchorPoint = CGPointZero;
    [cell addChild:sprite];
    
    return cell;
}

-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return 6;
}

-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell {
    NSLog(@"Cell touched at index: %i", cell.idx);
    if([self.delegate respondsToSelector:@selector(markerTableView:didSelectCell:atIndex:)]) {
        [self.delegate markerTableView:table didSelectCell:cell atIndex:cell.idx];
    }
}

-(void)dealloc {
    [super dealloc];
    [plistContent release];
}

@end
