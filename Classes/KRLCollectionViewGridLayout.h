//
//  KLGridLayout.h
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 6/14/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRLCollectionViewGridLayout : UICollectionViewLayout

@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) NSInteger numberOfItemsPerLine;
@property (nonatomic, assign) CGFloat aspectRatio;

@end
