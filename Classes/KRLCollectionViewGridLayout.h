//  Copyright (c) 2014 Kevin Lundberg.

@import UIKit;

@protocol KRLCollectionViewDelegateGridLayout <NSObject>

@optional

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout lengthForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForFooterInSection:(NSInteger)section;

@end

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
 Defaults to 10.
 */
@property (nonatomic, assign) IBInspectable NSInteger numberOfItemsPerLine;
/**
 The ratio of every item's width to its height (regardless of scroll direction).
 Defaults to 1 (square).
 */
@property (nonatomic, assign) IBInspectable CGFloat aspectRatio;
/**
 The length of a header for all sections. Defaults to 0.
 If scrollDirection is vertical, this length represents the height. If scrollDirection is horizontal, this length represents the width.
 If the length is zero, no header is created.
 */
@property (nonatomic, assign) IBInspectable CGFloat headerReferenceLength;
/**
 The length of a footer for all sections. Defaults to 0.
 If scrollDirection is vertical, this length represents the height. If scrollDirection is horizontal, this length represents the width.
 If the length is zero, no footer is created.
 */
@property (nonatomic, assign) IBInspectable CGFloat footerReferenceLength;

@end
