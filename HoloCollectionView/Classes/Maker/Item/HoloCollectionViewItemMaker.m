//
//  HoloCollectionViewItemMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2021/2/16.
//

#import "HoloCollectionViewItemMaker.h"
#import "HoloCollectionItem.h"
#import "HoloCollectionItemMaker.h"

@interface HoloCollectionViewItemMaker ()

@property (nonatomic, strong) NSMutableArray<HoloCollectionItem *> *holoItems;

@end


@implementation HoloCollectionViewItemMaker

- (HoloCollectionItemMaker * (^)(Class))item {
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
