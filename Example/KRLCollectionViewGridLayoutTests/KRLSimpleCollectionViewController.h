//
//  KRLSimpleCollectionViewController.h
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 3/9/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRLSimpleCollectionViewController : UICollectionViewController

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, copy, readonly) NSSet *visibleSupplementaryViews;

@end
