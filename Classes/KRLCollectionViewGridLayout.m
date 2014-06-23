//
//  KLGridLayout.m
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 6/14/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import "KRLCollectionViewGridLayout.h"

@interface KRLCollectionViewGridLayout ()
@property (nonatomic, copy) NSArray *frames;
@property (nonatomic, assign, readwrite) CGFloat collectionViewContentLength;
@end

@implementation KRLCollectionViewGridLayout

- (void)prepareLayout
{
    CGSize cellSize = [self cellSize];
    CGFloat contentLength = 0;

    NSInteger sections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    for (NSInteger section = 0; section < sections; section++) {
        contentLength += [self contentLengthForSection:section withCellSize:cellSize];
    }

    self.collectionViewContentLength = contentLength;
}

-(CGFloat)contentLengthForSection:(NSInteger)section withCellSize:(CGSize)cellSize
{
    NSInteger itemsInSection = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
    NSInteger rowsInSection = itemsInSection / self.numberOfItemsPerLine + (itemsInSection % self.numberOfItemsPerLine > 0 ? 1 : 0);

    CGFloat contentLength = (rowsInSection - 1) * self.lineSpacing;
    contentLength += [self lengthwiseInsetLength];

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        contentLength += rowsInSection * cellSize.height;
    } else {
        contentLength += rowsInSection * cellSize.width;
    }
    return contentLength;
}

- (CGFloat)lengthwiseInsetLength
{
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return self.sectionInset.top + self.sectionInset.bottom;
    } else {
        return self.sectionInset.left + self.sectionInset.right;
    }
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return nil;
}

- (CGSize)collectionViewContentSize
{
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(self.collectionView.bounds.size.width, self.collectionViewContentLength);
    } else {
        return CGSizeMake(self.collectionViewContentLength, self.collectionView.bounds.size.height);
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [[UICollectionViewLayoutAttributes alloc] init];

    CGRect frame = attributes.frame;
    frame.size = [self cellSize];
    attributes.frame = frame;

    return attributes;
}

- (CGSize)cellSize
{
    CGFloat usableSpace = [self usableSpace];
    CGFloat cellLength = usableSpace / self.numberOfItemsPerLine;

    CGSize size;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        size.width = cellLength;
        size.height = cellLength * self.aspectRatio;
    } else {
        size.width = cellLength * (1.0 / self.aspectRatio);
        size.height = cellLength;
    }
    return size;
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

@end
