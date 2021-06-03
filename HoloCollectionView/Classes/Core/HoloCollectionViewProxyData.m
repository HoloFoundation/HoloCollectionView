//
//  HoloCollectionViewProxyData.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewProxyData.h"

@implementation HoloCollectionViewProxyData

#pragma mark - getter
- (NSArray<HoloCollectionSection *> *)sections {
    if (!_sections) {
        _sections = [NSArray new];
    }
    return _sections;
}

- (NSMutableDictionary<NSString *, Class> *)itemsMap {
    if (!_itemsMap) {
        _itemsMap = [NSMutableDictionary new];
    }
    return _itemsMap;
}

- (NSMutableDictionary<NSString *,Class> *)headersMap {
    if (!_headersMap) {
        _headersMap = [NSMutableDictionary new];
    }
    return _headersMap;
}

- (NSMutableDictionary<NSString *,Class> *)footersMap {
    if (!_footersMap) {
        _footersMap = [NSMutableDictionary new];
    }
    return _footersMap;
}

@end
