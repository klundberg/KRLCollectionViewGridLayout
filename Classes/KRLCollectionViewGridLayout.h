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
@property (nonatomic, assign) IBInspectable UICollectionViewScrollDirection scrollDirection;
/**
 If specified, each section will have a border around it defined by these insets.
 Defaults to UIEdgeInsetsZero.
 */
@property (nonatomic, assign) IBInspectable UIEdgeInsets sectionInset;
/**
 How much space the layout should place between items on the same line.
 Defaults to 10.
 */
@property (nonatomic, assign) IBInspectable CGFloat interitemSpacing;
/**
 How much space the layout should place between lines.
 Defaults to 10.
 */
@property (nonatomic, assign) IBInspectable CGFloat lineSpacing;
/**
 How many items the layout should place on a single line.
 Defaults to 1.
 */
@property (nonatomic, assign) IBInspectable NSInteger numberOfItemsPerLine;
/**
 The ratio of every item's width to its height (regardless of scroll direction).
 Defaults to 1 (square).
 */
@property (nonatomic, assign) IBInspectable CGFloat aspectRatio;
/**
 The size of a header for all sections. Defaults to CGSizeZero.
 If scrollDirection is vertical, only the height dimension matters. If scrollDirection is horizontal, only the width dimension matters.
 If the relevant dimension is zero, no header is created.
 */
@property (nonatomic, assign) IBInspectable CGSize headerReferenceSize;
/**
 The size of a footer for all sections. Defaults to CGSizeZero.
 If scrollDirection is vertical, only the height dimension matters. If scrollDirection is horizontal, only the width dimension matters.
 If the relevant dimension is zero, no footer is created.
 */
@property (nonatomic, assign) IBInspectable CGSize footerReferenceSize;

@end
