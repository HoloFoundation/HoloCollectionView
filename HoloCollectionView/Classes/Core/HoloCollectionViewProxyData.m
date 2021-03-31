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

- (NSDictionary<NSString *, Class> *)itemsMap {
    if (!_itemsMap) {
        _itemsMap = [NSDictionary new];
    }
    return _itemsMap;
}

- (NSDictionary<NSString *,Class> *)headersMap {
    if (!_headersMap) {
        _headersMap = [NSDictionary new];
    }
    return _headersMap;
}

- (NSDictionary<NSString *,Class> *)footersMap {
    if (!_footersMap) {
        _footersMap = [NSDictionary new];
    }
    return _footersMap;
}

@end
