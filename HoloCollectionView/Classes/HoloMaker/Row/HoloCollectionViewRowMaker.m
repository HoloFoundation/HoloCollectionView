//
//  HoloCollectionViewRowMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewRowMaker.h"
#import "HoloCollectionRow.h"
#import "HoloCollectionRowMaker.h"

@interface HoloCollectionViewRowMaker ()

@property (nonatomic, strong) NSMutableArray<HoloCollectionRow *> *holoRows;

@end

@implementation HoloCollectionViewRowMaker

- (HoloCollectionRowMaker * (^)(Class))row {
    return ^id(Class cls) {
        HoloCollectionRowMaker *rowMaker = [HoloCollectionRowMaker new];
        HoloCollectionRow *collectionRow = [rowMaker fetchCollectionRow];
        collectionRow.cell = NSStringFromClass(cls);
        
        [self.holoRows addObject:collectionRow];
        return rowMaker;
    };
}

- (HoloCollectionRowMaker *(^)(NSString *))rowS {
    return ^id(id obj) {
        HoloCollectionRowMaker *rowMaker = [HoloCollectionRowMaker new];
        HoloCollectionRow *collectionRow = [rowMaker fetchCollectionRow];
        collectionRow.cell = obj;
        
        [self.holoRows addObject:collectionRow];
        return rowMaker;
    };
}

- (NSArray<HoloCollectionRow *> *)install {
    return self.holoRows;
}

#pragma mark - getter
- (NSMutableArray<HoloCollectionRow *> *)holoRows {
    if (!_holoRows) {
        _holoRows = [NSMutableArray new];
    }
    return _holoRows;
}

@end
