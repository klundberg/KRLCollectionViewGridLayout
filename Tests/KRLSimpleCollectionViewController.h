//  Copyright (c) 2014 Kevin Lundberg.

#import <UIKit/UIKit.h>

@import KRLCollectionViewGridLayout;

/**
 Class to help test the grid layout
 */
@interface KRLSimpleCollectionViewController : UICollectionViewController <KRLCollectionViewDelegateGridLayout>

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, copy, readonly) NSMutableDictionary *visibleSupplementaryViews;

@property (nonatomic, copy, readonly) NSMutableDictionary *sectionInsets;
@property (nonatomic, copy, readonly) NSMutableDictionary *lineSpacings;
@property (nonatomic, copy, readonly) NSMutableDictionary *interitemSpacings;
@property (nonatomic, copy, readonly) NSMutableDictionary *headerLengths;
@property (nonatomic, copy, readonly) NSMutableDictionary *footerLengths;
@property (nonatomic, copy, readonly) NSMutableDictionary *columnCounts;
@property (nonatomic, copy, readonly) NSMutableDictionary *aspectRatios;

@end
