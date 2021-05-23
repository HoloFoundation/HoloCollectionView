//
//  HoloCollectionSectionUpdaterTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface TestHeaderView : UICollectionReusableView
@end
@implementation TestHeaderView
@end

@interface TestFooterView : UICollectionReusableView
@end
@implementation TestFooterView
@end


@interface HoloCollectionSectionUpdaterTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionSectionUpdaterTest

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


#pragma mark - updateSections

- (void)testUpdateSections {
    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(TAG)
        .header(TestHeaderView.class)
        .footer(TestFooterView.class)
        
        .headerReuseId(@"headerReuseId-new")
        .footerReuseId(@"footerReuseId-new")
        
        .headerReuseIdHandler(^NSString * _Nonnull(id  _Nullable model) {
            return @"headerReuseIdHandler-new";
        })
        .footerReuseIdHandler(^NSString * _Nonnull(id  _Nullable model) {
            return @"footerReuseIdHandler-new";
        })
                
        .headerModel(@"headerModel-new")
        .footerModel(@"footerModel-new")
        
        .headerSize(CGSizeMake(101, 101))
        .footerSize(CGSizeMake(201, 201));
    }];
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 2);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[0];
    
    XCTAssertEqual(section.header, TestHeaderView.class);
    XCTAssertEqual(section.footer, TestFooterView.class);
    
    // headerReuseIdHandler
    XCTAssertEqual(section.headerReuseId, @"headerReuseIdHandler-new");
    // footerReuseIdHandler
    XCTAssertEqual(section.footerReuseId, @"footerReuseIdHandler-new");
       
    XCTAssertEqual(section.headerModel, @"headerModel-new");
    XCTAssertEqual(section.footerModel, @"footerModel-new");

    XCTAssertEqual(section.headerSize.width, 101);
    XCTAssertEqual(section.headerSize.height, 101);
    XCTAssertEqual(section.footerSize.width, 201);
    XCTAssertEqual(section.footerSize.height, 201);

    // multiple sections with the same tag
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").headerSize(CGSizeMake(10, 10));
    }];
    
    // section(@"TAG")
    // section(@"section-1")
    // section(@"section-1")

    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section1 = self.collectionView.holo_sections[1];
    HoloCollectionSection *section2 = self.collectionView.holo_sections[2];
    
    XCTAssertEqual(section1.headerSize.width, CGFLOAT_MIN);
    XCTAssertEqual(section1.headerSize.height, CGFLOAT_MIN);
    XCTAssertEqual(section2.headerSize.width, 10);
    XCTAssertEqual(section2.headerSize.height, 10);
    
    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").headerSize(CGSizeMake(100, 100));
        make.section(@"section-1").headerSize(CGSizeMake(101, 101));
    }];
    
    XCTAssertEqual(section1.headerSize.width, 101); // changed
    XCTAssertEqual(section1.headerSize.height, 101); // changed
    XCTAssertEqual(section2.headerSize.width, 10);  // not changed
    XCTAssertEqual(section2.headerSize.height, 10);  // not changed
}


#pragma mark - updateSections with items

- (void)testUpdateSectionsMakeItems {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).model(@"0").size(CGSizeMake(0, 0));
            make.item(UICollectionViewCell.class).model(@"1").size(CGSizeMake(1, 1));
        });
    }];
    
    // section(@"TAG")
    // section(@"section-1")
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    // not found a section with the tag

    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
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

    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).model(@"2").size(CGSizeMake(2, 2));
            make.item(UICollectionViewCell.class).model(@"3").size(CGSizeMake(3, 3));
        });
    }];
    
    // section(@"TAG")
    // section(@"section-1")
    // section(@"section-1")

    XCTAssertEqual(self.collectionView.holo_sections.count, 3);

    XCTAssertEqual(section1.items.count, 4);
    XCTAssertEqual(section2.items.count, 2);

    HoloCollectionItem *item0 = section1.items[0];
    HoloCollectionItem *item1 = section1.items[1];
    HoloCollectionItem *item2 = section1.items[2];
    HoloCollectionItem *item3 = section1.items[3];

    XCTAssertEqual(item0.cell, UICollectionViewCell.class);
    XCTAssertEqual(item0.model, @"0");
    XCTAssertEqual(item0.size.width, 0);
    XCTAssertEqual(item0.size.height, 0);
    
    XCTAssertEqual(item1.cell, UICollectionViewCell.class);
    XCTAssertEqual(item1.model, @"1");
    XCTAssertEqual(item1.size.width, 1);
    XCTAssertEqual(item1.size.height, 1);
    
    XCTAssertEqual(item2.cell, UICollectionViewCell.class);
    XCTAssertEqual(item2.model, @"2");
    XCTAssertEqual(item2.size.width, 2);
    XCTAssertEqual(item2.size.height, 2);
    
    XCTAssertEqual(item3.cell, UICollectionViewCell.class);
    XCTAssertEqual(item3.model, @"3");
    XCTAssertEqual(item3.size.width, 3);
    XCTAssertEqual(item3.size.height, 3);
}

- (void)testUpdateSectionsUpdateItems {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").updateItems(^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
            make.tag(@"0").size(CGSizeMake(100, 100));
        });
    }];
    
    // section(TAG)
    // section(@"section-1")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 2);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[1];
    
    XCTAssertEqual(section.items.count, 2);
    
    HoloCollectionItem *item = section.items[0];
    
    XCTAssertEqual(item.size.width, 100);
    XCTAssertEqual(item.size.height, 100);
    
    
    // multiple items with the same tag
    
    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).tag(@"0").model(@"0").size(CGSizeMake(0, 0));
            make.item(UICollectionViewCell.class).tag(@"1").model(@"1").size(CGSizeMake(1, 1));
        });
    }];
    
    XCTAssertEqual(section.items.count, 4);
    
    HoloCollectionItem *item0 = section.items[0];
    HoloCollectionItem *item1 = section.items[1];
    HoloCollectionItem *item2 = section.items[2];
    HoloCollectionItem *item3 = section.items[3];
    
    XCTAssertEqual(item0.cell, UICollectionViewCell.class);
    XCTAssertEqual(item0.tag, @"0");
    XCTAssertEqual(item0.model, @"0");
    XCTAssertEqual(item0.size.width, 100);
    XCTAssertEqual(item0.size.height, 100);
    
    XCTAssertEqual(item1.cell, UICollectionViewCell.class);
    XCTAssertEqual(item1.tag, @"1");
    XCTAssertEqual(item1.model, @"1");
    XCTAssertEqual(item1.size.width, 1);
    XCTAssertEqual(item1.size.height, 1);
    
    XCTAssertEqual(item2.cell, UICollectionViewCell.class);
    XCTAssertEqual(item2.tag, @"0");
    XCTAssertEqual(item2.model, @"0");
    XCTAssertEqual(item2.size.width, 0);
    XCTAssertEqual(item2.size.height, 0);
    
    XCTAssertEqual(item3.cell, UICollectionViewCell.class);
    XCTAssertEqual(item3.tag, @"1");
    XCTAssertEqual(item3.model, @"1");
    XCTAssertEqual(item3.size.width, 1);
    XCTAssertEqual(item3.size.height, 1);
    
    
    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").updateItems(^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
            make.tag(@"1").size(CGSizeMake(2000, 2000));
        });
    }];
    
    XCTAssertEqual(item0.size.width, 100);
    XCTAssertEqual(item0.size.height, 100);
    XCTAssertEqual(item1.size.width, 2000); // changed
    XCTAssertEqual(item1.size.height, 2000); // changed
    XCTAssertEqual(item2.size.width, 0);
    XCTAssertEqual(item2.size.height, 0);
    XCTAssertEqual(item3.size.width, 1);
    XCTAssertEqual(item3.size.height, 1);
}

- (void)testUpdateSectionsRemakeItems {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 2);
    
    HoloCollectionSection *section = self.collectionView.holo_sections[1];
    
    XCTAssertEqual(section.items.count, 2);
    
    HoloCollectionItem *originalItem = section.items[0];
    
    XCTAssertEqual(originalItem.size.width, 0);
    XCTAssertEqual(originalItem.size.height, 0);
    
    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").remakeItems(^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
            make.tag(@"0").item(UICollectionViewCell.class).size(CGSizeMake(1000, 1000));
        });
    }];
    
    XCTAssertEqual(section.items.count, 2);
    
    HoloCollectionItem *item = section.items[0];
    
    XCTAssertEqual(item.cell, UICollectionViewCell.class);
    XCTAssertEqual(item.size.width, 1000);
    XCTAssertEqual(item.size.height, 1000);
    XCTAssertNil(item.model);
    
    
    // multiple items with the same tag

    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            make.item(UICollectionViewCell.class).tag(@"0").model(@"0").size(CGSizeMake(0, 0));
            make.item(UICollectionViewCell.class).tag(@"1").model(@"1").size(CGSizeMake(1, 1));
        });
    }];

    XCTAssertEqual(section.items.count, 4);
    
    HoloCollectionItem *item1 = section.items[1];
    HoloCollectionItem *item3 = section.items[3];

    XCTAssertEqual(item1.cell, UICollectionViewCell.class);
    XCTAssertEqual(item1.tag, @"1");
    XCTAssertEqual(item1.model, @"1");
    XCTAssertEqual(item1.size.width, 1);
    XCTAssertEqual(item1.size.height, 1);
    
    XCTAssertEqual(item3.cell, UICollectionViewCell.class);
    XCTAssertEqual(item3.tag, @"1");
    XCTAssertEqual(item3.model, @"1");
    XCTAssertEqual(item3.size.width, 1);
    XCTAssertEqual(item3.size.height, 1);
    

    [self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"section-1").remakeItems(^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
            make.tag(@"1").item(UICollectionViewCell.class).size(CGSizeMake(1000, 1000));
        });
    }];

    HoloCollectionItem *item1_new = section.items[1];
    HoloCollectionItem *item3_old = section.items[3];

    XCTAssertEqual(item1_new.cell, UICollectionViewCell.class);
    XCTAssertEqual(item1_new.size.width, 1000);
    XCTAssertEqual(item1_new.size.height, 1000);
    XCTAssertNil(item1_new.model);
    
    XCTAssertEqual(item3_old.cell, UICollectionViewCell.class);
    XCTAssertEqual(item3_old.size.width, 1);
    XCTAssertEqual(item3_old.size.height, 1);
    XCTAssertEqual(item3_old.model, @"1");
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
