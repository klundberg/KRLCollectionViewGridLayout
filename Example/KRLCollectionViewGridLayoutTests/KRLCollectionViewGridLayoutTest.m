//
//  KLGridLayoutTest.m
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 6/15/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KRLSimpleCollectionViewController.h"

#import <KRLCollectionViewGridLayout/KRLCollectionViewGridLayout.h>

#define HC_SHORTHAND 1
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND 1
#import <OCMockito/OCMockito.h>

@interface KRLCollectionViewGridLayoutTest : XCTestCase
{
    KRLCollectionViewGridLayout *layout;
    KRLSimpleCollectionViewController *controller;
}
@end

@implementation KRLCollectionViewGridLayoutTest

- (void)setUp
{
    [super setUp];
    layout = [[KRLCollectionViewGridLayout alloc] init];

    controller = [[KRLSimpleCollectionViewController alloc] initWithCollectionViewLayout:layout];
    controller.view.frame = CGRectMake(0, 0, 500, 600);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testLayoutContentViewSizeUsesControllerWidthIfVerticallyScrolling
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGSize contentSize = layout.collectionViewContentSize;

    assertThatFloat(contentSize.width, equalToFloat(controller.view.frame.size.width));
}

- (void)testLayoutContentViewSizeUsesControllerHeightIfVerticallyScrolling
{
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGSize contentSize = layout.collectionViewContentSize;

    assertThatFloat(contentSize.height, equalToFloat(controller.view.frame.size.height));
}

- (void)testContentSizeForOneColumnOneRow
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 1;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    controller.items = @[@[@1]];

    [controller.view layoutIfNeeded];

    CGSize contentSize = layout.collectionViewContentSize;

    assertThatFloat(contentSize.height, equalToFloat(500));
    assertThatFloat(contentSize.width, equalToFloat(contentSize.height));
}

- (void)testContentSizeForTwoColumnsOneRow
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.interitemSpacing = 10;

    controller.items = @[@[@1,@2]];

    [controller.view layoutIfNeeded];

    CGSize contentSize = layout.collectionViewContentSize;

    assertThatFloat(contentSize.height, equalToFloat(255)); // 470 / 2 = 235 height + insets
    assertThatFloat(contentSize.width, equalToFloat(500));
}

- (void)testContentSizeForTwoColumnsTwoRows
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.interitemSpacing = 10;
    layout.lineSpacing = 15;

    controller.items = @[@[@1,@2,@3,@4]];

    [controller.view layoutIfNeeded];

    CGSize contentSize = layout.collectionViewContentSize;
    assertThatFloat(contentSize.height, equalToFloat(505)); // 470 / 2 = 235 height, * 2 + insets + line spacing
    assertThatFloat(contentSize.width, equalToFloat(500));
}


- (void)testContentSizeForTwoColumnsTwoRowsWithIncompleteLastRow
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.interitemSpacing = 10;
    layout.lineSpacing = 15;

    controller.items = @[@[@1,@2,@3]];

    [controller.view layoutIfNeeded];

    CGSize contentSize = layout.collectionViewContentSize;
    assertThatFloat(contentSize.height, equalToFloat(505)); // 470 / 2 = 235 height, * 2 + insets + line spacing
    assertThatFloat(contentSize.width, equalToFloat(500));
}

- (void)testFramesForCellsWithOnePerLine
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 1;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;

    controller.items = @[@[@1,@2]];

    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

    assertThatFloat(cell1.frame.origin.x, equalToFloat(10));
    assertThatFloat(cell1.frame.origin.y, equalToFloat(10));
    assertThatFloat(cell1.frame.size.width, equalToFloat(480));
    assertThatFloat(cell1.frame.size.height, equalToFloat(480));

    assertThatFloat(cell2.frame.origin.x, equalToFloat(10));
    assertThatFloat(cell2.frame.origin.y, equalToFloat(500));
    assertThatFloat(cell2.frame.size.width, equalToFloat(480));
    assertThatFloat(cell2.frame.size.height, equalToFloat(480));

    assertThatFloat(layout.collectionViewContentSize.height, equalToFloat(990));
    assertThatFloat(controller.collectionView.contentSize.height, equalToFloat(990));
}

- (void)testFramesForCellsWithTwoPerLine
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;

    controller.items = @[@[@1,@2]];

    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

    assertThatFloat(cell1.frame.origin.x, equalToFloat(10));
    assertThatFloat(cell1.frame.origin.y, equalToFloat(10));
    assertThatFloat(cell1.frame.size.width, equalToFloat(235));
    assertThatFloat(cell1.frame.size.height, equalToFloat(235));

    assertThatFloat(cell2.frame.origin.x, equalToFloat(255));
    assertThatFloat(cell2.frame.origin.y, equalToFloat(10));
    assertThatFloat(cell2.frame.size.width, equalToFloat(235));
    assertThatFloat(cell2.frame.size.height, equalToFloat(235));

    assertThatFloat(layout.collectionViewContentSize.height, equalToFloat(255));
    assertThatFloat(controller.collectionView.contentSize.height, equalToFloat(255));
}

- (void)testAspectRatioAffectsFramesProperly
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 2.0/1.0;
    layout.numberOfItemsPerLine = 1;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;

    controller.items = @[@[@1,@2]];

    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

    assertThatFloat(cell1.frame.origin.x, equalToFloat(10));
    assertThatFloat(cell1.frame.origin.y, equalToFloat(10));
    assertThatFloat(cell1.frame.size.width, equalToFloat(480));
    assertThatFloat(cell1.frame.size.height, equalToFloat(240));

    assertThatFloat(cell2.frame.origin.x, equalToFloat(10));
    assertThatFloat(cell2.frame.origin.y, equalToFloat(260));
    assertThatFloat(cell2.frame.size.width, equalToFloat(480));
    assertThatFloat(cell2.frame.size.height, equalToFloat(240));

    assertThatFloat(layout.collectionViewContentSize.height, equalToFloat(510));
    assertThatFloat(controller.collectionView.contentSize.height, equalToFloat(510));
}

@end
