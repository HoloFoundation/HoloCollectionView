//
//  HoloCollectionItemRemoverTest.m
//  HoloCollectionView_Tests
//
//  Created by 与佳期 on 2021/5/23.
//  Copyright © 2021 gonghonglou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HoloCollectionView/HoloCollectionView.h>

@interface HoloCollectionItemRemoverTest : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionItemRemoverTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(TAG);
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testRemoveItems {
    [self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(UICollectionViewCell.class).tag(@"1");
        make.item(UICollectionViewCell.class).tag(@"2");
        make.item(UICollectionViewCell.class).tag(@"2");
        make.item(UICollectionViewCell.class).tag(@"3");
    }];
    XCTAssertEqual(self.collectionView.holo_sections.firstObject.items.count, 5);
    
    [self.collectionView holo_removeItems:@[@"1", @"2"]];
    
    XCTAssertEqual(self.collectionView.holo_sections.firstObject.items.count, 2);
    
    HoloCollectionItem *lastItem = self.collectionView.holo_sections.firstObject.items[1];
    XCTAssertEqual(lastItem.tag, @"3");

    [self.collectionView holo_removeAllSections];
    XCTAssertEqual(self.collectionView.holo_sections.firstObject.items.count, 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
