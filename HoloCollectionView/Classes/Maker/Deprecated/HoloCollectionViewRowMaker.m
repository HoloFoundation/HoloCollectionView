//
//  HoloCollectionViewRowMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewRowMaker.h"
#import "HoloCollectionItem.h"
#import "HoloCollectionItemMaker.h"

@interface HoloCollectionViewRowMaker ()

@property (nonatomic, strong) NSMutableArray<HoloCollectionItem *> *holoItems;

@end

@implementation HoloCollectionViewRowMaker

- (HoloCollectionItemMaker * (^)(Class))row {
    return ^id(Class cls) {
        HoloCollectionItemMaker *itemMaker = [HoloCollectionItemMaker new];
        HoloCollectionItem *collectionItem = [itemMaker fetchCollectionItem];
        collectionItem.cell = cls;
        
        [self.holoItems addObject:collectionItem];
        return itemMaker;
    };
}

- (NSArray<HoloCollectionItem *> *)install {
    return self.holoItems;
}

#pragma mark - getter
- (NSMutableArray<HoloCollectionItem *> *)holoItems {
    if (!_holoItems) {
        _holoItems = [NSMutableArray new];
    }
    return _holoItems;
}

@end
