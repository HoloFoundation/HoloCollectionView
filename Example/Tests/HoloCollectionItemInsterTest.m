//
//  HoloCollectionItemInsterTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface HoloCollectionItemInsterTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionItemInsterTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(TAG);
    }];
    
    
    // insert items in section
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").headerSize(CGSizeMake(100, 100)).makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).tag(@"0").model(@"0").size(CGSizeMake(0, 0));
            make.item(UICollectionViewCell.class).tag(@"1").model(@"1").size(CGSizeMake(1, 1));
        });
        
        make.section(@"section-1").headerSize(CGSizeMake(100, 100)).makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).tag(@"0").model(@"0").size(CGSizeMake(0, 0));
            make.item(UICollectionViewCell.class).tag(@"1").model(@"1").size(CGSizeMake(1, 1));
        });
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


#pragma mark - insert items

- (void)testInsertItems {
    [self.collectionView holo_insertItemsAtIndex:0 block:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(@"0").size(CGSizeMake(0, 0));
        make.item(UICollectionViewCell.class).tag(@"1").size(CGSizeMake(1, 1));
    }];
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[0];
    
    XCTAssertEqual(section.items.count, 3);
    
    
    HoloCollectionItem *item0 = section.items[0];
    HoloCollectionItem *item1 = section.items[1];
    HoloCollectionItem *item2 = section.items[2];
    
    XCTAssertEqual(item0.tag, @"0");
    XCTAssertEqual(item1.tag, @"1");
    XCTAssertEqual(item2.tag, TAG);
    
    XCTAssertEqual(item0.size.width, 0);
    XCTAssertEqual(item0.size.height, 0);
    XCTAssertEqual(item1.size.width, 1);
    XCTAssertEqual(item1.size.height, 1);
    XCTAssertEqual(item2.size.width, CGFLOAT_MIN);
    XCTAssertEqual(item2.size.height, CGFLOAT_MIN);

    [self.collectionView holo_insertItemsAtIndex:3 block:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(@"3").size(CGSizeMake(3, 3));
        make.item(UICollectionViewCell.class).tag(@"4").size(CGSizeMake(4, 4));
    }];
    
    XCTAssertEqual(section.items.count, 5);
    
    HoloCollectionItem *item3 = section.items[3];
    HoloCollectionItem *item4 = section.items[4];
    
    XCTAssertEqual(item3.tag, @"3");
    XCTAssertEqual(item3.size.width, 3);
    XCTAssertEqual(item3.size.height, 3);

    XCTAssertEqual(item4.tag, @"4");
    XCTAssertEqual(item4.size.width, 4);
    XCTAssertEqual(item4.size.height, 4);
}


#pragma mark - insert items in section

- (void)testInsertItemsInSection {
    [self.collectionView holo_insertItemsAtIndex:2 inSection:@"section-1" block:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(@"2").model(@"2").size(CGSizeMake(2, 2));
    }];
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section0 = self.collectionView.holo_sections[0];
    HoloCollectionSection *section1 = self.collectionView.holo_sections[1];
    HoloCollectionSection *section2 = self.collectionView.holo_sections[2];
    
    XCTAssertEqual(section0.items.count, 1);
    XCTAssertEqual(section1.items.count, 3); // changed
    XCTAssertEqual(section2.items.count, 2);
    
    
    // when you insert some items to a section that doesn't already exist, will automatically create a new section.
    
    [self.collectionView holo_insertItemsAtIndex:2 inSection:@"section-1000" block:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(@"2").model(@"2").size(CGSizeMake(2, 2));
    }];
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 4);
    
    HoloCollectionSection *section3 = self.collectionView.holo_sections[3];
    XCTAssertEqual(section3.items.count, 1);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
