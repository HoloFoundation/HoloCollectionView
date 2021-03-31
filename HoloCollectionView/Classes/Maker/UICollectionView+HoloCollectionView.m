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
    
    // update data and map
    NSMutableDictionary *headersMap = self.holo_proxy.proxyData.headersMap.mutableCopy;
    NSMutableDictionary *footersMap = self.holo_proxy.proxyData.footersMap.mutableCopy;
    NSMutableArray *updateArray = [NSMutableArray arrayWithArray:self.holo_proxy.proxyData.sections];
    NSMutableArray *addArray = [NSMutableArray new];
    NSMutableIndexSet *updateIndexSet = [NSMutableIndexSet new];
    for (HoloCollectionViewSectionMakerModel *makerModel in [maker install]) {
        HoloCollectionSection *operateSection = makerModel.operateSection;
        if (!makerModel.operateIndex && (makerType == HoloCollectionViewSectionMakerTypeUpdate || makerType == HoloCollectionViewSectionMakerTypeRemake)) {
            HoloLog(@"[HoloCollectionView] No found a section with the tag: %@.", operateSection.tag);
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
        
        if (operateSection.headerReuseIdHandler) operateSection.headerReuseId = operateSection.headerReuseIdHandler(operateSection.headerModel);
        if (!operateSection.headerReuseId) operateSection.headerReuseId = NSStringFromClass(operateSection.header);
        if (operateSection.footerReuseIdHandler) operateSection.footerReuseId = operateSection.footerReuseIdHandler(operateSection.footerModel);
        if (!operateSection.footerReuseId) operateSection.footerReuseId = NSStringFromClass(operateSection.footer);
        
        if (operateSection.header) [self _registerHeaderFooter:operateSection.header
                                    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                          withHeaderFootersMap:headersMap
                                                       reuseId:operateSection.headerReuseId];
        if (operateSection.footer) [self _registerHeaderFooter:operateSection.footer
                                    forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                          withHeaderFootersMap:footersMap
                                                       reuseId:operateSection.footerReuseId];
        
        // update map
        NSMutableDictionary *itemsMap = self.holo_proxy.proxyData.itemsMap.mutableCopy;
        for (HoloCollectionItem *item in operateSection.items) {
            Class cls = item.cell;
            NSString *key = NSStringFromClass(cls);
            if (itemsMap[key]) continue;
            
            if (!cls) {
                NSAssert(NO, @"[HoloCollectionView] No found a cell class with the name: %@.", key);
            }
            if (![cls.new isKindOfClass:UICollectionViewCell.class]) {
                NSAssert(NO, @"[HoloCollectionView] The class: %@ is neither UICollectionViewCell nor its subclasses.", key);
            }
            itemsMap[key] = cls;
            
            if (item.reuseIdHandler) item.reuseId = item.reuseIdHandler(item.model);
            if (!item.reuseId) item.reuseId = key;
            [self registerClass:cls forCellWithReuseIdentifier:item.reuseId];
        }
        self.holo_proxy.proxyData.itemsMap = itemsMap;
    }
    self.holo_proxy.proxyData.headersMap = headersMap;
    self.holo_proxy.proxyData.footersMap = footersMap;
    self.holo_proxy.proxyData.sections = updateArray.copy;
    
    // update sections
    if (reload && updateIndexSet.count > 0) {
        [self reloadSections:updateIndexSet];
    }
    // append sections
    NSIndexSet *addIndexSet = [self.holo_proxy.proxyData insertSections:addArray anIndex:atIndex];
    if (reload && addIndexSet.count > 0) {
        [self insertSections:addIndexSet];
    }
}

// _registerHeaderFooter
- (void)_registerHeaderFooter:(Class)headerFooter
   forSupplementaryViewOfKind:(NSString *)elementKind
         withHeaderFootersMap:(NSMutableDictionary *)headerFootersMap
                      reuseId:(NSString *)reuseId {
    Class cls = headerFooter;
    NSString *key = NSStringFromClass(cls);
    if (headerFootersMap[key]) return;
    
    if (!cls) {
        NSAssert(NO, @"[HoloCollectionView] No found a headerFooter class with the name: %@.", key);
    }
    if (![cls.new isKindOfClass:UICollectionReusableView.class]) {
        NSAssert(NO, @"[HoloCollectionView] The class: %@ is neither UICollectionReusableView nor its subclasses.", key);
    }
    headerFootersMap[key] = cls;
    [self registerClass:cls forSupplementaryViewOfKind:elementKind withReuseIdentifier:reuseId ?: key];
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
    NSIndexSet *indexSet = [self.holo_proxy.proxyData removeAllSection];
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
    NSIndexSet *indexSet = [self.holo_proxy.proxyData removeSections:tags];
    if (indexSet.count <= 0) {
        HoloLog(@"[HoloCollectionView] No found any section with these tags: %@.", tags);
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
    
    // update cell-cls map and register class
    NSMutableDictionary *itemsMap = self.holo_proxy.proxyData.itemsMap.mutableCopy;
    NSMutableArray *items = [NSMutableArray new];
    for (HoloCollectionItem *item in [maker install]) {
        Class cls = item.cell;
        NSString *key = NSStringFromClass(cls);
        if (itemsMap[key]) {
            [items addObject:item];
            continue;
        }
        
        if (!cls) {
            NSAssert(NO, @"[HoloCollectionView] No found a cell class with the name: %@.", key);
        }
        if (![cls.new isKindOfClass:UICollectionViewCell.class]) {
            NSAssert(NO, @"[HoloCollectionView] The class: %@ is neither UICollectionViewCell nor its subclasses.", key);
        }
        itemsMap[key] = cls;
        
        if (item.reuseIdHandler) item.reuseId = item.reuseIdHandler(item.model);
        if (!item.reuseId) item.reuseId = key;
        [self registerClass:cls forCellWithReuseIdentifier:item.reuseId];
        [items addObject:item];
    }
    self.holo_proxy.proxyData.itemsMap = itemsMap;
    
    // append items and refresh view
    BOOL isNewOne = NO;
    HoloCollectionSection *targetSection = [self.holo_proxy.proxyData sectionWithTag:tag];
    if (!targetSection) {
        targetSection = [HoloCollectionSection new];
        targetSection.tag = tag;
        [self.holo_proxy.proxyData insertSections:@[targetSection] anIndex:NSIntegerMax];
        isNewOne = YES;
    }
    NSIndexSet *indexSet = [self.holo_proxy.proxyData section:targetSection insertItems:items atIndex:index];
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
                                  reload:NO];
}

- (void)holo_updateItems:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *))block
              autoReload:(BOOL)autoReload {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeUpdate
                                   block:block
                                  reload:autoReload];
}

// holo_remakeItems
- (void)holo_remakeItems:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeRemake
                                   block:block
                                  reload:NO];
}

- (void)holo_remakeItems:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *make))block
              autoReload:(BOOL)autoReload {
    [self _holo_updateItemsWithMakerType:HoloCollectionViewUpdateItemMakerTypeRemake
                                   block:block
                                  reload:autoReload];
}


- (void)_holo_updateItemsWithMakerType:(HoloCollectionViewUpdateItemMakerType)makerType
                                 block:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateItemMaker *))block
                                reload:(BOOL)reload {
    HoloCollectionViewUpdateItemMaker *maker = [[HoloCollectionViewUpdateItemMaker alloc] initWithProxyDataSections:self.holo_proxy.proxyData.sections makerType:makerType];
    if (block) block(maker);
    
    // update data and map
    NSMutableDictionary *itemsMap = self.holo_proxy.proxyData.itemsMap.mutableCopy;
    NSMutableArray *updateIndexPaths = [NSMutableArray new];
    NSMutableArray *updateArray = [NSMutableArray arrayWithArray:self.holo_proxy.proxyData.sections];
    for (HoloCollectionViewUpdateItemMakerModel *makerModel in [maker install]) {
        HoloCollectionItem *operateItem = makerModel.operateItem;
        // HoloCollectionViewUpdateItemMakerTypeUpdate || HoloCollectionViewUpdateItemMakerTypeRemake
        if (!makerModel.operateIndexPath) {
            HoloLog(@"[HoloCollectionView] No found a item with the tag: %@.", operateItem.tag);
            continue;
        }
        
        // update || remake
        [updateIndexPaths addObject:makerModel.operateIndexPath];
        
        if (makerType == HoloCollectionViewUpdateItemMakerTypeRemake) {
            HoloCollectionSection *section = updateArray[makerModel.operateIndexPath.section];
            NSMutableArray *items = [NSMutableArray arrayWithArray:section.items];
            [items replaceObjectAtIndex:makerModel.operateIndexPath.item withObject:operateItem];
            section.items = items;
        }
        
        Class cls = operateItem.cell;
        NSString *key = NSStringFromClass(cls);
        if (itemsMap[key]) continue;
        
        if (!cls) {
            NSAssert(NO, @"[HoloCollectionView] No found a cell class with the name: %@.", key);
        }
        if (![cls.new isKindOfClass:UICollectionViewCell.class]) {
            NSAssert(NO, @"[HoloCollectionView] The class: %@ is neither UICollectionViewCell nor its subclasses.", key);
        }
        itemsMap[key] = cls;
        
        if (operateItem.reuseIdHandler) operateItem.reuseId = operateItem.reuseIdHandler(operateItem.model);
        if (!operateItem.reuseId) operateItem.reuseId = key;
        [self registerClass:cls forCellWithReuseIdentifier:operateItem.reuseId];
    }
    self.holo_proxy.proxyData.itemsMap = itemsMap;
    self.holo_proxy.proxyData.sections = updateArray.copy;
    
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
    NSArray *indexPaths = [self.holo_proxy.proxyData removeAllItemsInSections:tags];
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
    NSArray *indexPaths = [self.holo_proxy.proxyData removeItems:tags];
    if (indexPaths.count <= 0) {
        HoloLog(@"[HoloCollectionView] No found any item with these tags: %@.", tags);
        return;
    }
    if (autoReload) [self deleteItemsAtIndexPaths:indexPaths];
}

@end
