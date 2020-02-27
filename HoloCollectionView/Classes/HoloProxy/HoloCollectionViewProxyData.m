//
//  HoloCollectionViewProxyData.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewProxyData.h"
#import "HoloCollectionViewSectionMaker.h"
#import "HoloCollectionViewRowMaker.h"

@implementation HoloCollectionViewProxyData

- (NSIndexSet *)holo_insertSections:(NSArray<HoloCollectionSection *> *)sections anIndex:(NSInteger)index {
    if (sections.count <= 0) return nil;
    
    if (index < 0) index = 0;
        if (index > self.holo_sections.count) index = self.holo_sections.count;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, sections.count)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.holo_sections];
    [array insertObjects:sections atIndexes:indexSet];
    self.holo_sections = array;
    return indexSet;
}

- (NSIndexSet *)holo_removeAllSection {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.holo_sections.count)];
    self.holo_sections = [NSArray new];
    return indexSet;
}

- (NSIndexSet *)holo_removeSections:(NSArray<NSString *> *)tags {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.holo_sections];
    for (HoloCollectionSection *section in self.holo_sections) {
        if (section.tag && [tags containsObject:section.tag]) {
            [array removeObject:section];
            NSInteger index = [self.holo_sections indexOfObject:section];
            [indexSet addIndex:index];
        }
    }
    self.holo_sections = array;
    return [indexSet copy];
}

- (HoloCollectionSection *)holo_sectionWithTag:(NSString *)tag {
    for (HoloCollectionSection *section in self.holo_sections) {
        if ([section.tag isEqualToString:tag] || (!section.tag && !tag)) {
            return section;
        }
    }
    return nil;
}

- (NSArray<NSIndexPath *> *)holo_removeAllRowsInSection:(NSString *)tag {
    NSMutableArray *array = [NSMutableArray new];
    for (HoloCollectionSection *section in self.holo_sections) {
        if ([section.tag isEqualToString:tag] || (!section.tag && !tag)) {
            NSInteger sectionIndex = [self.holo_sections indexOfObject:section];
            for (NSInteger index = 0; index < section.rows.count; index++) {
                [array addObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]];
            }
            [section holo_removeAllRows];
        }
    }
    return [array copy];
}

- (NSArray<NSIndexPath *> *)holo_removeRows:(NSArray<NSString *> *)tags {
    NSMutableArray *array = [NSMutableArray new];
    for (HoloCollectionSection *section in self.holo_sections) {
        for (HoloCollectionRow *row in section.rows) {
            if (row.tag && [tags containsObject:row.tag]) {
                NSInteger sectionIndex = [self.holo_sections indexOfObject:section];
                NSInteger rowIndex = [section.rows indexOfObject:row];
                [array addObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
                [section holo_removeRow:row];
            }
        }
    }
    return [array copy];
}

#pragma mark - getter
- (NSArray<HoloCollectionSection *> *)holo_sections {
    if (!_holo_sections) {
        _holo_sections = [NSArray new];
    }
    return _holo_sections;
}

- (NSDictionary<NSString *, Class> *)holo_cellClsMap {
    if (!_holo_cellClsMap) {
        _holo_cellClsMap = [NSDictionary new];
    }
    return _holo_cellClsMap;
}

- (NSDictionary<NSString *,Class> *)holo_headerFooterMap {
    if (!_holo_headerFooterMap) {
        _holo_headerFooterMap = [NSDictionary new];
    }
    return _holo_headerFooterMap;
}

@end
