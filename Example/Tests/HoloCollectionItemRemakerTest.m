//
//  HoloCollectionItemRemakerTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface TestCollectionViewCell2 : UICollectionViewCell
@end
@implementation TestCollectionViewCell2
@end


@interface HoloCollectionItemRemakerTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionItemRemakerTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class)
        .model(@"model")
        .modelHandler(^id _Nonnull{
            return @"modelHandler";
        })
        
        .reuseId(@"reuseId")
        .reuseIdHandler(^NSString * _Nonnull(id  _Nullable model) {
            return @"reuseIdHandler";
        })
        
        .tag(TAG)
        
        .size(CGSizeMake(10, 10))
        .sizeHandler(^CGSize(id  _Nullable model) {
            return CGSizeMake(11, 11);
        })
        
        .shouldHighlight(NO)
        .shouldHighlightHandler(^BOOL(id  _Nullable model) {
            return NO;
        })
        
        .shouldSelect(NO)
        .shouldSelectHandler(^BOOL(id  _Nullable model) {
            return NO;
        })
        
        .shouldDeselect(NO)
        .shouldDeselectHandler(^BOOL(id  _Nullable model) {
            return NO;
        })
        
        .canMove(YES)
        .canMoveHandler(^BOOL(id  _Nullable model) {
            return YES;
        });
    }];
    
    
    // make items in section
    
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


#pragma mark - remake items

- (void)testRemakeItems {
    [self.collectionView holo_remakeItems:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
        make.tag(TAG).item(TestCollectionViewCell2.class);
    }];
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[0];
    
    XCTAssertEqual(section.items.count, 1);
    
    HoloCollectionItem *item = section.items[0];
    
    
    XCTAssertEqual(item.cell, TestCollectionViewCell2.class);
    XCTAssertNil(item.model);
    
    // by UICollectionView+HoloCollectionView
    XCTAssertEqual(item.reuseId, NSStringFromClass(TestCollectionViewCell2.class));
    XCTAssertEqual(item.size.width, CGFLOAT_MIN);
    XCTAssertEqual(item.size.height, CGFLOAT_MIN);
    XCTAssertEqual(item.shouldHighlight, YES);
    XCTAssertEqual(item.shouldSelect, YES);
    XCTAssertEqual(item.shouldDeselect, YES);
    XCTAssertEqual(item.canMove, NO);
    
    
    // multiple items with the same tag
    
    [self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(@"1");
        make.item(UICollectionViewCell.class).tag(@"1");
    }];

    HoloCollectionItem *item1 = section.items[1];
    HoloCollectionItem *item2 = section.items[2];

    XCTAssertEqual(item1.cell, UICollectionViewCell.class);
    XCTAssertEqual(item2.cell, UICollectionViewCell.class);
    
    [self.collectionView holo_remakeItems:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
        make.tag(@"1").item(TestCollectionViewCell2.class);
        make.tag(@"1").item(TestCollectionViewCell2.class);
    }];
    
    HoloCollectionItem *itemNew1 = section.items[1];
    HoloCollectionItem *itemNew2 = section.items[2];
    XCTAssertEqual(itemNew1.cell, TestCollectionViewCell2.class);
    XCTAssertEqual(itemNew2.cell, UICollectionViewCell.class);
}


#pragma mark - remake items in section

- (void)testRemakeItemsInSection {
    [self.collectionView holo_remakeItemsInSection:@"section-1" block:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
        make.tag(@"0").item(UICollectionViewCell.class);
    }];
    
    // section(TAG)
    // section(@"section-1")
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section0 = self.collectionView.holo_sections[0];
    HoloCollectionSection *section1 = self.collectionView.holo_sections[1];
    HoloCollectionSection *section2 = self.collectionView.holo_sections[2];
    
    XCTAssertEqual(section0.items.count, 1);
    XCTAssertEqual(section1.items.count, 2);
    XCTAssertEqual(section2.items.count, 2);
    
    HoloCollectionItem *item0InSection1 = section1.items[0];
    HoloCollectionItem *item1InSection1 = section1.items[1];
    
    XCTAssertEqual(item0InSection1.size.width, CGFLOAT_MIN);  // changed
    XCTAssertEqual(item0InSection1.size.height, CGFLOAT_MIN); // changed
    XCTAssertNil(item0InSection1.model);                 // changed
    XCTAssertEqual(item1InSection1.size.width, 1);
    XCTAssertEqual(item1InSection1.size.height, 1);

    HoloCollectionItem *item0InSection2 = section2.items[0];
    HoloCollectionItem *item1InSection2 = section2.items[1];
    
    XCTAssertEqual(item0InSection2.size.width, 0);
    XCTAssertEqual(item0InSection2.size.height, 0);
    XCTAssertEqual(item1InSection2.size.width, 1);
    XCTAssertEqual(item1InSection2.size.height, 1);

    
    // when you remake some items to a section that doesn't already exist, then ignore it.
    
    [self.collectionView holo_remakeItemsInSection:@"section-1000" block:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
        make.tag(@"0").item(UICollectionViewCell.class);
    }];
    
    // section(TAG)
    // section(@"section-1")
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
