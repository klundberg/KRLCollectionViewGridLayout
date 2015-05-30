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

@end

@interface KRLCustomCellSizeCollectionViewController ()
@property (nonatomic, strong, readwrite) NSMutableDictionary *cellLengths;
@end
@implementation KRLCustomCellSizeCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _cellLengths = [NSMutableDictionary dictionary];
    }
    return self;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout lengthForItemAtIndexPath:(NSIndexPath *)indexPath withDepth:(CGFloat)depth
{
    NSNumber *length = self.cellLengths[indexPath];

    if (length == nil) {
        KRLCollectionViewGridLayout *layout = (id)collectionViewLayout;
        CGFloat ratio = (layout.scrollDirection == UICollectionViewScrollDirectionVertical ? 1.0 / layout.aspectRatio : layout.aspectRatio);
        return depth * ratio;
    }

    return length.doubleValue;
}

@end
