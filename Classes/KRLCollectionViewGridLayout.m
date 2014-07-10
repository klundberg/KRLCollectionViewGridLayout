//
//  KLGridLayout.m
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 6/14/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import "KRLCollectionViewGridLayout.h"

@interface KRLCollectionViewGridLayout ()
@property (nonatomic, strong) NSMutableArray *attributesBySection;
@property (nonatomic, assign, readwrite) CGFloat collectionViewContentLength;
@end

@implementation KRLCollectionViewGridLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    _numberOfItemsPerLine = 1;
    _aspectRatio = 1;
    _sectionInset = UIEdgeInsetsZero;
    _interitemSpacing = 10;
    _lineSpacing = 10;
    _scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (void)prepareLayout
{
    [self calculateContentSize];
    [self calculateLayoutAttributes];
}

- (CGSize)collectionViewContentSize
{
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(self.collectionView.bounds.size.width, self.collectionViewContentLength);
    } else {
        return CGSizeMake(self.collectionViewContentLength, self.collectionView.bounds.size.height);
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *visibleAttributes = [NSMutableArray array];
    for (NSArray *sectionAttributes in self.attributesBySection) {
        for (UICollectionViewLayoutAttributes *attributes in sectionAttributes) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [visibleAttributes addObject:attributes];
            }
        }
    }
    return [visibleAttributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.attributesBySection[indexPath.section][indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

- (void)calculateContentSize
{
    CGSize cellSize = [self cellSize];
    CGFloat contentLength = 0;

    NSInteger sections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sections; section++) {
        contentLength += [self contentLengthForSection:section withCellSize:cellSize];
    }

    self.collectionViewContentLength = contentLength;
}

- (CGFloat)contentLengthForSection:(NSInteger)section withCellSize:(CGSize)cellSize
{
    NSInteger rowsInSection = [self rowsInSection:section];

    CGFloat contentLength = (rowsInSection - 1) * self.lineSpacing;
    contentLength += [self lengthwiseInsetLength];

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        contentLength += rowsInSection * cellSize.height;
    } else {
        contentLength += rowsInSection * cellSize.width;
    }
    return contentLength;
}

- (NSInteger)rowsInSection:(NSInteger)section
{
    NSInteger itemsInSection = [self.collectionView numberOfItemsInSection:section];
    NSInteger rowsInSection = itemsInSection / self.numberOfItemsPerLine + (itemsInSection % self.numberOfItemsPerLine > 0 ? 1 : 0);
    return rowsInSection;
}

- (CGFloat)lengthwiseInsetLength
{
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return self.sectionInset.top + self.sectionInset.bottom;
    } else {
        return self.sectionInset.left + self.sectionInset.right;
    }
}

- (void)calculateLayoutAttributes
{
    self.attributesBySection = [NSMutableArray array];
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        [self.attributesBySection addObject:[self layoutAttributesForItemsInSection:section]];
    }
}

- (NSArray *)layoutAttributesForItemsInSection:(NSInteger)section
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
        [attributes addObject:[self layoutAttributesForCellAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    attributes.frame = [self frameForItemAtIndexPath:indexPath];

    return attributes;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = [self cellSize];
    NSInteger rowOfItem = indexPath.item / self.numberOfItemsPerLine;
    NSInteger locationInRowOfItem = indexPath.item % self.numberOfItemsPerLine;

    CGRect frame = CGRectZero;

    CGFloat sectionStart = [self startOfSection:indexPath.section];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        frame.origin.x = self.sectionInset.left + (locationInRowOfItem * cellSize.width) + (self.interitemSpacing * locationInRowOfItem);
        frame.origin.y = sectionStart + self.sectionInset.top + (rowOfItem * cellSize.height) + (self.lineSpacing * rowOfItem);
    } else {
        frame.origin.x = sectionStart + self.sectionInset.left + (rowOfItem * cellSize.width) + (self.lineSpacing * rowOfItem);
        frame.origin.y = self.sectionInset.top + (locationInRowOfItem * cellSize.height) + (self.interitemSpacing * locationInRowOfItem);
    }
    frame.size = cellSize;

    return frame;
}

- (CGFloat)startOfSection:(NSInteger)section
{
    CGFloat startOfSection = 0;
    CGSize cellSize = [self cellSize];
    for (NSInteger index = 0; index < section; index++) {
        startOfSection += [self contentLengthForSection:index withCellSize:cellSize];
    }
    return startOfSection;
}

- (CGSize)cellSize
{
    CGFloat usableSpace = [self usableSpace];
    CGFloat cellLength = usableSpace / self.numberOfItemsPerLine;

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(cellLength,
                          cellLength * (1.0 / self.aspectRatio));
    } else {
        return CGSizeMake(cellLength * self.aspectRatio,
                          cellLength);
    }
}

- (CGFloat)usableSpace
{
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return (self.collectionViewContentSize.width
                - self.sectionInset.left
                - self.sectionInset.right
                - ((self.numberOfItemsPerLine - 1) * self.interitemSpacing));
    } else {
        return (self.collectionViewContentSize.height
                - self.sectionInset.top
                - self.sectionInset.bottom
                - ((self.numberOfItemsPerLine - 1) * self.interitemSpacing));
    }
}

- (void)setNumberOfItemsPerLine:(NSInteger)numberOfItemsPerLine
{
    if (_numberOfItemsPerLine != numberOfItemsPerLine) {
        _numberOfItemsPerLine = numberOfItemsPerLine;

        [self invalidateLayout];
    }
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    if (_interitemSpacing != interitemSpacing) {
        _interitemSpacing = interitemSpacing;

        [self invalidateLayout];
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;

        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;

        [self invalidateLayout];
    }
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
    if (_aspectRatio != aspectRatio) {
        _aspectRatio = aspectRatio;

        [self invalidateLayout];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;

        [self invalidateLayout];
    }
}

@end
