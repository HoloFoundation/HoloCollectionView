//
//  HoloCollectionItemMakerTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface HoloCollectionItemMakerTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionItemMakerTest

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

#pragma mark - make items

- (void)testMakeItems {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[0];
    
    XCTAssertEqual(section.items.count, 1);
    
    HoloCollectionItem *item = section.items[0];
    
    XCTAssertEqual(item.cell, UICollectionViewCell.class);
    XCTAssertEqual(item.model, @"model");
    XCTAssertEqual(item.reuseId, @"reuseId");
    XCTAssertEqual(item.tag, TAG);
    XCTAssertEqual(item.size.width, 10);
    XCTAssertEqual(item.size.height, 10);
    XCTAssertEqual(item.shouldHighlight, NO);
    XCTAssertEqual(item.shouldSelect, NO);
    XCTAssertEqual(item.shouldDeselect, NO);
    XCTAssertEqual(item.canMove, YES);
}


#pragma mark - make items in section

- (void)testMakeItemsInSection {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.collectionView holo_makeItemsInSection:@"section-1" block:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(@"2").model(@"2").size(CGSizeMake(2, 2));
    }];
    
    // section(TAG)
    // section(@"section-1")
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section0 = self.collectionView.holo_sections[0];
    HoloCollectionSection *section1 = self.collectionView.holo_sections[1];
    HoloCollectionSection *section2 = self.collectionView.holo_sections[2];
    
    XCTAssertEqual(section0.items.count, 1);
    XCTAssertEqual(section1.items.count, 3); // changed
    XCTAssertEqual(section2.items.count, 2);
    
    
    // when you make some items to a section that doesn't already exist, will automatically create a new section.
    
    [self.collectionView holo_makeItemsInSection:@"section-1000" block:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(@"2").model(@"2").size(CGSizeMake(2, 2));
    }];
    
    // section(TAG)
    // section(@"section-1")
    // section(@"section-1")
    // section(@"section-1000")

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
