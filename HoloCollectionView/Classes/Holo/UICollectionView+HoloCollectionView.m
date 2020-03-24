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

#pragma mark - make CollectionView
- (void)holo_makeCollectionView:(void (NS_NOESCAPE ^)(HoloCollectionViewMaker *))block {
    HoloCollectionViewMaker *maker = [HoloCollectionViewMaker new];
    if (block) block(maker);
    
    NSDictionary *dict = [maker install];
    self.holo_proxy.proxyData.sectionIndexTitles = dict[kHoloSectionIndexTitles];
    self.holo_proxy.proxyData.indexPathForIndexTitleHandler = dict[kHoloIndexPathForIndexTitleHandler];
}

#pragma mark - section
// holo_makeSections
- (void)holo_makeSections:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block {
    [self _holo_insertSectionsAtIndex:NSIntegerMax block:block autoReload:NO];
}

- (void)holo_makeSections:(void(NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *make))block autoReload:(BOOL)autoReload {
    [self _holo_insertSectionsAtIndex:NSIntegerMax block:block autoReload:autoReload];
}

- (void)holo_insertSectionsAtIndex:(NSInteger)index block:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block {
    [self _holo_insertSectionsAtIndex:index block:block autoReload:NO];
}

- (void)holo_insertSectionsAtIndex:(NSInteger)index block:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block autoReload:(BOOL)autoReload {
    [self _holo_insertSectionsAtIndex:index block:block autoReload:autoReload];
}

- (void)_holo_insertSectionsAtIndex:(NSInteger)index block:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block autoReload:(BOOL)autoReload {
    HoloCollectionViewSectionMaker *maker = [HoloCollectionViewSectionMaker new];
    if (block) block(maker);
    
    // update headerFooterMap
    NSMutableDictionary *headerFooterMap = self.holo_proxy.proxyData.headerFooterMap.mutableCopy;
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dict in [maker install]) {
        HoloCollectionSection *updateSection = dict[kHoloUpdateSection];
        [array addObject:updateSection];
        
        if (updateSection.header) [self _registerHeaderFooter:updateSection.header forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withHeaderFooterMap:headerFooterMap];
        if (updateSection.footer) [self _registerHeaderFooter:updateSection.footer forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withHeaderFooterMap:headerFooterMap];
        
        // update cell-cls map and register class
        NSMutableDictionary *cellClsMap = self.holo_proxy.proxyData.cellClsMap.mutableCopy;
        for (HoloCollectionRow *row in updateSection.rows) {
            Class class = NSClassFromString(row.cell);
            if (!class) {
                HoloLog(@"⚠️[HoloTableView] No found a cell class with the name: %@.", row.cell);
            } else if (!cellClsMap[row.cell]) {
                [self registerClass:class forCellWithReuseIdentifier:row.cell];
                cellClsMap[row.cell] = class;
            }
        }
        self.holo_proxy.proxyData.cellClsMap = cellClsMap;
    }
    self.holo_proxy.proxyData.headerFooterMap = headerFooterMap;
    
    // append sections
    NSIndexSet *indexSet = [self.holo_proxy.proxyData insertSections:array anIndex:index];
    if (autoReload && indexSet.count > 0) {
        [self insertSections:indexSet];
    }
}

// holo_updateSections
- (void)holo_updateSections:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block {
    [self _holo_updateSections:block isRemark:NO autoReload:NO];
}

- (void)holo_updateSections:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block autoReload:(BOOL)autoReload {
    [self _holo_updateSections:block isRemark:NO autoReload:autoReload];
}

// holo_remakeSections
- (void)holo_remakeSections:(void(NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *make))block {
    [self _holo_updateSections:block isRemark:YES autoReload:NO];
}

- (void)holo_remakeSections:(void(NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *make))block autoReload:(BOOL)autoReload {
    [self _holo_updateSections:block isRemark:YES autoReload:autoReload];
}

- (void)_holo_updateSections:(void (NS_NOESCAPE ^)(HoloCollectionViewSectionMaker *))block isRemark:(BOOL)isRemark autoReload:(BOOL)autoReload {
    HoloCollectionViewSectionMaker *maker = [[HoloCollectionViewSectionMaker alloc] initWithProxyDataSections:self.holo_proxy.proxyData.sections isRemark:isRemark];
    if (block) block(maker);
    
    // update targetSection and headerFooterMap
    NSMutableDictionary *headerFooterMap = self.holo_proxy.proxyData.headerFooterMap.mutableCopy;
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    for (NSDictionary *dict in [maker install]) {
        HoloCollectionSection *targetSection = dict[kHoloTargetSection];
        HoloCollectionSection *updateSection = dict[kHoloUpdateSection];
        if (!targetSection) {
            HoloLog(@"⚠️[HoloCollectionView] No found a section with the tag: %@.", updateSection.tag);
            continue;
        }
        [indexSet addIndex:[dict[kHoloTargetIndex] integerValue]];
        
        // set value to property which it's not kind of SEL
        unsigned int outCount;
        objc_property_t * properties = class_copyPropertyList([updateSection class], &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char * propertyAttr = property_getAttributes(property);
            char t = propertyAttr[1];
            if (t != ':') { // not SEL
                const char *propertyName = property_getName(property);
                NSString *propertyNameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
                
                id value = [updateSection valueForKey:propertyNameStr];
                if (value) {
                    if ([propertyNameStr isEqualToString:@"header"]) {
                        targetSection.header = updateSection.header;
                        [self _registerHeaderFooter:targetSection.header forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withHeaderFooterMap:headerFooterMap];
                    } else if ([propertyNameStr isEqualToString:@"footer"]) {
                        targetSection.footer = updateSection.footer;
                        [self _registerHeaderFooter:targetSection.footer forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withHeaderFooterMap:headerFooterMap];
                    } else {
                        [targetSection setValue:value forKey:propertyNameStr];
                    }
                } else if (isRemark) {
                    [targetSection setValue:NULL forKey:propertyNameStr];
                }
            }
        }
        
        // set value of SEL
        targetSection.headerFooterConfigSEL = updateSection.headerFooterConfigSEL;
        targetSection.headerFooterSizeSEL = updateSection.headerFooterSizeSEL;
    }
    self.holo_proxy.proxyData.headerFooterMap = headerFooterMap;
    
    // refresh view
    if (autoReload && indexSet.count > 0) {
        [self reloadSections:indexSet];
    }
}

// _registerHeaderFooter
- (void)_registerHeaderFooter:(NSString *)cls forSupplementaryViewOfKind:(NSString *)elementKind withHeaderFooterMap:(NSMutableDictionary *)headerFooterMap {
    if (!headerFooterMap[cls]) {
        Class class = NSClassFromString(cls);
        if (!class) {
            HoloLog(@"⚠️[HoloCollectionView] No found a headerFooter class with the name: %@.", cls);
        } else if (![[class new] isKindOfClass:[UICollectionReusableView class]]) {
            HoloLog(@"⚠️[HoloCollectionView] The class: %@, neither UICollectionReusableView nor its subclasses.", cls);
        } else {
            [self registerClass:class forSupplementaryViewOfKind:elementKind withReuseIdentifier:cls];
            headerFooterMap[cls] = class;
        }
    }
}

// holo_removeAllSections
- (void)holo_removeAllSections {
    [self _holo_removeAllSectionsautoReload:NO];
}

- (void)holo_removeAllSectionsautoReload:(BOOL)autoReload {
    [self _holo_removeAllSectionsautoReload:autoReload];
}

- (void)_holo_removeAllSectionsautoReload:(BOOL)autoReload {
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
        HoloLog(@"⚠️[HoloCollectionView] No found any section with these tags: %@.", tags);
        return;
    }
    if (autoReload) [self deleteSections:indexSet];
}

#pragma mark - row
// holo_makeRows
- (void)holo_makeRows:(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *))block {
    [self _holo_insertRowsAtIndex:NSIntegerMax inSection:nil block:block autoReload:NO];
}

- (void)holo_makeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block autoReload:(BOOL)autoReload {
    [self _holo_insertRowsAtIndex:NSIntegerMax inSection:nil block:block autoReload:autoReload];
}

// holo_makeRowsInSection
- (void)holo_makeRowsInSection:(NSString *)tag block:(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *))block {
    [self _holo_insertRowsAtIndex:NSIntegerMax inSection:tag block:block autoReload:NO];
}

- (void)holo_makeRowsInSection:(NSString *)tag block:(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *))block autoReload:(BOOL)autoReload {
    [self _holo_insertRowsAtIndex:NSIntegerMax inSection:tag block:block autoReload:autoReload];
}

- (void)holo_insertRowsAtIndex:(NSInteger)index block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block {
    [self _holo_insertRowsAtIndex:index inSection:nil block:block autoReload:NO];
}

- (void)holo_insertRowsAtIndex:(NSInteger)index block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block autoReload:(BOOL)autoReload {
    [self _holo_insertRowsAtIndex:index inSection:nil block:block autoReload:autoReload];
}

- (void)holo_insertRowsAtIndex:(NSInteger)index inSection:(NSString *)tag block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block {
    [self _holo_insertRowsAtIndex:index inSection:tag block:block autoReload:NO];
}

- (void)holo_insertRowsAtIndex:(NSInteger)index inSection:(NSString *)tag block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block autoReload:(BOOL)autoReload {
    [self _holo_insertRowsAtIndex:index inSection:tag block:block autoReload:autoReload];
}

- (void)_holo_insertRowsAtIndex:(NSInteger)index inSection:(NSString *)tag block:(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *))block autoReload:(BOOL)autoReload {
    HoloCollectionViewRowMaker *maker = [HoloCollectionViewRowMaker new];
    if (block) block(maker);
    
    // update cell-cls map and register class
    NSMutableDictionary *cellClsMap = self.holo_proxy.proxyData.cellClsMap.mutableCopy;
    NSMutableArray *rows = [NSMutableArray new];
    for (HoloCollectionRow *row in [maker install]) {
        Class class = NSClassFromString(row.cell);
        if (!cellClsMap[row.cell] && class) {
            [self registerClass:class forCellWithReuseIdentifier:row.cell];
            cellClsMap[row.cell] = class;
        }
        if (cellClsMap[row.cell]) {
            [rows addObject:row];
        } else {
            HoloLog(@"⚠️[HoloCollectionView] No found a cell class with the name: %@.", row.cell);
        }
    }
    self.holo_proxy.proxyData.cellClsMap = cellClsMap;
    
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
    [self _holo_updateRows:block isRemark:NO autoReload:NO];
}

- (void)holo_updateRows:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *))block autoReload:(BOOL)autoReload {
    [self _holo_updateRows:block isRemark:NO autoReload:autoReload];
}

// holo_remakeRows
- (void)holo_remakeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block {
    [self _holo_updateRows:block isRemark:YES autoReload:NO];
}

- (void)holo_remakeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block autoReload:(BOOL)autoReload {
    [self _holo_updateRows:block isRemark:YES autoReload:autoReload];
}

- (void)_holo_updateRows:(void (NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *))block isRemark:(BOOL)isRemark autoReload:(BOOL)autoReload {
    HoloCollectionViewUpdateRowMaker *maker = [[HoloCollectionViewUpdateRowMaker alloc] initWithProxyDataSections:self.holo_proxy.proxyData.sections isRemark:isRemark];
    if (block) block(maker);
    
    // update cell-cls map and register class
    NSMutableDictionary *cellClsMap = self.holo_proxy.proxyData.cellClsMap.mutableCopy;
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (NSDictionary *dict in [maker install]) {
        HoloCollectionRow *targetRow = dict[kHoloTargetRow];
        HoloCollectionRow *updateRow = dict[kHoloUpdateRow];
        if (!targetRow) {
            HoloLog(@"⚠️[HoloCollectionView] No found a row with the tag: %@.", updateRow.tag);
            continue;
        }
        [indexPaths addObject:dict[kHoloTargetIndexPath]];
        
        // set value to property which it's not kind of SEL
        unsigned int outCount;
        objc_property_t * properties = class_copyPropertyList([updateRow class], &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char * propertyAttr = property_getAttributes(property);
            char t = propertyAttr[1];
            if (t != ':') { // not SEL
                const char *propertyName = property_getName(property);
                NSString *propertyNameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
                id value = [updateRow valueForKey:propertyNameStr];
                if (value) {
                    if ([propertyNameStr isEqualToString:@"cell"]) {
                        Class class = NSClassFromString(updateRow.cell);
                        if (!cellClsMap[updateRow.cell] && class) {
                            [self registerClass:class forCellWithReuseIdentifier:updateRow.cell];
                            cellClsMap[updateRow.cell] = class;
                        }
                        if (cellClsMap[updateRow.cell]) {
                            targetRow.cell = updateRow.cell;
                        } else {
                            HoloLog(@"⚠️[HoloCollectionView] No found a class with the name: %@.", updateRow.cell);
                        }
                    } else {
                        [targetRow setValue:value forKey:propertyNameStr];
                    }
                } else if (isRemark) {
                    if ([propertyNameStr isEqualToString:@"cell"]) {
                        HoloLog(@"⚠️[HoloCollectionView] No update the cell of the row which you wish to ramark with the tag: %@.", updateRow.tag);
                    } else {
                        [targetRow setValue:NULL forKey:propertyNameStr];
                    }
                }
            }
        }
        
        // set value of SEL
        targetRow.configSEL = updateRow.configSEL;
        targetRow.sizeSEL = updateRow.sizeSEL;
    }
    self.holo_proxy.proxyData.cellClsMap = cellClsMap;
    
    // refresh view
    if (autoReload && indexPaths.count > 0) {
        [self reloadItemsAtIndexPaths:indexPaths];
    }
}

// holo_removeAllRowsInSections
- (void)holo_removeAllRowsInSections:(NSArray<NSString *> *)tags {
    [self _holo_removeAllRowsInSections:tags autoReload:NO];
}

- (void)holo_removeAllRowsInSections:(NSArray<NSString *> *)tags autoReload:(BOOL)autoReload {
    [self _holo_removeAllRowsInSections:tags autoReload:autoReload];
}

- (void)_holo_removeAllRowsInSections:(NSArray<NSString *> *)tags autoReload:(BOOL)autoReload {
    NSArray *indexPaths = [self.holo_proxy.proxyData removeAllRowsInSections:tags];
    if (autoReload && indexPaths.count > 0) {
        [self deleteItemsAtIndexPaths:indexPaths];
    }
}

// holo_removeRow
- (void)holo_removeRows:(NSArray<NSString *> *)tags {
    [self _holo_removeRow:tags autoReload:NO];
}

- (void)holo_removeRows:(NSArray<NSString *> *)tags autoReload:(BOOL)autoReload {
    [self _holo_removeRow:tags autoReload:autoReload];
}

- (void)_holo_removeRow:(NSArray<NSString *> *)tags autoReload:(BOOL)autoReload {
    NSArray *indexPaths = [self.holo_proxy.proxyData removeRows:tags];
    if (indexPaths.count <= 0) {
        HoloLog(@"⚠️[HoloCollectionView] No found any row with these tags: %@.", tags);
        return;
    }
    if (autoReload) [self deleteItemsAtIndexPaths:indexPaths];
}

@end
