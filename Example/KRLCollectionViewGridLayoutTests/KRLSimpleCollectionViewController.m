//
//  KRLSimpleCollectionViewController.m
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 3/9/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import "KRLSimpleCollectionViewController.h"

@interface KRLSimpleCollectionViewController ()

@property (nonatomic, copy, readwrite) NSSet *visibleSupplementaryViews;

@end

@implementation KRLSimpleCollectionViewController

- (void)dealloc
{
    // needed to avoid unit test crashes.
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    self.collectionView = nil;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _visibleSupplementaryViews = [NSSet set];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerfooter"];
    [self.collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"headerfooter"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.items[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerfooter" forIndexPath:indexPath];
    self.visibleSupplementaryViews = [self.visibleSupplementaryViews setByAddingObject:view];
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSMutableSet *set = [self.visibleSupplementaryViews mutableCopy];
    [set removeObject:view];
    self.visibleSupplementaryViews = set;
}

@end
