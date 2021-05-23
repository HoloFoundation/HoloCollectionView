//
//  HoloCollectionItemUpdaterTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface TestCollectionViewCell : UICollectionViewCell
@end
@implementation TestCollectionViewCell
@end


@interface HoloCollectionItemUpdaterTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionItemUpdaterTest

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
        
        .shouldHighlight(YES)
        .shouldHighlightHandler(^BOOL(id  _Nullable model) {
            return YES;
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

#pragma mark - update items

- (void)testUpdateItems {
    [self.collectionView holo_updateItems:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
        make.tag(TAG)
        .item(TestCollectionViewCell.class)
        .model(@"model-new")
        .reuseId(@"reuseId-new")
        .reuseIdHandler(^NSString * _Nonnull(id  _Nullable model) {
            return @"reuseIdHandler-new";
        })
        .size(CGSizeMake(101, 101))
        .shouldHighlight(NO)
        .canMove(NO);
    }];
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[0];
    
    XCTAssertEqual(section.items.count, 1);
    
    HoloCollectionItem *item = section.items[0];
    
        
    XCTAssertEqual(item.cell, TestCollectionViewCell.class);
    XCTAssertEqual(item.model, @"model-new");
    // reuseIdHandler
    XCTAssertEqual(item.reuseId, @"reuseIdHandler-new");
    XCTAssertEqual(item.size.width, 101);
    XCTAssertEqual(item.size.height, 101);
    XCTAssertEqual(item.shouldHighlight, NO);
    XCTAssertEqual(item.canMove, NO);
    
    
    // multiple items with the same tag
    
    [self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(@"1").size(CGSizeMake(1, 1));
        make.item(UICollectionViewCell.class).tag(@"1").size(CGSizeMake(10, 10));
    }];
    
    HoloCollectionItem *item1 = section.items[1];
    HoloCollectionItem *item2 = section.items[2];

    XCTAssertEqual(item1.size.width, 1);
    XCTAssertEqual(item1.size.height, 1);
    XCTAssertEqual(item2.size.width, 10);
    XCTAssertEqual(item2.size.height, 10);

    [self.collectionView holo_updateItems:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
        make.tag(@"1").size(CGSizeMake(100, 100));
        make.tag(@"1").size(CGSizeMake(101, 101));
    }];
    
    HoloCollectionItem *itemNew1 = section.items[1];
    HoloCollectionItem *itemNew2 = section.items[2];

    XCTAssertEqual(itemNew1.size.width, 101);
    XCTAssertEqual(itemNew1.size.height, 101);
    XCTAssertEqual(itemNew2.size.width, 10);
    XCTAssertEqual(itemNew2.size.height, 10);
}

#pragma mark - update items in section

- (void)testUpdateItemsInSection {
    [self.collectionView holo_updateItemsInSection:@"section-1" block:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
        make.tag(@"0").size(CGSizeMake(1000, 1000));
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
    
    XCTAssertEqual(item0InSection1.size.width, 1000);   // changed
    XCTAssertEqual(item0InSection1.size.height, 1000);  // changed
    XCTAssertEqual(item1InSection1.size.width, 1);
    XCTAssertEqual(item1InSection1.size.height, 1);

    HoloCollectionItem *item0InSection2 = section2.items[0];
    HoloCollectionItem *item1InSection2 = section2.items[1];
    
    XCTAssertEqual(item0InSection2.size.width, 0);
    XCTAssertEqual(item0InSection2.size.height, 0);
    XCTAssertEqual(item1InSection2.size.width, 1);
    XCTAssertEqual(item1InSection2.size.height, 1);

    
    // when you update some items to a section that doesn't already exist, then ignore it.

    [self.collectionView holo_updateItemsInSection:@"section-1000" block:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
        make.tag(@"1").size(CGSizeMake(1000, 1000));
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
