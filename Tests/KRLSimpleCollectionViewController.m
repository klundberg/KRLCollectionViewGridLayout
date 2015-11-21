//  Copyright (c) 2014 Kevin Lundberg.

#import "KRLSimpleCollectionViewController.h"

@interface KRLSimpleCollectionViewController ()
@property (nonatomic, copy, readwrite) NSMutableDictionary *visibleSupplementaryViews;
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
        _visibleSupplementaryViews = [NSMutableDictionary dictionary];
        _visibleSupplementaryViews[UICollectionElementKindSectionHeader] = [NSMutableDictionary dictionary];
        _visibleSupplementaryViews[UICollectionElementKindSectionFooter] = [NSMutableDictionary dictionary];
        _sectionInsets = [NSMutableDictionary dictionary];
        _lineSpacings = [NSMutableDictionary dictionary];
        _interitemSpacings = [NSMutableDictionary dictionary];
        _headerLengths = [NSMutableDictionary dictionary];
        _footerLengths = [NSMutableDictionary dictionary];
        _columnCounts = [NSMutableDictionary dictionary];
        _aspectRatios = [NSMutableDictionary dictionary];
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
    self.visibleSupplementaryViews[kind][indexPath] = view;
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *viewsForKind = self.visibleSupplementaryViews[elementKind];
    [viewsForKind removeObjectForKey:indexPath];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSValue *value = self.sectionInsets[@(section)];
    if (value == nil) {
        return [(id)collectionViewLayout sectionInset];
    }
    return [value UIEdgeInsetsValue];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section
{
    NSNumber *value = self.lineSpacings[@(section)];
    if (value == nil) {
        return [(id)collectionViewLayout lineSpacing];
    }
    return [value doubleValue];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section
{
    NSNumber *value = self.interitemSpacings[@(section)];
    if (value == nil) {
        return [(id)collectionViewLayout interitemSpacing];
    }
    return [value doubleValue];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceLengthForHeaderInSection:(NSInteger)section
{
    NSNumber *value = self.headerLengths[@(section)];
    if (value == nil) {
        return [(id)collectionViewLayout headerReferenceLength];
    }
    return [value doubleValue];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceLengthForFooterInSection:(NSInteger)section
{
    NSNumber *value = self.footerLengths[@(section)];
    if (value == nil) {
        return [(id)collectionViewLayout footerReferenceLength];
    }
    return [value doubleValue];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout numberItemsPerLineForSectionAtIndex:(NSInteger)section
{
    NSNumber *value = self.columnCounts[@(section)];
    if (value == nil) {
        return [(id)collectionViewLayout numberOfItemsPerLine];
    }
    return [value integerValue];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout aspectRatioForItemsInSectionAtIndex:(NSInteger)section
{
    NSNumber *value = self.aspectRatios[@(section)];
    if (value == nil) {
        return [(id)collectionViewLayout aspectRatio];
    }
    return [value doubleValue];
}

@end
