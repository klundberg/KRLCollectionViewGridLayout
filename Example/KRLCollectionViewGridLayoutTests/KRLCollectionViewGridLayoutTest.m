//
//  KLGridLayoutTest.m
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 6/15/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KRLSimpleCollectionViewController.h"

#import "KRLCollectionViewGridLayout.h"

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

- (void)testLayoutDefaultValues
{
    assertThatInteger(layout.numberOfItemsPerLine, equalTo(@1));
    assertThatInteger(layout.scrollDirection, equalTo(@(UICollectionViewScrollDirectionVertical)));
    assertThatDouble(layout.aspectRatio, equalTo(@1));
    assertThatDouble(layout.sectionInset.top, equalTo(@0));
    assertThatDouble(layout.sectionInset.left, equalTo(@0));
    assertThatDouble(layout.sectionInset.bottom, equalTo(@0));
    assertThatDouble(layout.sectionInset.right, equalTo(@0));
    assertThatDouble(layout.interitemSpacing, equalTo(@10));
    assertThatDouble(layout.lineSpacing, equalTo(@10));
    assertThatDouble(layout.headerReferenceSize.width, equalTo(@0));
    assertThatDouble(layout.headerReferenceSize.height, equalTo(@0));
    assertThatDouble(layout.footerReferenceSize.width, equalTo(@0));
    assertThatDouble(layout.footerReferenceSize.height, equalTo(@0));
}

- (void)testLayoutContentViewSizeUsesControllerWidthIfVerticallyScrolling
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGSize contentSize = layout.collectionViewContentSize;

    assertThatDouble(contentSize.width, equalTo(@(controller.view.frame.size.width)));
}

- (void)testLayoutContentViewSizeUsesControllerHeightIfVerticallyScrolling
{
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGSize contentSize = layout.collectionViewContentSize;

    assertThatDouble(contentSize.height, equalTo(@(controller.view.frame.size.height)));
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

    assertThatDouble(contentSize.height, equalTo(@500));
    assertThatDouble(contentSize.width, equalTo(@(contentSize.height)));
}

- (void)testContentSizeForOneColumnOneRowWithHeaderAndFooter
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 1;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerReferenceSize = CGSizeMake(0, 50);
    layout.footerReferenceSize = CGSizeMake(0, 25);

    controller.items = @[@[@1]];

    [controller.view layoutIfNeeded];

    CGSize contentSize = layout.collectionViewContentSize;

    // 480 + 50 + 25 + 10*2 (line spacing) + 10*2 (section inset) = 595

    assertThatDouble(contentSize.height, equalTo(@595));
    assertThatDouble(contentSize.width, equalTo(@500));
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

    assertThatDouble(contentSize.height, equalTo(@255)); // 470 / 2 = 235 height + insets
    assertThatDouble(contentSize.width, equalTo(@500));
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
    assertThatDouble(contentSize.height, equalTo(@505)); // 470 / 2 = 235 height, * 2 + insets + line spacing
    assertThatDouble(contentSize.width, equalTo(@500));
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
    assertThatDouble(contentSize.height, equalTo(@505)); // 470 / 2 = 235 height, * 2 + insets + line spacing
    assertThatDouble(contentSize.width, equalTo(@500));
}

- (void)testContentSizeForTwoSections
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 1;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.interitemSpacing = 10;
    layout.lineSpacing = 10;

    controller.items = @[@[@1],@[@2]];

    [controller.view layoutIfNeeded];

    CGSize contentSize = layout.collectionViewContentSize;
    assertThatDouble(contentSize.height, equalTo(@1000)); // (10 + 480 + 10) * 2
    assertThatDouble(contentSize.width, equalTo(@500));
}

- (void)testContentSizeForTwoSectionsWithHeaderAndFooter
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 1;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.interitemSpacing = 10;
    layout.lineSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(0, 25);
    layout.footerReferenceSize = CGSizeMake(0, 50);

    controller.items = @[@[@1],@[@2]];

    [controller.view layoutIfNeeded];

    CGSize contentSize = layout.collectionViewContentSize;
    assertThatDouble(contentSize.height, equalTo(@1190)); // (10 + 25 + 10 + 480 + 10 + 50 + 10) * 2
    assertThatDouble(contentSize.width, equalTo(@500));
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

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@10));
    assertThatDouble(cell1.frame.size.width, equalTo(@480));
    assertThatDouble(cell1.frame.size.height, equalTo(@480));

    assertThatDouble(cell2.frame.origin.x, equalTo(@10));
    assertThatDouble(cell2.frame.origin.y, equalTo(@500));
    assertThatDouble(cell2.frame.size.width, equalTo(@480));
    assertThatDouble(cell2.frame.size.height, equalTo(@480));
}

- (void)testFramesForCellsWithTwoPerLineVertically
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

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@10));
    assertThatDouble(cell1.frame.size.width, equalTo(@235));
    assertThatDouble(cell1.frame.size.height, equalTo(@235));

    assertThatDouble(cell2.frame.origin.x, equalTo(@255));
    assertThatDouble(cell2.frame.origin.y, equalTo(@10));
    assertThatDouble(cell2.frame.size.width, equalTo(@235));
    assertThatDouble(cell2.frame.size.height, equalTo(@235));
}

- (void)testFramesForCellsWithTwoPerLineHorizontally
{
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;

    controller.items = @[@[@1,@2]];

    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@10));
    assertThatDouble(cell1.frame.size.width, equalTo(@285));
    assertThatDouble(cell1.frame.size.height, equalTo(@285));

    assertThatDouble(cell2.frame.origin.x, equalTo(@10));
    assertThatDouble(cell2.frame.origin.y, equalTo(@305));
    assertThatDouble(cell2.frame.size.width, equalTo(@285));
    assertThatDouble(cell2.frame.size.height, equalTo(@285));
}

- (void)testFramesForHeaderAndFooterVertically
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1.0;
    layout.numberOfItemsPerLine = 1;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(0, 50);
    layout.footerReferenceSize = CGSizeMake(0, 25);

    controller.items = @[@[@1]];

    [controller.view layoutIfNeeded];

    UICollectionReusableView *header = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionReusableView *footer = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:0]];

    assertThatDouble(header.frame.origin.x, equalTo(@10));
    assertThatDouble(header.frame.origin.y, equalTo(@10));
    assertThatDouble(header.frame.size.width, equalTo(@480));
    assertThatDouble(header.frame.size.height, equalTo(@50));

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@70));
    assertThatDouble(cell1.frame.size.width, equalTo(@480));
    assertThatDouble(cell1.frame.size.height, equalTo(@480));

    assertThatDouble(footer.frame.origin.x, equalTo(@10));
    assertThatDouble(footer.frame.origin.y, equalTo(@560));
    assertThatDouble(footer.frame.size.width, equalTo(@480));
    assertThatDouble(footer.frame.size.height, equalTo(@25));
}

- (void)testFramesForHeaderAndFooterHorizontally
{
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.aspectRatio = 1.0;
    layout.numberOfItemsPerLine = 1;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(50, 0);
    layout.footerReferenceSize = CGSizeMake(25, 0);

    controller.items = @[@[@1]];
    controller.view.frame = CGRectMake(0, 0, 700, 600);

    [controller.view layoutIfNeeded];

    UICollectionReusableView *header = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionReusableView *footer = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:0]];

    assertThatDouble(header.frame.origin.x, equalTo(@10));
    assertThatDouble(header.frame.origin.y, equalTo(@10));
    assertThatDouble(header.frame.size.width, equalTo(@50));
    assertThatDouble(header.frame.size.height, equalTo(@580));

    assertThatDouble(cell1.frame.origin.x, equalTo(@70));
    assertThatDouble(cell1.frame.origin.y, equalTo(@10));
    assertThatDouble(cell1.frame.size.width, equalTo(@580));
    assertThatDouble(cell1.frame.size.height, equalTo(@580));

    assertThatDouble(footer.frame.origin.x, equalTo(@660));
    assertThatDouble(footer.frame.origin.y, equalTo(@10));
    assertThatDouble(footer.frame.size.width, equalTo(@25));
    assertThatDouble(footer.frame.size.height, equalTo(@580));
}

- (void)testAspectRatioAffectsFramesProperlyInVerticalMode
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

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@10));
    assertThatDouble(cell1.frame.size.width, equalTo(@480));
    assertThatDouble(cell1.frame.size.height, equalTo(@240));

    assertThatDouble(cell2.frame.origin.x, equalTo(@10));
    assertThatDouble(cell2.frame.origin.y, equalTo(@260));
    assertThatDouble(cell2.frame.size.width, equalTo(@480));
    assertThatDouble(cell2.frame.size.height, equalTo(@240));
}

- (void)testAspectRatioAffectsFramesProperlyInHorizontalMode
{
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.aspectRatio = 2.0/1.0;
    layout.numberOfItemsPerLine = 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;

    controller.items = @[@[@1,@2]];

    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@10));
    assertThatDouble(cell1.frame.size.width, equalTo(@570));
    assertThatDouble(cell1.frame.size.height, equalTo(@285));

    assertThatDouble(cell2.frame.origin.x, equalTo(@10));
    assertThatDouble(cell2.frame.origin.y, equalTo(@305));
    assertThatDouble(cell2.frame.size.width, equalTo(@570));
    assertThatDouble(cell2.frame.size.height, equalTo(@285));
}

- (void)testFramesForMultipleSectionsAreCorrect
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 1;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;

    controller.items = @[@[@1],@[@2]];

    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@10));
    assertThatDouble(cell1.frame.size.width, equalTo(@480));
    assertThatDouble(cell1.frame.size.height, equalTo(@480));

    assertThatDouble(cell2.frame.origin.x, equalTo(@10));
    assertThatDouble(cell2.frame.origin.y, equalTo(@510));
    assertThatDouble(cell2.frame.size.width, equalTo(@480));
    assertThatDouble(cell2.frame.size.height, equalTo(@480));
}

- (void)testFramesForMultipleSectionsAreCorrectWithHeadersAndFooters
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(0, 20);
    layout.footerReferenceSize = CGSizeMake(0, 20);

    controller.items = @[@[@1],@[@2]];

    [controller.view layoutIfNeeded];

    UICollectionReusableView *header1 = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionReusableView *footer1 = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:0]];

    UICollectionReusableView *header2 = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:1]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    UICollectionReusableView *footer2 = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:1]];

    assertThatDouble(header1.frame.origin.x, equalTo(@10));
    assertThatDouble(header1.frame.origin.y, equalTo(@10));
    assertThatDouble(header1.frame.size.width, equalTo(@480));
    assertThatDouble(header1.frame.size.height, equalTo(@20));

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@40));
    assertThatDouble(cell1.frame.size.width, equalTo(@88)); // (500 - 10*2 - 10*4)/5
    assertThatDouble(cell1.frame.size.height, equalTo(@88));

    assertThatDouble(footer1.frame.origin.x, equalTo(@10));
    assertThatDouble(footer1.frame.origin.y, equalTo(@138));
    assertThatDouble(footer1.frame.size.width, equalTo(@480));
    assertThatDouble(footer1.frame.size.height, equalTo(@20));

    assertThatDouble(header2.frame.origin.x, equalTo(@10));
    assertThatDouble(header2.frame.origin.y, equalTo(@178));
    assertThatDouble(header2.frame.size.width, equalTo(@480));
    assertThatDouble(header2.frame.size.height, equalTo(@20));

    assertThatDouble(cell2.frame.origin.x, equalTo(@10));
    assertThatDouble(cell2.frame.origin.y, equalTo(@208));
    assertThatDouble(cell1.frame.size.width, equalTo(@88)); // (500 - 10*2 - 10*4)/5
    assertThatDouble(cell1.frame.size.height, equalTo(@88));

    assertThatDouble(footer2.frame.origin.x, equalTo(@10));
    assertThatDouble(footer2.frame.origin.y, equalTo(@306));
    assertThatDouble(footer2.frame.size.width, equalTo(@480));
    assertThatDouble(footer2.frame.size.height, equalTo(@20));
}

- (void)testFramesChangeWhenBoundsChange
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;

    controller.items = @[@[@1,@2]];

    [controller.view layoutIfNeeded];

    controller.view.frame = CGRectMake(0, 0, 250, 300);

    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@10));
    assertThatDouble(cell1.frame.size.width, equalTo(@110));
    assertThatDouble(cell1.frame.size.height, equalTo(@110));

    assertThatDouble(cell2.frame.origin.x, equalTo(@130));
    assertThatDouble(cell2.frame.origin.y, equalTo(@10));
    assertThatDouble(cell2.frame.size.width, equalTo(@110));
    assertThatDouble(cell2.frame.size.height, equalTo(@110));
}

- (void)testNoHeadersOrFootersMeansViewsArentAddedForThem
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.aspectRatio = 1;
    layout.numberOfItemsPerLine = 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10;
    layout.interitemSpacing = 10;

    controller.items = @[@[@1,@2]];

    [controller.view layoutIfNeeded];

    assertThat(controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader], isEmpty());
    assertThat(controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter], isEmpty());
}

@end
