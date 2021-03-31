//
//  HoloCollectionViewProxyData.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewProxyData.h"
#import "HoloCollectionItem.h"
#import "HoloCollectionSection.h"

@implementation HoloCollectionViewProxyData

- (NSIndexSet *)insertSections:(NSArray<HoloCollectionSection *> *)sections anIndex:(NSInteger)index {
    if (sections.count <= 0) return [NSIndexSet new];
    
    if (index < 0) index = 0;
    if (index > self.sections.count) index = self.sections.count;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, sections.count)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.sections];
    [array insertObjects:sections atIndexes:indexSet];
    self.sections = array;
    return indexSet;
}

- (NSIndexSet *)removeAllSection {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.sections.count)];
    self.sections = [NSArray new];
    return indexSet;
}

- (NSIndexSet *)removeSections:(NSArray<NSString *> *)tags {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.sections];
    for (HoloCollectionSection *section in self.sections) {
        if (section.tag && [tags containsObject:section.tag]) {
            [array removeObject:section];
            NSInteger index = [self.sections indexOfObject:section];
            [indexSet addIndex:index];
        }
    }
    self.sections = array;
    return [indexSet copy];
}

- (HoloCollectionSection *)sectionWithTag:(NSString *)tag {
    for (HoloCollectionSection *section in self.sections) {
        if ([section.tag isEqualToString:tag] || (!section.tag && !tag)) return section;
    }
    return nil;
}

- (NSArray<NSIndexPath *> *)removeAllItemsInSections:(NSArray<NSString *> *)tags {
    NSMutableArray *array = [NSMutableArray new];
    for (HoloCollectionSection *section in self.sections) {
        if (section.tag && [tags containsObject:section.tag]) {
            NSInteger sectionIndex = [self.sections indexOfObject:section];
            for (NSInteger index = 0; index < section.items.count; index++) {
                [array addObject:[NSIndexPath indexPathForItem:index inSection:sectionIndex]];
            }
            [section removeAllItems];
        }
    }
    return [array copy];
}

- (NSArray<NSIndexPath *> *)removeItems:(NSArray<NSString *> *)tags {
    NSMutableArray *array = [NSMutableArray new];
    for (HoloCollectionSection *section in self.sections) {
        NSMutableArray<HoloCollectionItem *> *items = [NSMutableArray new];
        for (HoloCollectionItem *item in section.items) {
            if (item.tag && [tags containsObject:item.tag]) {
                NSInteger sectionIndex = [self.sections indexOfObject:section];
                NSInteger itemIndex = [section.items indexOfObject:item];
                [array addObject:[NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex]];
                [items addObject:item];
            }
        }
        for (HoloCollectionItem *item in items) {
            [section removeItem:item];
        }
    }
    return [array copy];
}

- (NSIndexSet *)section:(HoloCollectionSection *)section insertItems:(NSArray<HoloCollectionItem *> *)items atIndex:(NSInteger)index {
    if (items.count <= 0) return [NSIndexSet new];
    
    if (index < 0) index = 0;
    if (index > section.items.count) index = section.items.count;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, items.count)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:section.items];
    [array insertObjects:items atIndexes:indexSet];
    section.items = array;
    return indexSet;
}

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
