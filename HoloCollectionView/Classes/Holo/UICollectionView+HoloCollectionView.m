//
//  UICollectionView+HoloCollectionView.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "UICollectionView+HoloCollectionView.h"
#import <objc/runtime.h>
#import "UICollectionView+HoloCollectionViewProxy.h"
#import "HoloCollectionViewProxy.h"
#import "HoloCollectionViewMaker.h"
#import "HoloCollectionViewSectionMaker.h"
#import "HoloCollectionViewRowMaker.h"
#import "HoloCollectionViewUpdateRowMaker.h"
#import "HoloCollectionViewProxyData.h"
#import "HoloCollectionViewMacro.h"

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
    
    // rowsMap
    NSMutableDictionary *rowsMap = self.holo_proxy.proxyData.rowsMap.mutableCopy;
    [collectionViewModel.rowsMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        rowsMap[key] = obj;
        [self registerClass:obj forCellWithReuseIdentifier:key];
        
        if (![obj.new isKindOfClass:UICollectionViewCell.class]) {
            NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] The class: %@ is neither UICollectionViewCell nor its subclasses.", NSStringFromClass(obj)];
            NSAssert(NO, error);
        }
    }];
    self.holo_proxy.proxyData.rowsMap = rowsMap;
    // headersMap
    NSMutableDictionary *headersMap = self.holo_proxy.proxyData.headersMap.mutableCopy;
    [collectionViewModel.headersMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        headersMap[key] = obj;
        [self registerClass:obj forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:key];

        if (![obj.new isKindOfClass:UICollectionReusableView.class]) {
            NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] The class: %@ is neither UICollectionReusableView nor its subclasses.", NSStringFromClass(obj)];
            NSAssert(NO, error);
        }
    }];
    self.holo_proxy.proxyData.headersMap = headersMap;
    // footersMap
    NSMutableDictionary *footersMap = self.holo_proxy.proxyData.footersMap.mutableCopy;
    [collectionViewModel.footersMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        footersMap[key] = obj;
        [self registerClass:obj forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:key];

        if (![obj.new isKindOfClass:UICollectionReusableView.class]) {
            NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] The class: %@ is neither UICollectionReusableView nor its subclasses.", NSStringFromClass(obj)];
            NSAssert(NO, error);
        }
    }];
    self.holo_proxy.proxyData.footersMap = footersMap;
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
        
        if (operateSection.header) [self _registerHeaderFooter:operateSection.header
                                    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                          withHeaderFootersMap:headersMap];
        if (operateSection.footer) [self _registerHeaderFooter:operateSection.footer
                                    forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                          withHeaderFootersMap:footersMap];
        
        // update map
        NSMutableDictionary *rowsMap = self.holo_proxy.proxyData.rowsMap.mutableCopy;
        for (HoloCollectionRow *row in operateSection.rows) {
            if (rowsMap[row.cell]) continue;
            
            Class cls = NSClassFromString(row.cell);
            if (!cls) {
                NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] No found a cell class with the name: %@.", row.cell];
                NSAssert(NO, error);
            }
            if (![cls.new isKindOfClass:UICollectionViewCell.class]) {
                NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] The class: %@ is neither UICollectionViewCell nor its subclasses.", row.cell];
                NSAssert(NO, error);
            }
            rowsMap[row.cell] = cls;
            [self registerClass:cls forCellWithReuseIdentifier:row.cell];
        }
        self.holo_proxy.proxyData.rowsMap = rowsMap;
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
- (void)_registerHeaderFooter:(NSString *)headerFooter
   forSupplementaryViewOfKind:(NSString *)elementKind
         withHeaderFootersMap:(NSMutableDictionary *)headerFootersMap {
    
    if (headerFootersMap[headerFooter]) return;
    
    Class cls = NSClassFromString(headerFooter);
    if (!cls) {
        NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] No found a headerFooter class with the name: %@.", headerFooter];
        NSAssert(NO, error);
    }
    if (![cls.new isKindOfClass:UICollectionReusableView.class]) {
        NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] The class: %@ is neither UICollectionReusableView nor its subclasses.", headerFooter];
        NSAssert(NO, error);
    }
    headerFootersMap[headerFooter] = cls;
    [self registerClass:cls forSupplementaryViewOfKind:elementKind withReuseIdentifier:headerFooter];
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
    NSMutableDictionary *rowsMap = self.holo_proxy.proxyData.rowsMap.mutableCopy;
    NSMutableArray *rows = [NSMutableArray new];
    for (HoloCollectionRow *row in [maker install]) {
        if (rowsMap[row.cell]) {
            [rows addObject:row];
            continue;
        }
        
        Class cls = NSClassFromString(row.cell);
        if (!cls) {
            NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] No found a cell class with the name: %@.", row.cell];
            NSAssert(NO, error);
        }
        if (![cls.new isKindOfClass:UICollectionViewCell.class]) {
            NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] The class: %@ is neither UICollectionViewCell nor its subclasses.", row.cell];
            NSAssert(NO, error);
        }
        rowsMap[row.cell] = cls;
        [self registerClass:cls forCellWithReuseIdentifier:row.cell];
        [rows addObject:row];
    }
    self.holo_proxy.proxyData.rowsMap = rowsMap;
    
    // append rows and refresh view
    BOOL isNewOne = NO;
    HoloCollectionSection *targetSection = [self.holo_proxy.proxyData sectionWithTag:tag];
    if (!targetSection) {
        targetSection = [HoloCollectionSection new];
        targetSection.tag = tag;
        [self.holo_proxy.proxyData insertSections:@[targetSection] anIndex:NSIntegerMax];
        isNewOne = YES;
    }
    NSIndexSet *indexSet = [targetSection insertRows:rows atIndex:index];
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
    [self _holo_updateRowsWithMakerType:HoloCollectionViewUpdateRowMakerTypeUpdate
                                  block:block
                                 reload:NO];
}

- (void)holo_updateRows:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *))block
             autoReload:(BOOL)autoReload {
    [self _holo_updateRowsWithMakerType:HoloCollectionViewUpdateRowMakerTypeUpdate
                                  block:block
                                 reload:autoReload];
}

// holo_remakeRows
- (void)holo_remakeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block {
    [self _holo_updateRowsWithMakerType:HoloCollectionViewUpdateRowMakerTypeRemake
                                  block:block
                                 reload:NO];
}

- (void)holo_remakeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block
             autoReload:(BOOL)autoReload {
    [self _holo_updateRowsWithMakerType:HoloCollectionViewUpdateRowMakerTypeRemake
                                  block:block
                                 reload:autoReload];
}


- (void)_holo_updateRowsWithMakerType:(HoloCollectionViewUpdateRowMakerType)makerType
                                block:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *))block
                               reload:(BOOL)reload {
    HoloCollectionViewUpdateRowMaker *maker = [[HoloCollectionViewUpdateRowMaker alloc] initWithProxyDataSections:self.holo_proxy.proxyData.sections makerType:makerType];
    if (block) block(maker);
    
    // update data and map
    NSMutableDictionary *rowsMap = self.holo_proxy.proxyData.rowsMap.mutableCopy;
    NSMutableArray *updateIndexPaths = [NSMutableArray new];
    NSMutableArray *updateArray = [NSMutableArray arrayWithArray:self.holo_proxy.proxyData.sections];
    for (HoloCollectionViewUpdateRowMakerModel *makerModel in [maker install]) {
        HoloCollectionRow *operateRow = makerModel.operateRow;
        // HoloCollectionViewUpdateRowMakerTypeUpdate || HoloCollectionViewUpdateRowMakerTypeRemake
        if (!makerModel.operateIndexPath) {
            HoloLog(@"[HoloCollectionView] No found a row with the tag: %@.", operateRow.tag);
            continue;
        }
        
        // update || remake
        [updateIndexPaths addObject:makerModel.operateIndexPath];
        
        if (makerType == HoloCollectionViewUpdateRowMakerTypeRemake) {
            HoloCollectionSection *section = updateArray[makerModel.operateIndexPath.section];
            NSMutableArray *rows = [NSMutableArray arrayWithArray:section.rows];
            [rows replaceObjectAtIndex:makerModel.operateIndexPath.row withObject:operateRow];
            section.rows = rows;
        }
        
        if (rowsMap[operateRow.cell]) continue;
        
        Class cls = NSClassFromString(operateRow.cell);
        if (!cls) {
            NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] No found a cell class with the name: %@.", operateRow.cell];
            NSAssert(NO, error);
        }
        if (![cls.new isKindOfClass:UICollectionViewCell.class]) {
            NSString *error = [NSString stringWithFormat:@"[HoloCollectionView] The class: %@ is neither UICollectionViewCell nor its subclasses.", operateRow.cell];
            NSAssert(NO, error);
        }
        rowsMap[operateRow.cell] = cls;
        [self registerClass:cls forCellWithReuseIdentifier:operateRow.cell];
    }
    self.holo_proxy.proxyData.rowsMap = rowsMap;
    self.holo_proxy.proxyData.sections = updateArray.copy;
    
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
    NSArray *indexPaths = [self.holo_proxy.proxyData removeAllRowsInSections:tags];
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
    NSArray *indexPaths = [self.holo_proxy.proxyData removeRows:tags];
    if (indexPaths.count <= 0) {
        HoloLog(@"[HoloCollectionView] No found any row with these tags: %@.", tags);
        return;
    }
    if (autoReload) [self deleteItemsAtIndexPaths:indexPaths];
}

@end
