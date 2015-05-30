//  Copyright (c) 2014 Kevin Lundberg.

#import <UIKit/UIKit.h>
#import "KRLCollectionViewGridLayout.h"

@interface KRLSimpleCollectionViewController : UICollectionViewController <KRLCollectionViewDelegateGridLayout>

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, copy, readonly) NSMutableDictionary *visibleSupplementaryViews;

@property (nonatomic, copy, readonly) NSMutableDictionary *sectionInsets;

@end


@interface KRLCustomCellSizeCollectionViewController : KRLSimpleCollectionViewController

@property (nonatomic, strong, readonly) NSMutableDictionary *cellLengths;

@end