//  Copyright (c) 2014 Kevin Lundberg.

#import "KRLCollectionViewGridLayout.h"

@interface KRLCollectionViewGridLayout ()
/** dictionary keyed by supplementary attribute kind (header and footer), with values as dictionaries keyed by indexpath containing the attributes. */
@property (nonatomic, strong) NSMutableDictionary *supplementaryAttributes;

/** 2d array, outer array keyed by section, inner arrays keyed by row. */
@property (nonatomic, strong) NSMutableArray *cellAttributesBySection;
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
    _headerReferenceLength = 0;
    _footerReferenceLength = 0;
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
    for (NSArray *sectionAttributes in self.cellAttributesBySection) {
        for (UICollectionViewLayoutAttributes *attributes in sectionAttributes) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [visibleAttributes addObject:attributes];
            }
        }
    }

    [self.supplementaryAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *kindKey, NSDictionary *attributesDict, BOOL *stop) {
        [attributesDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *pathKey, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [visibleAttributes addObject:attributes];
            }
        }];
    }];

    return [visibleAttributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellAttributesBySection[indexPath.section][indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return self.supplementaryAttributes[elementKind][indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

- (void)calculateContentSize
{
    CGFloat contentLength = 0;

    NSInteger sections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sections; section++) {
        contentLength += [self contentLengthForSection:section];
    }

    self.collectionViewContentLength = contentLength;
}

- (CGFloat)contentLengthForSection:(NSInteger)section
{
    NSInteger rowsInSection = [self rowsInSection:section];

    CGFloat contentLength = (rowsInSection - 1) * self.lineSpacing;
    contentLength += [self lengthwiseInsetLengthInSection:section];

    CGSize cellSize = [self cellSizeInSection:section];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        contentLength += rowsInSection * cellSize.height;
    } else {
        contentLength += rowsInSection * cellSize.width;
    }

    contentLength += self.headerReferenceLength;
    contentLength += self.footerReferenceLength;

    return contentLength;
}

- (NSInteger)rowsInSection:(NSInteger)section
{
    NSInteger itemsInSection = [self.collectionView numberOfItemsInSection:section];
    NSInteger rowsInSection = itemsInSection / self.numberOfItemsPerLine + (itemsInSection % self.numberOfItemsPerLine > 0 ? 1 : 0);
    return rowsInSection;
}

- (CGFloat)lengthwiseInsetLengthInSection:(NSInteger)section
{
    UIEdgeInsets sectionInset = [self sectionInsetForSection:section];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return sectionInset.top + sectionInset.bottom;
    } else {
        return sectionInset.left + sectionInset.right;
    }
}

- (void)calculateLayoutAttributes
{
    self.cellAttributesBySection = [NSMutableArray array];

    self.supplementaryAttributes = [NSMutableDictionary dictionary];
    self.supplementaryAttributes[UICollectionElementKindSectionHeader] = [NSMutableDictionary dictionary];
    self.supplementaryAttributes[UICollectionElementKindSectionFooter] = [NSMutableDictionary dictionary];

    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        NSIndexPath *headerFooterPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [self headerAttributesForIndexPath:headerFooterPath];
        if (headerAttributes) {
            self.supplementaryAttributes[UICollectionElementKindSectionHeader][headerFooterPath] = headerAttributes;
        }

        [self.cellAttributesBySection addObject:[self layoutAttributesForItemsInSection:section]];

        UICollectionViewLayoutAttributes *footerAttributes = [self footerAttributesForIndexPath:headerFooterPath];
        if (footerAttributes) {
            self.supplementaryAttributes[UICollectionElementKindSectionFooter][headerFooterPath] = footerAttributes;
        }
    }
}

- (UICollectionViewLayoutAttributes *)headerAttributesForIndexPath:(NSIndexPath *)path
{
    if (self.headerReferenceLength == 0) {
        return nil;
    }

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:path];

    CGRect frame = CGRectZero;

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        frame.size.width = self.collectionViewContentSize.width;
        frame.size.height = self.headerReferenceLength;
        frame.origin.x = 0;
        frame.origin.y = [self startOfSection:path.section];
    } else {
        frame.size.width = self.headerReferenceLength;
        frame.size.height = self.collectionViewContentSize.height;
        frame.origin.x = [self startOfSection:path.section];
        frame.origin.y = 0;
    }

    attributes.frame = frame;

    return attributes;
}

- (UICollectionViewLayoutAttributes *)footerAttributesForIndexPath:(NSIndexPath *)path
{
    if (self.footerReferenceLength == 0) {
        return nil;
    }

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:path];

    CGRect frame = CGRectZero;

    CGFloat sectionStart = [self startOfSection:path.section];
    CGFloat sectionLength = [self contentLengthForSection:path.section];

    CGFloat footerStart = sectionStart + sectionLength;
    if (self.footerReferenceLength > 0) {
        footerStart = footerStart - self.footerReferenceLength;
    }


    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        frame.size.width = self.collectionViewContentSize.width;
        frame.size.height = self.footerReferenceLength;
        frame.origin.x = 0;
        frame.origin.y = footerStart;
    } else {
        frame.size.width = self.footerReferenceLength;
        frame.size.height = self.collectionViewContentSize.height;
        frame.origin.x = footerStart;
        frame.origin.y = 0;
    }

    attributes.frame = frame;

    return attributes;
}

- (NSArray *)layoutAttributesForItemsInSection:(NSInteger)section
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
        [attributes addObject:[self layoutAttributesForCellAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]]];
    }
    return attributes;
}

- (UIEdgeInsets)sectionInsetForSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else {
        return self.sectionInset;
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    attributes.frame = [self frameForItemAtIndexPath:indexPath];

    return attributes;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = [self cellSizeInSection:indexPath.section];
    NSInteger rowOfItem = indexPath.item / self.numberOfItemsPerLine;
    NSInteger locationInRowOfItem = indexPath.item % self.numberOfItemsPerLine;

    CGRect frame = CGRectZero;

    CGFloat sectionStart = [self startOfSection:indexPath.section];
    if (self.headerReferenceLength > 0) {
        sectionStart += self.headerReferenceLength;
    }

    UIEdgeInsets sectionInset = [self sectionInsetForSection:indexPath.section];

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        frame.origin.x = sectionInset.left + (locationInRowOfItem * cellSize.width) + (self.interitemSpacing * locationInRowOfItem);
        frame.origin.y = sectionStart + sectionInset.top + (rowOfItem * cellSize.height) + (self.lineSpacing * rowOfItem);
    } else {
        frame.origin.x = sectionStart + sectionInset.left + (rowOfItem * cellSize.width) + (self.lineSpacing * rowOfItem);
        frame.origin.y = sectionInset.top + (locationInRowOfItem * cellSize.height) + (self.interitemSpacing * locationInRowOfItem);
    }
    frame.size = cellSize;

    return frame;
}

- (CGFloat)startOfSection:(NSInteger)section
{
    CGFloat startOfSection = 0;
    for (NSInteger currentSection = 0; currentSection < section; currentSection++) {
        startOfSection += [self contentLengthForSection:currentSection];
    }
    return startOfSection;
}

- (CGSize)cellSizeInSection:(NSInteger)section
{
    CGFloat usableSpace = [self usableSpaceInSection:section];
    CGFloat cellLength = usableSpace / self.numberOfItemsPerLine;

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(cellLength,
                          cellLength * (1.0 / self.aspectRatio));
    } else {
        return CGSizeMake(cellLength * self.aspectRatio,
                          cellLength);
    }
}

- (CGFloat)usableSpaceInSection:(NSInteger)section
{
    UIEdgeInsets sectionInset = [self sectionInsetForSection:section];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return (self.collectionViewContentSize.width
                - sectionInset.left
                - sectionInset.right
                - ((self.numberOfItemsPerLine - 1) * self.interitemSpacing));
    } else {
        return (self.collectionViewContentSize.height
                - sectionInset.top
                - sectionInset.bottom
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
