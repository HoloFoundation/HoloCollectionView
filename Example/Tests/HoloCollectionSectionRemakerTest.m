//
//  HoloCollectionSectionRemakerTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface HoloCollectionSectionRemakerTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionSectionRemakerTest

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
        })
        
        .inset(UIEdgeInsetsMake(1, 1, 1, 1))
        .insetHandler(^UIEdgeInsets{
            return UIEdgeInsetsMake(2, 2, 2, 2);
        })
        
        .minimumLineSpacing(10)
        .minimumLineSpacingHandler(^CGFloat{
            return 11;
        })
        
        .minimumInteritemSpacing(20)
        .minimumInteritemSpacingHandler(^CGFloat{
            return 21;
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

#pragma mark - remakeSections

- (void)testRemakeSections {
    [self.collectionView holo_remakeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(TAG);
    }];
    HoloCollectionSection *section = self.collectionView.holo_sections.firstObject;
    
    XCTAssertEqual(section.header, UICollectionReusableView.class);
    XCTAssertEqual(section.footer, UICollectionReusableView.class);
    
    XCTAssertNil(section.headerReuseId);
    XCTAssertNil(section.footerReuseId);
    
    XCTAssertNil(section.headerModel);
    XCTAssertNil(section.footerModel);
    
    XCTAssertEqual(section.headerSize.width, CGFLOAT_MIN);
    XCTAssertEqual(section.headerSize.height, CGFLOAT_MIN);
    XCTAssertEqual(section.footerSize.width, CGFLOAT_MIN);
    XCTAssertEqual(section.footerSize.height, CGFLOAT_MIN);
    
    XCTAssertEqual(section.inset.top, CGFLOAT_MIN);
    XCTAssertEqual(section.inset.left, CGFLOAT_MIN);
    XCTAssertEqual(section.inset.bottom, CGFLOAT_MIN);
    XCTAssertEqual(section.inset.right, CGFLOAT_MIN);

    XCTAssertEqual(section.minimumLineSpacing, CGFLOAT_MIN);
    XCTAssertEqual(section.minimumInteritemSpacing, CGFLOAT_MIN);
        
    
    // multiple sections with the same tag
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").headerSize(CGSizeMake(1, 1));
    }];
    
    // section(TAG)
    // section(@"section-1")
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section1 = self.collectionView.holo_sections[1];
    HoloCollectionSection *section2 = self.collectionView.holo_sections[2];
    
    XCTAssertEqual(section1.headerSize.width, CGFLOAT_MIN);
    XCTAssertEqual(section1.headerSize.height, CGFLOAT_MIN);
    XCTAssertEqual(section2.headerSize.width, 1);
    XCTAssertEqual(section2.headerSize.height, 1);

    [self.collectionView holo_remakeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1");
        make.section(@"section-1");
    }];
    
    HoloCollectionSection *sectionNew1 = self.collectionView.holo_sections[1];
    HoloCollectionSection *sectionNew2 = self.collectionView.holo_sections[2];
    XCTAssertEqual(sectionNew1.headerSize.width, CGFLOAT_MIN);   // changed
    XCTAssertEqual(sectionNew1.headerSize.height, CGFLOAT_MIN);  // changed
    XCTAssertEqual(sectionNew2.headerSize.width, 1);             // not changed
    XCTAssertEqual(sectionNew2.headerSize.height, 1);            // not changed
}


#pragma mark - remakeSections with items

- (void)testRemakeSectionsMakeItems {
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
    
    // not found a section with the tag
    
    [self.collectionView holo_remakeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-2").makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).model(@"0").size(CGSizeMake(0, 0));
            make.item(UICollectionViewCell.class).model(@"1").size(CGSizeMake(1, 1));
            make.item(UICollectionViewCell.class).model(@"2").size(CGSizeMake(2, 2));
        });
    }];

    XCTAssertEqual(self.collectionView.holo_sections.count, 3);

    HoloCollectionSection *section1 = self.collectionView.holo_sections[1];
    HoloCollectionSection *section2 = self.collectionView.holo_sections[2];

    XCTAssertEqual(section1.items.count, 2);
    XCTAssertEqual(section2.items.count, 2);
    
    
    // found a section with the tag

    [self.collectionView holo_remakeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).model(@"0").size(CGSizeMake(0, 0));
            make.item(UICollectionViewCell.class).model(@"1").size(CGSizeMake(1, 1));
            make.item(UICollectionViewCell.class).model(@"2").size(CGSizeMake(2, 2));
        });
    }];
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section1_new = self.collectionView.holo_sections[1];
    HoloCollectionSection *section2_old = self.collectionView.holo_sections[2];

    XCTAssertEqual(section1_new.items.count, 3);
    XCTAssertEqual(section2_old.items.count, 2);
    
    HoloCollectionItem *item0 = section1_new.items[0];
    HoloCollectionItem *item1 = section1_new.items[1];

    XCTAssertEqual(item0.cell, UICollectionViewCell.class);
    XCTAssertEqual(item0.model, @"0");
    XCTAssertEqual(item0.size.width, 0);
    XCTAssertEqual(item0.size.height, 0);

    XCTAssertEqual(item1.cell, UICollectionViewCell.class);
    XCTAssertEqual(item1.model, @"1");
    XCTAssertEqual(item1.size.width, 1);
    XCTAssertEqual(item1.size.height, 1);
}

- (void)testRemakeSectionsUpdateItems {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.collectionView holo_remakeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").updateItems(^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
            make.tag(@"1").size(CGSizeMake(1000, 1000));
            make.tag(@"2").size(CGSizeMake(2000, 2000));
        });
    }];
    
    // section(TAG)
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 2);
    
    HoloCollectionSection *section1 = self.collectionView.holo_sections[1];
    
    XCTAssertEqual(section1.items.count, 0);
}

- (void)testRemakeSectionsRemakeItems {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.collectionView holo_remakeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").remakeItems(^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
            make.tag(@"1").size(CGSizeMake(1000, 1000));
            make.tag(@"2").size(CGSizeMake(2000, 2000));
        });
    }];
    
    // section(TAG)
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 2);
    
    HoloCollectionSection *section1 = self.collectionView.holo_sections[1];
    
    XCTAssertEqual(section1.items.count, 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
