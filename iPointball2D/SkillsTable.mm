//
//  SkillsTable.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/3/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "SkillsTable.h"
#import "UpgradeCell.h"

@implementation SkillsTable

-(Class)cellClassForTable:(SWTableView*)table {
    return [UpgradeCell class];
}

-(CGSize)cellSizeForTable:(SWTableView *)table {
    return [UpgradeCell cellSize];
}

-(SWTableViewCell*)table:(SWTableView *)table cellAtIndex:(NSUInteger)idx {
    SWTableViewCell* cell = [table dequeueCell];
    
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
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Skill %i", idx] fontName:@"Palatino-Bold" fontSize:22];
    label.position = ccp(size.width/2,size.height/2);
    [sprite addChild:label];
    
    sprite.anchorPoint = CGPointZero;
    [cell addChild:sprite];
    
    return cell;
}

-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return 15;
}

-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell {
    NSLog(@"Cell touched at index: %i", cell.idx);
}

-(void)dealloc {
    [super dealloc];
}

@end
