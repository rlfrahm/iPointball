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
        self.ownedObjects = [[NSMutableArray alloc] init];
        for(int i=0; i<[cellContents count]; i++) {
            if([[[cellContents objectAtIndex:i] objectForKey:@"owned"] boolValue]) {
                [self.ownedObjects addObject:[cellContents objectAtIndex:i]];
            }
        }
        int count = self.ownedObjects.count;
        int cols = [self numberColumnsInCollectionView];
        int rows = count/cols + 1;
        int idx = 0;
        
        self.cellPositions = [[NSMutableArray alloc] init];
        for(int row=0; row<rows; row++) {
            for(int col=0; col<cols; col++) {
                if(count>0) {
                    CollectionViewCell* cell = [self cellWithContents:[self.ownedObjects objectAtIndex:idx] atIndexPath:idx];
                    [cell setPosition:ccp(col*110, row*-110)];
                    [self.cellPositions addObject:[NSValue valueWithCGPoint:ccp(col*110, row*-110)]];
                    cell.idx = idx;
                    [self addChild:cell z:2];
                    idx++;
                } else {
                    break;
                }
                count--;
            }
            break;
        }
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}

-(CollectionViewCell*)cellWithContents:(NSDictionary*)cellContents atIndexPath:(NSUInteger)idx {
    CollectionViewCell* cell = [[CollectionViewCell alloc] init];
    cell.delegate = self;
    CGSize cellSize = [cell cellSize];
    CCLabelTTF* cellTitle = [CCLabelTTF labelWithString:[cellContents objectForKey:@"title"] fontName:@"Marker Felt" fontSize:18];
    [cellTitle setPosition:ccp(cellSize.width/2, cellSize.height/2)];
    
    [cell setContentSize:cellSize];
    
    CCSprite* sprite = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"%@", [cellContents objectForKey:@"file"]]];
    sprite.scaleX = kLoadoutSpriteDefaultScale;
    sprite.scaleY = kLoadoutSpriteDefaultScale;
    [sprite setPosition:ccp(cell.contentSize.width/2, cell.contentSize.height/2)];
    [cell addChild:sprite];
    [cell addChild:cellTitle];
    return cell;
}

-(NSUInteger)numberColumnsInCollectionView {
    return 3;
}

-(void)cellTouchedAtIndex:(NSUInteger)idx {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([self.type isEqualToString:@"markers"]) {
        NSDictionary* marker = [self.ownedObjects objectAtIndex:idx];
        NSLog(@"%@", [marker objectForKey:@"title"]);
        [defaults setObject:[marker objectForKey:@"title"] forKey:@"marker_title"];
        [defaults setObject:[marker objectForKey:@"description"] forKey:@"marker_description"];
        [defaults setInteger:[[marker objectForKey:@"speed"] integerValue] forKey:@"marker_speed"];
        [defaults setInteger:[[marker objectForKey:@"accuracy"] integerValue] forKey:@"marker_accuracy"];
        [defaults setInteger:[[marker objectForKey:@"quality"] integerValue] forKey:@"marker_quality"];
        [defaults synchronize];
    } else if([self.type isEqualToString:@"barrels"]) {
        NSDictionary* barrel = [self.ownedObjects objectAtIndex:idx];
        [defaults setObject:[barrel objectForKey:@"title"] forKey:@"barrel_title"];
        [defaults setObject:[barrel objectForKey:@"description"] forKey:@"barrel_description"];
        [defaults setInteger:[[barrel objectForKey:@"accuracy"] integerValue] forKey:@"barrel_accuracy"];
        [defaults synchronize];
    } else if([self.type isEqualToString:@"hoppers"]) {
        NSDictionary* hopper = [self.ownedObjects objectAtIndex:idx];
        [defaults setObject:[hopper objectForKey:@"title"] forKey:@"hopper_title"];
        [defaults setObject:[hopper objectForKey:@"description"] forKey:@"hopper_description"];
        [defaults setInteger:[[hopper objectForKey:@"capacity"] integerValue] forKey:@"hopper_capacity"];
        [defaults synchronize];
    } else if([self.type isEqualToString:@"pods"]) {
        NSDictionary* pod = [self.ownedObjects objectAtIndex:idx];
        [defaults setObject:[pod objectForKey:@"title"] forKey:@"pods_title"];
        [defaults setInteger:[[pod objectForKey:@"capacity"] integerValue] forKey:@"pods_capacity"];
        [defaults synchronize];
    }
    
    if([self.delegate respondsToSelector:@selector(cellTouchedAtIndex:andType:)]) {
        [self.delegate cellTouchedAtIndex:idx andType:self.type];
    }
    
    [self.parent removeChild:self cleanup:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    for(int i=0; i<self.cellPositions.count; i++) {
        CGPoint pt = [[self.cellPositions objectAtIndex:i] CGPointValue];
        if(CGRectContainsPoint(CGRectMake(SCREEN.width/4 + pt.x,SCREEN.height/5 + pt.y, 100, 100), location)) {
            NSLog(@"HERE");
            /*if([self.delegate respondsToSelector:@selector(cellTouchedAtIndex:)]) {
             [self.delegate cellTouchedAtIndex:self.idx];
             }//*/
        }//*/
    }
}

@end
