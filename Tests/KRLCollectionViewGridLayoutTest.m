//
//  KLGridLayoutTest.m
//  KLCollectionLayouts
//
//  Created by Kevin Lundberg on 6/15/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

@import XCTest;
@import KRLCollectionViewGridLayout;
@import OCHamcrest;

#import "KRLSimpleCollectionViewController.h"

#define RECTVALUE(rect) [NSValue valueWithCGRect:rect]

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
    assertThatDouble(layout.headerReferenceLength, equalTo(@0));
    assertThatDouble(layout.footerReferenceLength, equalTo(@0));
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
    layout.headerReferenceLength = 50;
    layout.footerReferenceLength = 25;

    controller.items = @[@[@1]];

    [controller.view layoutIfNeeded];

    CGSize contentSize = layout.collectionViewContentSize;

    // 480 + 50 + 25 + 10*2 (section inset) = 575

    assertThatDouble(contentSize.height, equalTo(@575));
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
    layout.headerReferenceLength = 25;
    layout.footerReferenceLength = 50;

    controller.items = @[@[@1],@[@2]];

    [controller.view layoutIfNeeded];

    CGSize contentSize = layout.collectionViewContentSize;
    assertThatDouble(contentSize.height, equalTo(@1150)); // (10 + 25 + 480 + 50 + 10) * 2
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
    layout.headerReferenceLength = 50;
    layout.footerReferenceLength = 25;

    controller.items = @[@[@1]];

    [controller.view layoutIfNeeded];

    UICollectionReusableView *header = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionReusableView *footer = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:0]];

    assertThatDouble(header.frame.origin.x, equalTo(@0));
    assertThatDouble(header.frame.origin.y, equalTo(@0));
    assertThatDouble(header.frame.size.width, equalTo(@500));
    assertThatDouble(header.frame.size.height, equalTo(@50));

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@60));
    assertThatDouble(cell1.frame.size.width, equalTo(@480));
    assertThatDouble(cell1.frame.size.height, equalTo(@480));

    assertThatDouble(footer.frame.origin.x, equalTo(@0));
    assertThatDouble(footer.frame.origin.y, equalTo(@550));
    assertThatDouble(footer.frame.size.width, equalTo(@500));
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
    layout.headerReferenceLength = 50;
    layout.footerReferenceLength = 25;

    controller.items = @[@[@1]];
    controller.view.frame = CGRectMake(0, 0, 700, 600);

    [controller.view layoutIfNeeded];

    UICollectionReusableView *header = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionReusableView *footer = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:0]];

    assertThatDouble(header.frame.origin.x, equalTo(@0));
    assertThatDouble(header.frame.origin.y, equalTo(@0));
    assertThatDouble(header.frame.size.width, equalTo(@50));
    assertThatDouble(header.frame.size.height, equalTo(@600));

    assertThatDouble(cell1.frame.origin.x, equalTo(@60));
    assertThatDouble(cell1.frame.origin.y, equalTo(@10));
    assertThatDouble(cell1.frame.size.width, equalTo(@580));
    assertThatDouble(cell1.frame.size.height, equalTo(@580));

    assertThatDouble(footer.frame.origin.x, equalTo(@650));
    assertThatDouble(footer.frame.origin.y, equalTo(@00));
    assertThatDouble(footer.frame.size.width, equalTo(@25));
    assertThatDouble(footer.frame.size.height, equalTo(@600));
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
    layout.headerReferenceLength = 20;
    layout.footerReferenceLength = 20;

    controller.items = @[@[@1],@[@2]];

    [controller.view layoutIfNeeded];

    UICollectionReusableView *header1 = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionReusableView *footer1 = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:0]];

    UICollectionReusableView *header2 = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:1]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    UICollectionReusableView *footer2 = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:1]];

    assertThatDouble(header1.frame.origin.x, equalTo(@0));
    assertThatDouble(header1.frame.origin.y, equalTo(@0));
    assertThatDouble(header1.frame.size.width, equalTo(@500));
    assertThatDouble(header1.frame.size.height, equalTo(@20));

    assertThatDouble(cell1.frame.origin.x, equalTo(@10));
    assertThatDouble(cell1.frame.origin.y, equalTo(@30));
    assertThatDouble(cell1.frame.size.width, equalTo(@88)); // (500 - 10*2 - 10*4)/5
    assertThatDouble(cell1.frame.size.height, equalTo(@88));

    assertThatDouble(footer1.frame.origin.x, equalTo(@0));
    assertThatDouble(footer1.frame.origin.y, equalTo(@128));
    assertThatDouble(footer1.frame.size.width, equalTo(@500));
    assertThatDouble(footer1.frame.size.height, equalTo(@20));

    assertThatDouble(header2.frame.origin.x, equalTo(@0));
    assertThatDouble(header2.frame.origin.y, equalTo(@148));
    assertThatDouble(header2.frame.size.width, equalTo(@500));
    assertThatDouble(header2.frame.size.height, equalTo(@20));

    assertThatDouble(cell2.frame.origin.x, equalTo(@10));
    assertThatDouble(cell2.frame.origin.y, equalTo(@178));
    assertThatDouble(cell1.frame.size.width, equalTo(@88)); // (500 - 10*2 - 10*4)/5
    assertThatDouble(cell1.frame.size.height, equalTo(@88));

    assertThatDouble(footer2.frame.origin.x, equalTo(@0));
    assertThatDouble(footer2.frame.origin.y, equalTo(@276));
    assertThatDouble(footer2.frame.size.width, equalTo(@500));
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

    controller.items = @[@[@1]];

    [controller.view layoutIfNeeded];

    assertThat(controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader], isEmpty());
    assertThat(controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter], isEmpty());
}

- (void)testIndividualSectionCanHaveSpecificInsets
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    controller.sectionInsets[@0] = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(1, 2, 3, 4)];

    controller.items = @[@[@1],
                         @[@2]];

    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];

    assertThatDouble(cell1.frame.origin.x, equalTo(@2));
    assertThatDouble(cell1.frame.origin.y, equalTo(@1));
    assertThatDouble(cell1.frame.size.width, equalTo(@494));
    assertThatDouble(cell1.frame.size.height, equalTo(@494));

    assertThatDouble(cell2.frame.origin.x, equalTo(@0));
    assertThatDouble(cell2.frame.origin.y, equalTo(@498));
    assertThatDouble(cell2.frame.size.width, equalTo(@500));
    assertThatDouble(cell2.frame.size.height, equalTo(@500));
}

- (void)testIndividualSectionCanHaveVariableLineSpacing
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    controller.lineSpacings[@0] = @5;
    controller.lineSpacings[@1] = @20;

    controller.items = @[@[@1,@2],
                         @[@3,@4]];

    CGRect frame = controller.view.frame;
    frame.size.height = 2000; // make tall enough for all cells to exist
    controller.view.frame = frame;

    [controller.view layoutIfNeeded];


    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    UICollectionViewCell *cell3 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    UICollectionViewCell *cell4 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];

    assertThat(RECTVALUE(cell1.frame), equalTo(RECTVALUE(CGRectMake(0, 0, 500, 500))));
    assertThat(RECTVALUE(cell2.frame), equalTo(RECTVALUE(CGRectMake(0, 505, 500, 500))));

    assertThat(RECTVALUE(cell3.frame), equalTo(RECTVALUE(CGRectMake(0, 1005, 500, 500))));
    assertThat(RECTVALUE(cell4.frame), equalTo(RECTVALUE(CGRectMake(0, 1525, 500, 500))));
}

- (void)testIndividualSectionCanHaveVariableInteritemSpacing
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.numberOfItemsPerLine = 2;

    controller.interitemSpacings[@0] = @0;
    controller.interitemSpacings[@1] = @20;

    controller.items = @[@[@1,@2],
                         @[@3,@4]];

    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    UICollectionViewCell *cell3 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    UICollectionViewCell *cell4 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];

    assertThat(RECTVALUE(cell1.frame), equalTo(RECTVALUE(CGRectMake(0, 0, 250, 250))));
    assertThat(RECTVALUE(cell2.frame), equalTo(RECTVALUE(CGRectMake(250, 0, 250, 250))));

    assertThat(RECTVALUE(cell3.frame), equalTo(RECTVALUE(CGRectMake(0, 250, 240, 240))));
    assertThat(RECTVALUE(cell4.frame), equalTo(RECTVALUE(CGRectMake(260, 250, 240, 240))));
}

- (void)testIndividualSectionCanHaveVariableHeaderSize
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.interitemSpacing = 0;
    layout.numberOfItemsPerLine = 5; // cells are 100x100

    controller.headerLengths[@0] = @50;
    controller.headerLengths[@1] = @20;
    controller.headerLengths[@2] = @0;

    controller.items = @[@[@1],
                         @[@2],
                         @[@3]];
    [controller.view layoutIfNeeded];

    UIView *header1 = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:0]];
    UIView *header2 = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:1]];
    UIView *header3 = controller.visibleSupplementaryViews[UICollectionElementKindSectionHeader][[NSIndexPath indexPathForItem:0 inSection:2]];


    assertThat(RECTVALUE(header1.frame), equalTo(RECTVALUE(CGRectMake(0, 0, 500, 50))));
    assertThat(RECTVALUE(header2.frame), equalTo(RECTVALUE(CGRectMake(0, 150, 500, 20))));
    assertThat(header3, is(nilValue()));
}

- (void)testIndividualSectionCanHaveVariableFooterSize
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.interitemSpacing = 0;
    layout.numberOfItemsPerLine = 5; // cells are 100x100

    controller.footerLengths[@0] = @50;
    controller.footerLengths[@1] = @0;
    controller.footerLengths[@2] = @20;

    controller.items = @[@[@1],
                         @[@2],
                         @[@3]];
    [controller.view layoutIfNeeded];

    UIView *footer1 = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:0]];
    UIView *footer2 = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:1]];
    UIView *footer3 = controller.visibleSupplementaryViews[UICollectionElementKindSectionFooter][[NSIndexPath indexPathForItem:0 inSection:2]];

    assertThat(RECTVALUE(footer1.frame), equalTo(RECTVALUE(CGRectMake(0, 100, 500, 50))));
    assertThat(footer2, is(nilValue()));
    assertThat(RECTVALUE(footer3.frame), equalTo(RECTVALUE(CGRectMake(0, 350, 500, 20))));
}

- (void)testIndividualSectionCanHaveVariableColumnCount
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.interitemSpacing = 0;

    controller.columnCounts[@0] = @1;
    controller.columnCounts[@1] = @2;

    controller.items = @[@[@1],
                         @[@2]];
    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];

    assertThat(RECTVALUE(cell1.frame), equalTo(RECTVALUE(CGRectMake(0, 0, 500, 500))));
    assertThat(RECTVALUE(cell2.frame), equalTo(RECTVALUE(CGRectMake(0, 500, 250, 250))));
}

- (void)testIndividualSectionCanHaveVariableAspectRatios
{
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.interitemSpacing = 0;

    controller.aspectRatios[@0] = @2;
    controller.aspectRatios[@1] = @(0.5);

    controller.items = @[@[@1],
                         @[@2]];
    [controller.view layoutIfNeeded];

    UICollectionViewCell *cell1 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UICollectionViewCell *cell2 = [controller.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];

    assertThat(RECTVALUE(cell1.frame), equalTo(RECTVALUE(CGRectMake(0, 0, 500, 250))));
    assertThat(RECTVALUE(cell2.frame), equalTo(RECTVALUE(CGRectMake(0, 250, 500, 1000))));
}

@end
