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

- (NSIndexSet *)insertSections:(NSArray<HoloCollectionSection *> *)sections anIndex:(NSInteger)index {
    if (sections.count <= 0) return nil;
    
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
        if ([section.tag isEqualToString:tag]) return section;
    }
    return nil;
}

- (NSArray<NSIndexPath *> *)removeAllRowsInSections:(NSArray<NSString *> *)tags {
    NSMutableArray *array = [NSMutableArray new];
    for (HoloCollectionSection *section in self.sections) {
        if (section.tag && [tags containsObject:section.tag]) {
            NSInteger sectionIndex = [self.sections indexOfObject:section];
            for (NSInteger index = 0; index < section.rows.count; index++) {
                [array addObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]];
            }
            [section removeAllRows];
        }
    }
    return [array copy];
}

- (NSArray<NSIndexPath *> *)removeRows:(NSArray<NSString *> *)tags {
    NSMutableArray *array = [NSMutableArray new];
    for (HoloCollectionSection *section in self.sections) {
        NSMutableArray<HoloCollectionRow *> *rows = [NSMutableArray new];
        for (HoloCollectionRow *row in section.rows) {
            if (row.tag && [tags containsObject:row.tag]) {
                NSInteger sectionIndex = [self.sections indexOfObject:section];
                NSInteger rowIndex = [section.rows indexOfObject:row];
                [array addObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
                [rows addObject:row];
            }
        }
        for (HoloCollectionRow *row in rows) {
            [section removeRow:row];
        }
    }
    return [array copy];
}

#pragma mark - getter
- (NSArray<HoloCollectionSection *> *)sections {
    if (!_sections) {
        _sections = [NSArray new];
    }
    return _sections;
}

- (NSDictionary<NSString *, Class> *)rowsMap {
    if (!_rowsMap) {
        _rowsMap = [NSDictionary new];
    }
    return _rowsMap;
}

- (NSDictionary<NSString *,Class> *)headerFootersMap {
    if (!_headerFootersMap) {
        _headerFootersMap = [NSDictionary new];
    }
    return _headerFootersMap;
}

@end
