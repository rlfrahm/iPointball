//
//  PickerLayer.h
//  iPointball2D
//
//  Created by Ryan Frahm on 1/6/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "cocos2d.h"
#import "CollectionViewCell.h"

@protocol CollectionViewDelegate;

@interface CollectionView : CCLayerColor<CollectionViewCellDelegate>

@property (nonatomic, assign) id<CollectionViewDelegate> delegate;
@property (nonatomic, assign) NSString* type;
@property (nonatomic, assign) NSMutableArray* ownedObjects;
@property (nonatomic, assign) NSMutableArray* cells;

-(id)initWithData:(NSDictionary*)dict;

@end

@protocol CollectionViewDelegate <NSObject>

-(void)cellTouchedAtIndex:(NSUInteger)idx andType:(NSString*)type;
-(void)changeValuesUsingDictionary:(NSDictionary*)values;

@end

