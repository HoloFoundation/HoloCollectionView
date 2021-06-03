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
    
    // update data
    NSArray<HoloCollectionItem *> *rows = [maker install];
    
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
    
    // update data
    NSArray<NSIndexPath *> *updateIndexPaths = [maker install];
    
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
        HoloLog(@"[HoloCollectionView] No row found with these tags: `%@`.", tags);
        return;
    }
    if (autoReload) [self deleteItemsAtIndexPaths:indexPaths];
}

- (void)holo_updateItems:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block
               inSection:(NSString *)tag {
    [self holo_updateItemsInSection:tag block:block];
}

- (void)holo_updateItems:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block
               inSection:(NSString *)tag
              autoReload:(BOOL)autoReload {
    [self holo_updateItemsInSection:tag block:block autoReload:autoReload];
}

- (void)holo_remakeItems:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block
               inSection:(NSString *)tag {
    [self holo_remakeItemsInSection:tag block:block];
}

- (void)holo_remakeItems:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block
               inSection:(NSString *)tag
              autoReload:(BOOL)autoReload {
    [self holo_remakeItemsInSection:tag block:block autoReload:autoReload];
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
