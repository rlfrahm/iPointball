//
//  SkillsTable.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/3/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "SkillsTable.h"
#import "UpgradeCell.h"

@implementation SkillsTable {
    NSDictionary* skills;
    NSArray* skillsList;
}

-(Class)cellClassForTable:(SWTableView*)table {
    return [UpgradeCell class];
}

-(CGSize)cellSizeForTable:(SWTableView *)table {
    return [UpgradeCell cellSize];
}

-(id)init {
    self = [super init];
    if(self) {
        NSURL* file = [[NSBundle mainBundle] URLForResource:@"skills" withExtension:@"plist"];
        skills = [NSDictionary dictionaryWithContentsOfURL:file];
        skillsList = [NSArray arrayWithObjects:@"handling",@"reload",@"trigger",@"speed", nil];
    }
    return self;
}

-(SWTableViewCell*)table:(SWTableView *)table cellAtIndex:(NSUInteger)idx {
    SWTableViewCell* cell = [table dequeueCell];
    NSDictionary* cellContents = [skills objectForKey:[skillsList objectAtIndex:idx]];
    
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
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:[cellContents objectForKey:@"title"] fontName:@"Palatino-Bold" fontSize:18];
    label.position = ccp(size.width/2 - 80,size.height/2);
    [sprite addChild:label];
    
    sprite.anchorPoint = CGPointZero;
    [cell addChild:sprite];
    
    return cell;
}

-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return 4;
}

-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell {
    NSLog(@"Cell touched at index: %i", cell.idx);
}

-(void)dealloc {
    [super dealloc];
}

@end
