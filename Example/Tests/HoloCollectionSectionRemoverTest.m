//
//  HoloCollectionSectionRemoverTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface HoloCollectionSectionRemoverTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionSectionRemoverTest

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

- (void)testRemoveSections {
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"1");
        make.section(@"2");
        make.section(@"2");
        make.section(@"3");
    }];
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 5);
    
    [self.collectionView holo_removeSections:@[@"1", @"2"]];
    
    XCTAssertEqual(self.collectionView.holo_sections.count, 2);
    
    HoloCollectionSection *lastSection = self.collectionView.holo_sections[1];
    XCTAssertEqual(lastSection.tag, @"3");
    
    [self.collectionView holo_removeAllSections];
    XCTAssertEqual(self.collectionView.holo_sections.count, 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
