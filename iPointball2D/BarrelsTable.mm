//
//  PlayerTable.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/3/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "BarrelsTable.h"
#import "UpgradeCell.h"

@implementation BarrelsTable {
    NSDictionary* barrel;
}

-(Class)cellClassForTable:(SWTableView*)table {
    return [UpgradeCell class];
}

-(CGSize)cellSizeForTable:(SWTableView *)table {
    return [UpgradeCell cellSize];
}

-(SWTableViewCell*)table:(SWTableView *)table cellAtIndex:(NSUInteger)idx {
    SWTableViewCell* cell = [table dequeueCell];
    NSURL* file = [[NSBundle mainBundle] URLForResource:@"upgrades" withExtension:@"plist"];
    NSDictionary* upgrades = [[NSDictionary alloc] initWithContentsOfURL:file];
    self.barrels = [NSMutableArray array];
    self.barrels = [upgrades objectForKey:@"barrels"];
    barrel = [self.barrels objectAtIndex:idx];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if(!cell) {
        cell = [[UpgradeCell new] autorelease];
        cell.anchorPoint = CGPointZero;
    } else {
        [cell.children removeAllObjects];
    }
    CGSize size = [UpgradeCell cellSize];
    
    CCSprite* sprite = [CCSprite node];
    
    sprite.color = ccc3(255, 151, 0);
    sprite.textureRect = CGRectMake(0, 0, size.width, size.height);
    sprite.opacity = 100;
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", [barrel objectForKey:@"title"]] fontName:@"Palatino-Bold" fontSize:22];
    label.position = ccp(size.width/2 - 80,size.height/2);
    sprite.anchorPoint = CGPointZero;
    [sprite addChild:label];
    
    CCMenuItemFont* ownedLabel;
    BOOL owned = [[barrel objectForKey:@"owned"] boolValue];
    if(owned) {
        ownedLabel = [[CCMenuItemFont alloc] initWithString:@"equip" block:^(id sender) {
            NSDictionary* b = [NSDictionary dictionaryWithDictionary:barrel];
            NSString* title = [NSString stringWithFormat:@"%@", [b objectForKey:@"title"]];
            [defaults setObject:title forKey:@"barrel_title"];
            [defaults setObject:[NSString stringWithFormat:@"%@", [b objectForKey:@"description"]] forKey:@"barrel_description"];
            [defaults setInteger:[[b objectForKey:@"speed"] integerValue] forKey:@"barrel_speed"];
            [defaults setInteger:[[b objectForKey:@"accuracy"] integerValue] forKey:@"barrel_accuracy"];
            [defaults setInteger:[[b objectForKey:@"quality"] integerValue] forKey:@"barrel_quality"];
            [defaults synchronize];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                            message:[NSString stringWithFormat:@"Equipping %@", [[barrel objectForKey:@"title"] stringValue]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }];
    } else {
        ownedLabel = [CCMenuItemFont itemWithString:@"buy" block:^(id sender){
            
        }];
    }
    [ownedLabel setFontSize:12];
    CCMenu* menu = [CCMenu menuWithItems:ownedLabel, nil];
    menu.position = ccp(size.width - 20, size.height/2);
    [sprite addChild:menu];
    
    [cell addChild:sprite];
    
    
    return cell;
}

-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return 1;
}

-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell {
    NSLog(@"Cell touched at index: %i", cell.idx);
    if([self.delegate respondsToSelector:@selector(barrelTableView:didSelectCell:atIndex:)]) {
        [self.delegate barrelTableView:table didSelectCell:cell atIndex:cell.idx];
    }
}

-(void)dealloc {
    [super dealloc];
    [barrel release];
}

@end
