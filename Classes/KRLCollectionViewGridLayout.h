//  Copyright (c) 2014 Kevin Lundberg.

#import <UIKit/UIKit.h>

//! Project version number for KRLGridThing.
FOUNDATION_EXPORT double KRLCollectionViewGridLayoutVersionNumber;

//! Project version string for KRLGridThing.
FOUNDATION_EXPORT const unsigned char KRLCollectionViewGridLayoutVersionString[];

NS_ASSUME_NONNULL_BEGIN

@protocol KRLCollectionViewDelegateGridLayout <NSObject>

@optional
/**
 Asks the delegate for the margins to apply to content in the specified section.

 @param collectionView       The collection view object displaying the grid layout.
 @param collectionViewLayout The layout object requesting the information.
 @param section              The index number of the section whose insets are needed.

 @return The margins to apply to items in the section.
 
 @discussion The return value of this method is applied to it's desired section in the same way as UICollectionViewFlowLayout uses it (applies it to section items only, not headers and footers).
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

/**
 Asks the delegate for the amount of spacing between lines that the given section should have.

 @param collectionView       The collection view object displaying the grid layout.
 @param collectionViewLayout The layout object requesting the information.
 @param section              The index number of the section whose line spacing is needed.

 @return The line spacing the layout should use between lines of cells in the section at the given index.
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section;

/**
 Asks the delegate for the amount of spacing between cells on the sanme line that the given section should have.

 @param collectionView       The collection view object displaying the grid layout.
 @param collectionViewLayout The layout object requesting the information.
 @param section              The index number of the section whose inter-item spacing is needed.

 @return The inter-item spacing the layout should use between cells on the same line in the section at the given index
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

/**
 Asks the delegate for the number of columns the given section should have.

 @param collectionView       The collection view object displaying the grid layout.
 @param collectionViewLayout The layout object requesting the information.
 @param section              The index number of the section whose column count is needed

 @return The number of columns the layout should use for the section at the given index.
 */

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout numberItemsPerLineForSectionAtIndex:(NSInteger)section;

/**
 Asks the delegate for the aspect ratio that items in the given section should have

 @param collectionView       The collection view object displaying the grid layout.
 @param collectionViewLayout The layout object requesting the information.
 @param section              The index number of the section whose item aspect ratio is needed

 @return The aspect ratio the layout should use for items in the section at the given index.
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout aspectRatioForItemsInSectionAtIndex:(NSInteger)section;

/**
 Asks the delegate for the length of the header in the given section.

 @param collectionView       The collection view object displaying the grid layout.
 @param collectionViewLayout The layout object requesting the information.
 @param section              The index number of the section whose header length is needed.

 @return The length of the header for the section at the given index. A length of 0 prevents the header from being created.
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForHeaderInSection:(NSInteger)section;

/**
 Asks the delegate for the length of the footer in the given section.

 @param collectionView       The collection view object displaying the grid layout.
 @param collectionViewLayout The layout object requesting the information.
 @param section              The index number of the section whose footer length is needed.

 @return The length of the footer for the section at the given index. A length of 0 prevents the header from being created.
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForFooterInSection:(NSInteger)section;

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

NS_ASSUME_NONNULL_END
