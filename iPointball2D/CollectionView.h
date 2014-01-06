//
//  PickerLayer.h
//  iPointball2D
//
//  Created by Ryan Frahm on 1/6/14.
//  Copyright (c) 2014 Ryan Frahm. All rights reserved.
//

#import "cocos2d.h"
#import "CollectionViewCell.h"

@interface CollectionView : CCLayerColor<CollectionViewCellDelegate>

-(id)initWithData:(NSDictionary*)dict;

@end
