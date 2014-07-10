//
//  KLGridLayout.h
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 6/14/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A layout that positions and sizes cells based on the numberOfItemsPerLine and aspectRatio properties.
 */
@interface KRLCollectionViewGridLayout : UICollectionViewLayout

/**
 Controls whether or not the user scrolls vertically or horizontally.
 If vertical, cells lay out left to right and new lines lay out below.
 If horizontal, cells lay out top to bottom and new lines lay out to the right.
 Defaults to vertical.
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
/**
 If specified, each section will have a border around it defined by these insets.
 Defaults to UIEdgeInsetsZero.
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/**
 How much space the layout should place between items on the same line.
 Defaults to 10.
 */
@property (nonatomic, assign) CGFloat interitemSpacing;
/**
 How much space the layout should place between lines.
 Defaults to 10.
 */
@property (nonatomic, assign) CGFloat lineSpacing;
/**
 How many items the layout should place on a single line.
 Defaults to 1.
 */
@property (nonatomic, assign) NSInteger numberOfItemsPerLine;
/**
 The ratio of every item's width to its height (regardless of scroll direction).
 Defaults to 1 (square).
 */
@property (nonatomic, assign) CGFloat aspectRatio;

@end
