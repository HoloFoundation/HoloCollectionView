//
//  UICollectionView+HoloCollectionView.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "UICollectionView+HoloCollectionView.h"
#import "HoloCollectionItem.h"
#import "HoloCollectionSection.h"
#import "HoloCollectionViewMaker.h"
#import "HoloCollectionViewItemMaker.h"
#import "HoloCollectionViewSectionMaker.h"
#import "HoloCollectionViewUpdateItemMaker.h"
#import "HoloCollectionViewMacro.h"
#import "HoloCollectionViewProxy.h"
#import "HoloCollectionViewProxyData.h"
#import "UICollectionView+HoloCollectionViewProxy.h"

@implementation UICollectionView (HoloCollectionView)

#pragma mark - collectionView
- (void)holo_makeCollectionView:(void (NS_NOESCAPE ^)(HoloCollectionViewMaker *))block {
    HoloCollectionViewMaker *maker = [HoloCollectionViewMaker new];
    if (block) block(maker);
    
    HoloCollectionViewModel *collectionViewModel = [maker install];
    if (collectionViewModel.indexTitles) self.holo_proxy.proxyData.sectionIndexTitles = collectionViewModel.indexTitles;
    if (collectionViewModel.indexTitlesHandler) self.holo_proxy.proxyData.indexPathForIndexTitleHandler = collectionViewModel.indexTitlesHandler;
    
    if (collectionViewModel.delegate) self.holo_proxy.delegate = collectionViewModel.delegate;
    if (collectionViewModel.dataSource) self.holo_proxy.dataSource = collectionViewModel.dataSource;
    if (collectionViewModel.scrollDelegate) self.holo_proxy.scrollDelegate = collectionViewModel.scrollDelegate;
}

#pragma mark - section
// holo_makeSections
- (void)holo_makeSections:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block {
    [self _holo_operateSectionsWithMakerType:HoloCollectionViewSectionMakerTypeMake
                                     atIndex:NSIntegerMax
                                       block:block
                                      reload:NO];
}

- (void)holo_makeSections:(void(NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *make))block
               autoReload:(BOOL)autoReload {
    [self _holo_operateSectionsWithMakerType:HoloCollectionViewSectionMakerTypeMake
                                     atIndex:NSIntegerMax
                                       block:block
                                      reload:autoReload];
}

- (void)holo_insertSectionsAtIndex:(NSInteger)index
                             block:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block {
    [self _holo_operateSectionsWithMakerType:HoloCollectionViewSectionMakerTypeInsert
                                     atIndex:index
                                       block:block
                                      reload:NO];
}

- (void)holo_insertSectionsAtIndex:(NSInteger)index
                             block:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block
                        autoReload:(BOOL)autoReload {
    [self _holo_operateSectionsWithMakerType:HoloCollectionViewSectionMakerTypeInsert
                                     atIndex:index
                                       block:block
                                      reload:autoReload];
}

// holo_updateSections
- (void)holo_updateSections:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block {
    [self _holo_operateSectionsWithMakerType:HoloCollectionViewSectionMakerTypeUpdate
                                     atIndex:NSIntegerMax
                                       block:block
                                      reload:NO];
}

- (void)holo_updateSections:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block
                 autoReload:(BOOL)autoReload {
    [self _holo_operateSectionsWithMakerType:HoloCollectionViewSectionMakerTypeUpdate
                                     atIndex:NSIntegerMax
                                       block:block
                                      reload:autoReload];
}

// holo_remakeSections
- (void)holo_remakeSections:(void(NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *make))block {
    [self _holo_operateSectionsWithMakerType:HoloCollectionViewSectionMakerTypeRemake
                                     atIndex:NSIntegerMax
                                       block:block
                                      reload:NO];
}

- (void)holo_remakeSections:(void(NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *make))block
                 autoReload:(BOOL)autoReload {
    [self _holo_operateSectionsWithMakerType:HoloCollectionViewSectionMakerTypeRemake
                                     atIndex:NSIntegerMax
                                       block:block
                                      reload:autoReload];
}

- (void)_holo_operateSectionsWithMakerType:(HoloCollectionViewSectionMakerType)makerType
                                   atIndex:(NSInteger)atIndex
                                     block:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block
                                    reload:(BOOL)reload {
    HoloCollectionViewSectionMaker *maker = [[HoloCollectionViewSectionMaker alloc]
                                             initWithProxyDataSections:self.holo_proxy.proxyData.sections
                                             makerType:makerType];
    if (block) block(maker);
    
    // update data
    NSMutableArray *addArray = [NSMutableArray new];
    NSMutableIndexSet *updateIndexSet = [NSMutableIndexSet new];
    NSMutableArray *updateArray = [NSMutableArray arrayWithArray:self.holo_proxy.proxyData.sections];
    for (HoloCollectionViewSectionMakerModel *makerModel in [maker install]) {
        HoloCollectionSection *operateSection = makerModel.operateSection;
        if (!makerModel.operateIndex && (makerType == HoloCollectionViewSectionMakerTypeUpdate || makerType == HoloCollectionViewSectionMakerTypeRemake)) {
            HoloLog(@"[HoloCollectionView] No section found with the tag: `%@`.", operateSection.tag);
            continue;
        }
        
        if (makerModel.operateIndex) {
            // update || remake
            [updateIndexSet addIndex:makerModel.operateIndex.integerValue];
            if (makerType == HoloCollectionViewSectionMakerTypeRemake) {
                [updateArray replaceObjectAtIndex:makerModel.operateIndex.integerValue withObject:operateSection];
            }
        } else {
            // make || insert
            [addArray addObject:operateSection];
        }
    }
    self.holo_proxy.proxyData.sections = updateArray.copy;
    
    // update sections
    if (reload && updateIndexSet.count > 0) {
        [self reloadSections:updateIndexSet];
    }
    // append sections
    NSIndexSet *addIndexSet = [self _holo_insertSections:addArray anIndex:atIndex];
    if (reload && addIndexSet.count > 0) {
        [self insertSections:addIndexSet];
    }
}

// holo_removeAllSections
- (void)holo_removeAllSections {
    [self _holo_removeAllSectionsAutoReload:NO];
}

- (void)holo_removeAllSectionsAutoReload:(BOOL)autoReload {
    [self _holo_removeAllSectionsAutoReload:autoReload];
}

/* Deprecated Method, will be deleted soon. */
- (void)holo_removeAllSectionsautoReload:(BOOL)autoReload {
    [self _holo_removeAllSectionsAutoReload:autoReload];
}

- (void)_holo_removeAllSectionsAutoReload:(BOOL)autoReload {
    NSIndexSet *indexSet = [self _holo_removeAllSection];
    if (autoReload && indexSet.count > 0) {
        [self deleteSections:indexSet];
    }
}

// holo_removeSections
- (void)holo_removeSections:(NSArray<NSString *> *)tags {
    [self _holo_removeSections:tags autoReload:NO];
}

- (void)holo_removeSections:(NSArray<NSString *> *)tags autoReload:(BOOL)autoReload {
    [self _holo_removeSections:tags autoReload:autoReload];
}

- (void)_holo_removeSections:(NSArray<NSString *> *)tags autoReload:(BOOL)autoReload {
    NSIndexSet *indexSet = [self _holo_removeSections:tags];
    if (indexSet.count <= 0) {
        HoloLog(@"[HoloCollectionView] No section found with these tags: `%@`.", tags);
        return;
    }
    if (autoReload) [self deleteSections:indexSet];
}

#pragma mark - item
// holo_makeItems
- (void)holo_makeItems:(void (NS_NOESCAPE ^)(HoloCollectionViewItemMaker *))block {
    [self _holo_insertItemsAtIndex:NSIntegerMax
                         inSection:nil
                             block:block
                        autoReload:NO];
}

- (void)holo_makeItems:(void(NS_NOESCAPE ^)(HoloCollectionViewItemMaker *make))block
            autoReload:(BOOL)autoReload {
    [self _holo_insertItemsAtIndex:NSIntegerMax
                         inSection:nil
                             block:block
                        autoReload:autoReload];
}

// holo_makeItemsInSection
- (void)holo_makeItemsInSection:(NSString *)tag
                          block:(void (NS_NOESCAPE ^)(HoloCollectionViewItemMaker *))block {
    [self _holo_insertItemsAtIndex:NSIntegerMax
                         inSection:tag
                             block:block
                        autoReload:NO];
}

- (void)holo_makeItemsInSection:(NSString *)tag
                          block:(void (NS_NOESCAPE ^)(HoloCollectionViewItemMaker *))block
                     autoReload:(BOOL)autoReload {
    [self _holo_insertItemsAtIndex:NSIntegerMax
                         inSection:tag
                             block:block
                        autoReload:autoReload];
}

- (void)holo_insertItemsAtIndex:(NSInteger)index
                          block:(void(NS_NOESCAPE ^)(HoloCollectionViewItemMaker *make))block {
    [self _holo_insertItemsAtIndex:index
                         inSection:nil
                             block:block
                        autoReload:NO];
}

- (void)holo_insertItemsAtIndex:(NSInteger)index
                          block:(void(NS_NOESCAPE ^)(HoloCollectionViewItemMaker *make))block
                     autoReload:(BOOL)autoReload {
    [self _holo_insertItemsAtIndex:index
                         inSection:nil
                             block:block
                        autoReload:autoReload];
}

- (void)holo_insertItemsAtIndex:(NSInteger)index
                      inSection:(NSString *)tag
                          block:(void(NS_NOESCAPE ^)(HoloCollectionViewItemMaker *make))block {
    [self _holo_insertItemsAtIndex:index
                         inSection:tag
                             block:block
                        autoReload:NO];
}

- (void)holo_insertItemsAtIndex:(NSInteger)index
                      inSection:(NSString *)tag
                          block:(void(NS_NOESCAPE ^)(HoloCollectionViewItemMaker *make))block
                     autoReload:(BOOL)autoReload {
    [self _holo_insertItemsAtIndex:index
                         inSection:tag
                             block:block
                        autoReload:autoReload];
}

- (void)_holo_insertItemsAtIndex:(NSInteger)index
                       inSection:(NSString *)tag
                           block:(void (NS_NOESCAPE ^)(HoloCollectionViewItemMaker *))block
                      autoReload:(BOOL)autoReload {
    HoloCollectionViewItemMaker *maker = [HoloCollectionViewItemMaker new];
    if (block) block(maker);
    
    // update data
    NSArray<HoloCollectionItem *> *items = [maker install];
    
    // append items and refresh view
    BOOL isNewOne = NO;
    HoloCollectionSection *targetSection = [self _holo_sectionWithTag:tag];
    if (!targetSection) {
        targetSection = [HoloCollectionSection new];
        targetSection.tag = tag;
        [self _holo_insertSections:@[targetSection] anIndex:NSIntegerMax];
        isNewOne = YES;
    }
    NSIndexSet *indexSet = [self _holo_section:targetSection insertItems:items atIndex:index];
    NSInteger sectionIndex = [self.holo_proxy.proxyData.sections indexOfObject:targetSection];
    if (autoReload && isNewOne) {
        [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
    } else if (autoReload) {
        NSMutableArray *indePathArray = [NSMutableArray new];
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [indePathArray addObject:[NSIndexPath indexPathForItem:idx inSection:sectionIndex]];
        }];
        [self insertItemsAtIndexPaths:[indePathArray copy]];
    }
}

// holo_updateItems
- (void)holo_updateItems:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *))block {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeUpdate
                                   block:block
                           targetSection:NO
                              sectionTag:nil
                                  reload:NO];
}

- (void)holo_updateItems:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *))block
              autoReload:(BOOL)autoReload {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeUpdate
                                   block:block
                           targetSection:NO
                              sectionTag:nil
                                  reload:autoReload];
}

- (void)holo_updateItemsInSection:(NSString *)tag
                            block:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeUpdate
                                   block:block
                           targetSection:YES
                              sectionTag:tag
                                  reload:NO];
}

- (void)holo_updateItemsInSection:(NSString *)tag
                            block:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block
                       autoReload:(BOOL)autoReload {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeUpdate
                                   block:block
                           targetSection:YES
                              sectionTag:tag
                                  reload:autoReload];
}

// holo_remakeItems
- (void)holo_remakeItems:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeRemake
                                   block:block
                           targetSection:NO
                              sectionTag:nil
                                  reload:NO];
}

- (void)holo_remakeItems:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block
              autoReload:(BOOL)autoReload {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeRemake
                                   block:block
                           targetSection:NO
                              sectionTag:nil
                                  reload:autoReload];
}

- (void)holo_remakeItemsInSection:(NSString *)tag
                            block:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeRemake
                                   block:block
                           targetSection:YES
                              sectionTag:tag
                                  reload:NO];
}

- (void)holo_remakeItemsInSection:(NSString *)tag
                            block:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block
                       autoReload:(BOOL)autoReload {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeRemake
                                   block:block
                           targetSection:YES
                              sectionTag:tag
                                  reload:autoReload];
}

- (void)_holo_updateItemsWithMakerType:(HoloCollectionViewUpdateItemMakerType)makerType
                                 block:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *))block
                         targetSection:(BOOL)targetSection
                            sectionTag:(NSString * _Nullable)sectionTag
                                reload:(BOOL)reload {
    HoloCollectionViewUpdateItemMaker *maker = [[HoloCollectionViewUpdateItemMaker alloc] initWithProxyDataSections:self.holo_proxy.proxyData.sections
                                                                                                          makerType:makerType
                                                                                                      targetSection:targetSection
                                                                                                         sectionTag:sectionTag];
    
    if (block) block(maker);
    
    // update data
    NSArray<NSIndexPath *> *updateIndexPaths = [maker install];
    
    // refresh items
    if (reload && updateIndexPaths.count > 0) {
        [self reloadItemsAtIndexPaths:updateIndexPaths];
    }
}

// holo_removeAllItemsInSections
- (void)holo_removeAllItemsInSections:(NSArray<NSString *> *)tags {
    [self _holo_removeAllItemsInSections:tags
                              autoReload:NO];
}

- (void)holo_removeAllItemsInSections:(NSArray<NSString *> *)tags
                           autoReload:(BOOL)autoReload {
    [self _holo_removeAllItemsInSections:tags
                              autoReload:autoReload];
}

- (void)_holo_removeAllItemsInSections:(NSArray<NSString *> *)tags
                            autoReload:(BOOL)autoReload {
    NSArray *indexPaths = [self _holo_removeAllItemsInSections:tags];
    if (autoReload && indexPaths.count > 0) {
        [self deleteItemsAtIndexPaths:indexPaths];
    }
}

// holo_removeItem
- (void)holo_removeItems:(NSArray<NSString *> *)tags {
    [self _holo_removeItem:tags
                autoReload:NO];
}

- (void)holo_removeItems:(NSArray<NSString *> *)tags
              autoReload:(BOOL)autoReload {
    [self _holo_removeItem:tags
                autoReload:autoReload];
}

- (void)_holo_removeItem:(NSArray<NSString *> *)tags
              autoReload:(BOOL)autoReload {
    NSArray *indexPaths = [self _holo_removeItems:tags];
    if (indexPaths.count <= 0) {
        HoloLog(@"[HoloCollectionView] No item found with these tags: `%@`.", tags);
        return;
    }
    if (autoReload) [self deleteItemsAtIndexPaths:indexPaths];
}


#pragma mark - data

- (NSIndexSet *)_holo_insertSections:(NSArray<HoloCollectionSection *> *)sections anIndex:(NSInteger)index {
    if (sections.count <= 0) return [NSIndexSet new];
    
    if (index < 0) index = 0;
    if (index > self.holo_proxy.proxyData.sections.count) index = self.holo_proxy.proxyData.sections.count;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, sections.count)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.holo_proxy.proxyData.sections];
    [array insertObjects:sections atIndexes:indexSet];
    self.holo_proxy.proxyData.sections = array;
    return indexSet;
}

- (NSIndexSet *)_holo_removeAllSection {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.holo_proxy.proxyData.sections.count)];
    self.holo_proxy.proxyData.sections = [NSArray new];
    return indexSet;
}

- (NSIndexSet *)_holo_removeSections:(NSArray<NSString *> *)tags {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.holo_proxy.proxyData.sections];
    for (HoloCollectionSection *section in self.holo_proxy.proxyData.sections) {
        if (section.tag && [tags containsObject:section.tag]) {
            [array removeObject:section];
            NSInteger index = [self.holo_proxy.proxyData.sections indexOfObject:section];
            [indexSet addIndex:index];
        }
    }
    self.holo_proxy.proxyData.sections = array;
    return [indexSet copy];
}

- (HoloCollectionSection *)_holo_sectionWithTag:(NSString *)tag {
    for (HoloCollectionSection *section in self.holo_proxy.proxyData.sections) {
        if ([section.tag isEqualToString:tag] || (!section.tag && !tag)) return section;
    }
    return nil;
}

- (NSArray<NSIndexPath *> *)_holo_removeAllItemsInSections:(NSArray<NSString *> *)tags {
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

- (NSArray<NSIndexPath *> *)_holo_removeItems:(NSArray<NSString *> *)tags {
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

- (NSIndexSet *)_holo_section:(HoloCollectionSection *)section insertItems:(NSArray<HoloCollectionItem *> *)items atIndex:(NSInteger)index {
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
