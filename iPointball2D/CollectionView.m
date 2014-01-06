//
//  PickerLayer.m
//  iPointball2D
//
//  Created by Ryan Frahm on 1/6/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "CollectionView.h"

@implementation CollectionView

-(id)initWithData:(NSArray *)cellContents {
    self = [super initWithColor:ccc4(255, 255, 255, 150)];
    if(self) {
        NSMutableArray* tempContents = [[NSMutableArray alloc] init];
        for(int i=0; i<[cellContents count]; i++) {
            if([[[cellContents objectAtIndex:i] objectForKey:@"owned"] boolValue]) {
                [tempContents addObject:[cellContents objectAtIndex:i]];
            }
        }
        int count = tempContents.count;
        int cols = [self numberColumnsInCollectionView];
        int rows = count/cols + 1;
        int idx = 0;
        
        for(int row=0; row<rows; row++) {
            for(int col=0; col<cols; col++) {
                if(count>0) {
                    CollectionViewCell* cell = [self cellWithContents:[tempContents objectAtIndex:idx] atIndexPath:idx];
                    [cell setPosition:ccp(col*110, row*-110)];
                    [self addChild:cell z:2];
                    idx++;
                } else {
                    break;
                }
                count--;
            }
            break;
        }
    }
    return self;
}

-(CollectionViewCell*)cellWithContents:(NSDictionary*)cellContents atIndexPath:(NSUInteger)idx {
    CollectionViewCell* cell = [[CollectionViewCell alloc] init];
    cell.delegate = self;
    cell.idx = idx;
    CGSize cellSize = [cell cellSize];
    CCLabelTTF* cellTitle = [CCLabelTTF labelWithString:[cellContents objectForKey:@"title"] fontName:@"Marker Felt" fontSize:18];
    [cellTitle setPosition:ccp(cellSize.width/2, cellSize.height/2)];
    [cell addChild:cellTitle];
    return cell;
}

-(NSUInteger)numberColumnsInCollectionView {
    return 3;
}

-(void)cellTouchedAtIndex:(NSUInteger)idx {
    [self.parent removeChild:self cleanup:YES];
}

@end
