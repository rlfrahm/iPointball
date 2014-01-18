//
//  HoppersTable.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/18/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "UpgradesTable.h"
#import "UpgradeCell.h"

@implementation UpgradesTable {
    NSMutableDictionary* cellContent;
    NSUserDefaults* defaults;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(SWTableViewCell*)table:(SWTableView *)table cellAtIndex:(NSUInteger)idx {
    SWTableViewCell* cell = [table dequeueCell];
    cellContent = [self.upgrades objectAtIndex:idx];
    
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
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", [cellContent objectForKey:@"title"]] fontName:@"Palatino-Bold" fontSize:18];
    label.position = ccp(size.width/2 - 80,size.height/2);
    [sprite addChild:label z:0 tag:0];
    
    CCMenuItemFont* ownedLabel;
    BOOL owned = [[cellContent objectForKey:@"owned"] boolValue];
    if(owned) {
        ownedLabel = [CCMenuItemFont itemWithString:@"equip" block:^(id sender){
            NSDictionary* content = [NSDictionary dictionaryWithDictionary:cellContent];
            NSString* title = [NSString stringWithFormat:@"%@", [content objectForKey:@"title"]];
            [defaults setObject:title forKey:@"content_title"];
            [defaults setObject:[NSString stringWithFormat:@"%@", [content objectForKey:@"description"]] forKey:@"content_description"];
            [defaults setInteger:[[content objectForKey:@"speed"] integerValue] forKey:@"content_speed"];
            [defaults setInteger:[[content objectForKey:@"accuracy"] integerValue] forKey:@"content_accuracy"];
            [defaults setInteger:[[content objectForKey:@"quality"] integerValue] forKey:@"content_quality"];
            [defaults synchronize];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                            message:[NSString stringWithFormat:@"Equipping %@", [[cellContent objectForKey:@"title"] stringValue]]
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

-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell {
    if([self.delegate respondsToSelector:@selector(UpgradesTableView:didSelectCell:atIndex:)]) {
        [self.delegate UpgradesTableView:table didSelectCell:cell atIndex:cell.idx];
    }
}

-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return self.upgrades ? [self.upgrades count] : 0;
}

-(CGSize)cellSizeForTable:(SWTableView *)table {
    return [UpgradeCell cellSize];
}

-(void)dealloc {
    [super dealloc];
    [cellContent release];
}


@end
