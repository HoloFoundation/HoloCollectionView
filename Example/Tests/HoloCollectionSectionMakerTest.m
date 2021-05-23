//
//  HoloCollectionSectionMakerTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface HoloCollectionSectionMakerTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionSectionMakerTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(TAG)
        .header(UICollectionReusableView.class)
        .footer(UICollectionReusableView.class)
        
        .headerReuseId(@"headerReuseId")
        .headerReuseIdHandler(^NSString * _Nonnull(id  _Nullable model) {
            return @"headerReuseIdHandler";
        })
        .footerReuseId(@"footerReuseId")
        .footerReuseIdHandler(^NSString * _Nonnull(id  _Nullable model) {
            return @"footerReuseIdHandler";
        })
        
        .headerModel(@"headerModel")
        .headerModelHandler(^id _Nonnull{
            return @"headerModelHandler";
        })
        .footerModel(@"footerModel")
        .footerModelHandler(^id _Nonnull{
            return @"footerModelHandler";
        })
        
        .headerSize(CGSizeMake(10, 10))
        .headerSizeHandler(^CGSize(id  _Nullable model) {
            return CGSizeMake(11, 11);
        })
        .footerSize(CGSizeMake(20, 20))
        .footerSizeHandler(^CGSize(id  _Nullable model) {
            return CGSizeMake(21, 21);
        });
    }];
    
    
    // makeSections with items
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).tag(@"0").model(@"0").size(CGSizeMake(0, 0));
            make.item(UICollectionViewCell.class).tag(@"1").model(@"1").size(CGSizeMake(1, 1));
        });
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


#pragma mark - makeSections

- (void)testMakeSections {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 2);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[0];
    
    XCTAssertEqual(section.tag, TAG);
    
    XCTAssertEqual(section.header, UICollectionReusableView.class);
    XCTAssertEqual(section.footer, UICollectionReusableView.class);
    
    // headerReuseIdHandler
    XCTAssertEqual(section.headerReuseId, @"headerReuseIdHandler");
    // footerReuseIdHandler
    XCTAssertEqual(section.footerReuseId, @"footerReuseIdHandler");
       
    XCTAssertEqual(section.headerModel, @"headerModel");
    XCTAssertEqual(section.footerModel, @"footerModel");

    XCTAssertEqual(section.headerSize.width, 10);
    XCTAssertEqual(section.headerSize.height, 10);
    XCTAssertEqual(section.footerSize.width, 20);
    XCTAssertEqual(section.footerSize.height, 20);
}


#pragma mark - makeSections with items

- (void)testMakeSectionsMakeItems {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).model(@"0").size(CGSizeMake(0, 0));
            make.item(UICollectionViewCell.class).model(@"1").size(CGSizeMake(1, 1));
        });
    }];
    
    // section(TAG)
    // section(@"section-1")
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[2];
    
    XCTAssertEqual(section.items.count, 2);
    
    HoloCollectionItem *item0 = section.items[0];
    HoloCollectionItem *item1 = section.items[1];
    
    XCTAssertEqual(item0.cell, UICollectionViewCell.class);
    XCTAssertEqual(item0.model, @"0");
    XCTAssertEqual(item0.size.width, 0);
    XCTAssertEqual(item0.size.height, 0);

    XCTAssertEqual(item1.cell, UICollectionViewCell.class);
    XCTAssertEqual(item1.model, @"1");
    XCTAssertEqual(item1.size.width, 1);
    XCTAssertEqual(item1.size.height, 1);
}

- (void)testMakeSectionsUpdateItems {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").updateItems(^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
            make.tag(@"0").size(CGSizeMake(0, 0));
            make.tag(@"1").size(CGSizeMake(1, 1));
        });
    }];
    
    // section(TAG)
    // section(@"section-1")
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[2];
    
    XCTAssertEqual(section.items.count, 0);
}

- (void)testMakeSectionsRemakeItems {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").remakeItems(^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
            make.tag(@"0").size(CGSizeMake(0, 0));
            make.tag(@"1").size(CGSizeMake(1, 1));
        });
    }];
    
    // section(TAG)
    // section(@"section-1")
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[2];
    
    XCTAssertEqual(section.items.count, 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
