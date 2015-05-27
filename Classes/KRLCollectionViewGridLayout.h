//  Copyright (c) 2014 Kevin Lundberg.

@import UIKit;

@protocol KRLCollectionViewDelegateGridLayout <NSObject>

@optional

/**
 Asks the delegate for the length of each cell.

 @param collectionView       The collection view object displaying the grid layout.
 @param collectionViewLayout The layout object requesting the information.
 @param indexPath            The index path of the cell whose length information we want.
 @param depth                How "deep" the cell is (depth is the width of the cell in vertical scrolling mode, and height in horizontal scrolling mode).

 @return How long the cell should be (length is used as width in horizontal scrolling mode, and height in vertical scrolling mode).
 
 @discussion if this method is not implemented, the cell's length is determined by the aspectRatio given to the layout and the number of columns the layout has.
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout lengthForItemAtIndexPath:(NSIndexPath *)indexPath withDepth:(CGFloat)depth;

/**
 Asks the delegate for the margins to apply to content in the specified section.

 @param collectionView       The collection view object displaying the grid layout.
 @param collectionViewLayout The layout object requesting the information.
 @param section              The index number of the section whose insets are needed.

 @return The margins to apply to items in the section.
 
 @discussion The return value of this method is applied to it's desired section in the same way as UICollectionViewFlowLayout uses it (applies it to section items only, not headers and footers).
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout numberOfColumnsForSectionAtIndex:(NSInteger)section;

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
