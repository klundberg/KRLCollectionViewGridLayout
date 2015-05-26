//
//  KRLSimpleCollectionViewController.h
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 3/9/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRLCollectionViewGridLayout.h"

@interface KRLSimpleCollectionViewController : UICollectionViewController <KRLCollectionViewDelegateGridLayout>

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, copy, readonly) NSMutableDictionary *visibleSupplementaryViews;

@property (nonatomic, copy, readonly) NSMutableDictionary *sectionInsets;

@end
