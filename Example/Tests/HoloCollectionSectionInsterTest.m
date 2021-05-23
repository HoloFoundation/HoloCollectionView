//
//  HoloCollectionSectionInsterTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface HoloCollectionSectionInsterTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionSectionInsterTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(TAG);
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInsertSections {
    [self.collectionView holo_insertSectionsAtIndex:0 block:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"0").headerSize(CGSizeMake(0, 0));
        make.section(@"1").headerSize(CGSizeMake(1, 1));
    }];
    
    // section(@"0")
    // section(@"1")
    // section(TAG)
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 3);
    
    HoloCollectionSection *section0 = self.collectionView.holo_sections[0];
    HoloCollectionSection *section1 = self.collectionView.holo_sections[1];
    HoloCollectionSection *section2 = self.collectionView.holo_sections[2];
    
    XCTAssertEqual(section0.tag, @"0");
    XCTAssertEqual(section1.tag, @"1");
    XCTAssertEqual(section2.tag, TAG);

    XCTAssertEqual(section0.headerSize.width, 0);
    XCTAssertEqual(section0.headerSize.height, 0);
    XCTAssertEqual(section1.headerSize.width, 1);
    XCTAssertEqual(section1.headerSize.height, 1);
    XCTAssertEqual(section2.headerSize.width, CGFLOAT_MIN);
    XCTAssertEqual(section2.headerSize.height, CGFLOAT_MIN);

    
    [self.collectionView holo_insertSectionsAtIndex:3 block:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"3").headerSize(CGSizeMake(3, 3));
        make.section(@"4").headerSize(CGSizeMake(4, 4));
    }];
    
    // section(@"0")
    // section(@"1")
    // section(TAG)
    // section(@"2")
    // section(@"3")
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 5);

    HoloCollectionSection *section3 = self.collectionView.holo_sections[3];
    HoloCollectionSection *section4 = self.collectionView.holo_sections[4];

    XCTAssertEqual(section3.tag, @"3");
    XCTAssertEqual(section3.headerSize.width, 3);
    XCTAssertEqual(section3.headerSize.height, 3);

    XCTAssertEqual(section4.tag, @"4");
    XCTAssertEqual(section4.headerSize.width, 4);
    XCTAssertEqual(section4.headerSize.height, 4);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
