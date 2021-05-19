//
//  UICollectionView+HoloDeprecated.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2021/2/16.
//

#import "UICollectionView+HoloDeprecated.h"
#import "HoloCollectionItem.h"
#import "HoloCollectionSection.h"
#import "HoloCollectionViewMaker.h"
#import "HoloCollectionViewRowMaker.h"
#import "HoloCollectionViewUpdateRowMaker.h"
#import "HoloCollectionViewMacro.h"
#import "HoloCollectionViewProxy.h"
#import "HoloCollectionViewProxyData.h"
#import "UICollectionView+HoloCollectionViewProxy.h"

@implementation UICollectionView (HoloDeprecated)

#pragma mark - row
// holo_makeRows
- (void)holo_makeRows:(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *))block {
    [self _holo_insertRowsAtIndex:NSIntegerMax
                        inSection:nil
                            block:block
                       autoReload:NO];
}

- (void)holo_makeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block
           autoReload:(BOOL)autoReload {
    [self _holo_insertRowsAtIndex:NSIntegerMax
                        inSection:nil
                            block:block
                       autoReload:autoReload];
}

// holo_makeRowsInSection
- (void)holo_makeRowsInSection:(NSString *)tag
                         block:(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *))block {
    [self _holo_insertRowsAtIndex:NSIntegerMax
                        inSection:tag
                            block:block
                       autoReload:NO];
}

- (void)holo_makeRowsInSection:(NSString *)tag
                         block:(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *))block
                    autoReload:(BOOL)autoReload {
    [self _holo_insertRowsAtIndex:NSIntegerMax
                        inSection:tag
                            block:block
                       autoReload:autoReload];
}

- (void)holo_insertRowsAtIndex:(NSInteger)index
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block {
    [self _holo_insertRowsAtIndex:index
                        inSection:nil
                            block:block
                       autoReload:NO];
}

- (void)holo_insertRowsAtIndex:(NSInteger)index
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block
                    autoReload:(BOOL)autoReload {
    [self _holo_insertRowsAtIndex:index
                        inSection:nil
                            block:block
                       autoReload:autoReload];
}

- (void)holo_insertRowsAtIndex:(NSInteger)index
                     inSection:(NSString *)tag
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block {
    [self _holo_insertRowsAtIndex:index
                        inSection:tag
                            block:block
                       autoReload:NO];
}

- (void)holo_insertRowsAtIndex:(NSInteger)index
                     inSection:(NSString *)tag
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block
                    autoReload:(BOOL)autoReload {
    [self _holo_insertRowsAtIndex:index
                        inSection:tag
                            block:block
                       autoReload:autoReload];
}

- (void)_holo_insertRowsAtIndex:(NSInteger)index
                      inSection:(NSString *)tag
                          block:(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *))block
                     autoReload:(BOOL)autoReload {
    HoloCollectionViewRowMaker *maker = [HoloCollectionViewRowMaker new];
    if (block) block(maker);
    
    // update cell-cls map and register class
    NSMutableDictionary *rowsMap = self.holo_proxy.proxyData.itemsMap.mutableCopy;
    NSMutableArray *rows = [NSMutableArray new];
    for (HoloCollectionItem *row in [maker install]) {
        Class cls = row.cell;
        NSString *key = NSStringFromClass(cls);
        if (rowsMap[key]) {
            [rows addObject:row];
            continue;
        }
        
        if (!cls) {
            NSAssert(NO, @"[HoloCollectionView] No found a cell class with the name: %@.", key);
        }
        if (![cls.new isKindOfClass:UICollectionViewCell.class]) {
            NSAssert(NO, @"[HoloCollectionView] The class: %@ is neither UICollectionViewCell nor its subclasses.", key);
        }
        rowsMap[key] = cls;
        
        if (row.reuseIdHandler) row.reuseId = row.reuseIdHandler(row.model);
        if (!row.reuseId) row.reuseId = key;
        [self registerClass:cls forCellWithReuseIdentifier:row.reuseId];
        [rows addObject:row];
    }
    self.holo_proxy.proxyData.itemsMap = rowsMap;
    
    // append rows and refresh view
    BOOL isNewOne = NO;
    HoloCollectionSection *targetSection = [self _holo_deprecated_sectionWithTag:tag];
    if (!targetSection) {
        targetSection = [HoloCollectionSection new];
        targetSection.tag = tag;
        [self _holo_deprecated_insertSections:@[targetSection] anIndex:NSIntegerMax];
        isNewOne = YES;
    }
    NSIndexSet *indexSet = [self _holo_deprecated_section:targetSection insertItems:rows atIndex:index];
    NSInteger sectionIndex = [self.holo_proxy.proxyData.sections indexOfObject:targetSection];
    if (autoReload && isNewOne) {
        [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
    } else if (autoReload) {
        NSMutableArray *indePathArray = [NSMutableArray new];
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [indePathArray addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
        }];
        [self insertItemsAtIndexPaths:[indePathArray copy]];
    }
}

// holo_updateRows
- (void)holo_updateRows:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *))block {
    [self _holo_updateRowsWithMakerType:HoloCollectionViewUpdateItemMakerTypeUpdate
                                  block:block
                                 reload:NO];
}

- (void)holo_updateRows:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *))block
             autoReload:(BOOL)autoReload {
    [self _holo_updateRowsWithMakerType:HoloCollectionViewUpdateItemMakerTypeUpdate
                                  block:block
                                 reload:autoReload];
}

// holo_remakeRows
- (void)holo_remakeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block {
    [self _holo_updateRowsWithMakerType:HoloCollectionViewUpdateItemMakerTypeUpdate
                                  block:block
                                 reload:NO];
}

- (void)holo_remakeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block
             autoReload:(BOOL)autoReload {
    [self _holo_updateRowsWithMakerType:HoloCollectionViewUpdateItemMakerTypeUpdate
                                  block:block
                                 reload:autoReload];
}


- (void)_holo_updateRowsWithMakerType:(HoloCollectionViewUpdateItemMakerType)makerType
                                block:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *))block
                               reload:(BOOL)reload {
    HoloCollectionViewUpdateRowMaker *maker = [[HoloCollectionViewUpdateRowMaker alloc] initWithProxyDataSections:self.holo_proxy.proxyData.sections
                                                                                                        makerType:makerType
                                                                                                    targetSection:NO
                                                                                                       sectionTag:nil];
    
    if (block) block(maker);
    
    // update data and map
    NSMutableDictionary *rowsMap = self.holo_proxy.proxyData.itemsMap.mutableCopy;
    NSMutableArray *updateIndexPaths = [NSMutableArray new];
    for (HoloCollectionViewUpdateItemMakerModel *makerModel in [maker install]) {
        HoloCollectionItem *operateRow = makerModel.operateItem;
        // HoloCollectionViewUpdateRowMakerTypeUpdate || HoloCollectionViewUpdateRowMakerTypeRemake
        if (!makerModel.operateIndexPath) {
            // Has a log in HoloCollectionViewUpdateItemMaker already, because updateItems / remakeItems in HoloCollectionSectionMaker also need it.
            // HoloLog(@"[HoloCollectionView] No found a row with the tag: %@.", operateRow.tag);
            continue;
        }
        
        // update || remake
        [updateIndexPaths addObject:makerModel.operateIndexPath];
        
        Class cls = operateRow.cell;
        NSString *key = NSStringFromClass(cls);
        if (rowsMap[key]) continue;
        
        if (!cls) {
            NSAssert(NO, @"[HoloCollectionView] No found a cell class with the name: %@.", key);
        }
        if (![cls.new isKindOfClass:UICollectionViewCell.class]) {
            NSAssert(NO, @"[HoloCollectionView] The class: %@ is neither UICollectionViewCell nor its subclasses.", key);
        }
        rowsMap[key] = cls;
        
        if (operateRow.reuseIdHandler) operateRow.reuseId = operateRow.reuseIdHandler(operateRow.model);
        if (!operateRow.reuseId) operateRow.reuseId = key;
        [self registerClass:cls forCellWithReuseIdentifier:operateRow.reuseId];
    }
    self.holo_proxy.proxyData.itemsMap = rowsMap;
    
    // refresh rows
    if (reload && updateIndexPaths.count > 0) {
        [self reloadItemsAtIndexPaths:updateIndexPaths];
    }
}

// holo_removeAllRowsInSections
- (void)holo_removeAllRowsInSections:(NSArray<NSString *> *)tags {
    [self _holo_removeAllRowsInSections:tags
                             autoReload:NO];
}

- (void)holo_removeAllRowsInSections:(NSArray<NSString *> *)tags
                          autoReload:(BOOL)autoReload {
    [self _holo_removeAllRowsInSections:tags
                             autoReload:autoReload];
}

- (void)_holo_removeAllRowsInSections:(NSArray<NSString *> *)tags
                           autoReload:(BOOL)autoReload {
    NSArray *indexPaths = [self _holo_deprecated_removeAllItemsInSections:tags];
    if (autoReload && indexPaths.count > 0) {
        [self deleteItemsAtIndexPaths:indexPaths];
    }
}

// holo_removeRow
- (void)holo_removeRows:(NSArray<NSString *> *)tags {
    [self _holo_removeRow:tags
               autoReload:NO];
}

- (void)holo_removeRows:(NSArray<NSString *> *)tags
             autoReload:(BOOL)autoReload {
    [self _holo_removeRow:tags
               autoReload:autoReload];
}

- (void)_holo_removeRow:(NSArray<NSString *> *)tags
             autoReload:(BOOL)autoReload {
    NSArray *indexPaths = [self _holo_deprecated_removeItems:tags];
    if (indexPaths.count <= 0) {
        HoloLog(@"[HoloCollectionView] No found any row with these tags: %@.", tags);
        return;
    }
    if (autoReload) [self deleteItemsAtIndexPaths:indexPaths];
}


#pragma mark - data

- (NSIndexSet *)_holo_deprecated_insertSections:(NSArray<HoloCollectionSection *> *)sections anIndex:(NSInteger)index {
    if (sections.count <= 0) return [NSIndexSet new];
    
    if (index < 0) index = 0;
    if (index > self.holo_proxy.proxyData.sections.count) index = self.holo_proxy.proxyData.sections.count;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, sections.count)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.holo_proxy.proxyData.sections];
    [array insertObjects:sections atIndexes:indexSet];
    self.holo_proxy.proxyData.sections = array;
    return indexSet;
}

- (HoloCollectionSection *)_holo_deprecated_sectionWithTag:(NSString *)tag {
    for (HoloCollectionSection *section in self.holo_proxy.proxyData.sections) {
        if ([section.tag isEqualToString:tag] || (!section.tag && !tag)) return section;
    }
    return nil;
}

- (NSArray<NSIndexPath *> *)_holo_deprecated_removeAllItemsInSections:(NSArray<NSString *> *)tags {
    NSMutableArray *array = [NSMutableArray new];
    for (HoloCollectionSection *section in self.holo_proxy.proxyData.sections) {
        if (section.tag && [tags containsObject:section.tag]) {
            NSInteger sectionIndex = [self.holo_proxy.proxyData.sections indexOfObject:section];
            for (NSInteger index = 0; index < section.items.count; index++) {
                [array addObject:[NSIndexPath indexPathForItem:index inSection:sectionIndex]];
            }
            [section removeAllItems];
        }
    }
    return [array copy];
}

- (NSArray<NSIndexPath *> *)_holo_deprecated_removeItems:(NSArray<NSString *> *)tags {
    NSMutableArray *array = [NSMutableArray new];
    for (HoloCollectionSection *section in self.holo_proxy.proxyData.sections) {
        NSMutableArray<HoloCollectionItem *> *items = [NSMutableArray new];
        for (HoloCollectionItem *item in section.items) {
            if (item.tag && [tags containsObject:item.tag]) {
                NSInteger sectionIndex = [self.holo_proxy.proxyData.sections indexOfObject:section];
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

- (NSIndexSet *)_holo_deprecated_section:(HoloCollectionSection *)section insertItems:(NSArray<HoloCollectionItem *> *)items atIndex:(NSInteger)index {
    if (items.count <= 0) return [NSIndexSet new];
    
    if (index < 0) index = 0;
    if (index > section.items.count) index = section.items.count;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, items.count)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:section.items];
    [array insertObjects:items atIndexes:indexSet];
    section.items = array;
    return indexSet;
}

@end
