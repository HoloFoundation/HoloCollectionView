//
//  HoloCollectionViewProxy.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewProxy.h"
#import "HoloCollectionItem.h"
#import "HoloCollectionSection.h"
#import "HoloCollectionViewProxyData.h"

@interface HoloCollectionViewProxy ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloCollectionViewProxy

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
    }
    return self;
}


static HoloCollectionSection *HoloCollectionSectionWithIndex(HoloCollectionViewProxy *holoProxy, NSInteger section) {
    if (section >= holoProxy.proxyData.sections.count) return nil;
    HoloCollectionSection *holoSection = holoProxy.proxyData.sections[section];
    return holoSection;
}

static HoloCollectionItem *HoloCollectionItemWithIndexPath(HoloCollectionViewProxy *holoProxy, NSIndexPath *indexPath) {
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(holoProxy, indexPath.section);
    if (indexPath.item >= holoSection.items.count) return nil;
    
    HoloCollectionItem *holoItem = holoSection.items[indexPath.item];
    return holoItem;
}

static NSInvocation *HoloProxyInvocation(id target, SEL sel, id model) {
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = sel;
    [invocation setArgument:&model atIndex:2];
    [invocation invoke];
    return invocation;
}

static CGSize HoloProxyMethodSignatureSizeResult(id target, SEL sel, id model) {
    NSInvocation *invocation = HoloProxyInvocation(target, sel, model);
    CGSize retLoc;
    [invocation getReturnValue:&retLoc];
    return retLoc;
}

static CGSize HoloProxyItemSizeResult(Class cls, SEL sel, CGSize (^handler)(id), id model, CGSize size, CGSize flowLayoutSize) {
    if (!cls) return CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
    
    if (sel && [cls respondsToSelector:sel]) {
        return HoloProxyMethodSignatureSizeResult(cls, sel, model);
    } else if (handler) {
        return handler(model);
    } else if (size.width != CGFLOAT_MIN || size.height != CGFLOAT_MIN) {
        return size;
    }
    return flowLayoutSize;
}

static BOOL HoloProxyBOOLResult(BOOL (^handler)(id), id model, BOOL can) {
    if (handler) {
        return handler(model);
    } else {
        return can;
    }
}

static BOOL HoloProxyBOOLResultWithCell(UICollectionViewCell *cell, SEL sel, BOOL (^handler)(id), id model, BOOL can) {
    if (!cell) return NO;
    
    if (sel && [cell respondsToSelector:sel]) {
        NSInvocation *invocation = HoloProxyInvocation(cell, sel, model);
        BOOL retLoc;
        [invocation getReturnValue:&retLoc];
        return retLoc;
    } else if (handler) {
        return handler(model);
    }
    return can;
}

static void HoloProxyCellPerform(UICollectionViewCell *cell, SEL sel, void (^handler)(id), id model) {
    if (!cell) return;
    
    if (sel && [cell respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [cell performSelector:sel withObject:model];
#pragma clang diagnostic pop
    } else if (handler) {
        handler(model);
    }
}

static void HoloProxyCellPerformWithCell(UICollectionViewCell *cell, SEL sel, void (^handler)(UICollectionViewCell *, id), id model) {
    if (!cell) return;
    
    if (sel && [cell respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [cell performSelector:sel withObject:model];
#pragma clang diagnostic pop
    } else if (handler) {
        handler(cell, model);
    }
}

static void HoloProxyViewPerformWithView(UIView *view, SEL sel, void (^handler)(UIView *, id), id model) {
    if (!view) return;
    
    if (sel && [view respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [view performSelector:sel withObject:model];
#pragma clang diagnostic pop
    } else if (handler) {
        handler(view, model);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [self.dataSource numberOfSectionsInCollectionView:collectionView];
    }
    
    return self.proxyData.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [self.dataSource collectionView:collectionView numberOfItemsInSection:section];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(self, section);
    return holoSection.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    if (holoItem.modelHandler) holoItem.model = holoItem.modelHandler();
    if (holoItem.reuseIdHandler) holoItem.reuseId = holoItem.reuseIdHandler(holoItem.model);
    if (!holoItem.reuseId) holoItem.reuseId = NSStringFromClass(holoItem.cell);
    
    if (!self.proxyData.itemsMap[holoItem.reuseId]) {
        Class cls = holoItem.cell;
        if (![cls isSubclassOfClass:UICollectionViewCell.class]) {
            NSAssert(NO, @"[HoloCollectionView] The class: `%@` is neither UICollectionViewCell nor its subclasses.", cls);
        }
        [collectionView registerClass:cls forCellWithReuseIdentifier:holoItem.reuseId];
        NSMutableDictionary *itemsMap = [NSMutableDictionary dictionaryWithDictionary:self.proxyData.itemsMap];
        itemsMap[holoItem.reuseId] = cls;
        self.proxyData.itemsMap = itemsMap.copy;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:holoItem.reuseId forIndexPath:indexPath];
    
    // Performed before `configSEL`
    if (holoItem.beforeConfigureHandler) {
        holoItem.beforeConfigureHandler(cell, holoItem.model);
    }
    
    if (holoItem.configSEL && [cell respondsToSelector:holoItem.configSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [cell performSelector:holoItem.configSEL withObject:holoItem.model];
#pragma clang diagnostic pop
    }
    
    // Performed after `configSEL`
    if (holoItem.afterConfigureHandler) {
        holoItem.afterConfigureHandler(cell, holoItem.model);
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.dataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(self, indexPath.section);
    
    id model = nil;
    NSString *reuseIdentifier = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (holoSection.headerModelHandler) {
            model = holoSection.headerModelHandler();
        } else {
            model = holoSection.headerModel;
        }
        
        if (holoSection.headerReuseIdHandler) holoSection.headerReuseId = holoSection.headerReuseIdHandler(holoSection.headerModel);
        if (!holoSection.headerReuseId) holoSection.headerReuseId = NSStringFromClass(holoSection.header);
        reuseIdentifier = holoSection.headerReuseId;
        
        if (!self.proxyData.headersMap[reuseIdentifier]) {
            Class cls = holoSection.header;
            if (![cls isSubclassOfClass:UICollectionReusableView.class]) {
                NSAssert(NO, @"[HoloCollectionView] The class: `%@` is neither UICollectionReusableView nor its subclasses.", cls);
            }
            [collectionView registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
            NSMutableDictionary *headersMap = [NSMutableDictionary dictionaryWithDictionary:self.proxyData.itemsMap];
            headersMap[reuseIdentifier] = cls;
            self.proxyData.headersMap = headersMap.copy;
        }
    } else {
        if (holoSection.footerModelHandler) {
            model = holoSection.footerModelHandler();
        } else {
            model = holoSection.footerModel;
        }
        
        if (holoSection.footerReuseIdHandler) holoSection.footerReuseId = holoSection.footerReuseIdHandler(holoSection.footerModel);
        if (!holoSection.footerReuseId) holoSection.footerReuseId = NSStringFromClass(holoSection.footer);
        reuseIdentifier = holoSection.footerReuseId;
        
        if (!self.proxyData.footersMap[reuseIdentifier]) {
            Class cls = holoSection.footer;
            if (![cls isSubclassOfClass:UICollectionReusableView.class]) {
                NSAssert(NO, @"[HoloCollectionView] The class: `%@` is neither UICollectionReusableView nor its subclasses.", cls);
            }
            [collectionView registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifier];
            NSMutableDictionary *footersMap = [NSMutableDictionary dictionaryWithDictionary:self.proxyData.itemsMap];
            footersMap[reuseIdentifier] = cls;
            self.proxyData.footersMap = footersMap.copy;
        }
    }
    UICollectionReusableView *holoHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] &&
        holoSection.headerConfigSEL &&
        [holoHeaderView respondsToSelector:holoSection.headerConfigSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [holoHeaderView performSelector:holoSection.headerConfigSEL withObject:model];
#pragma clang diagnostic pop
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter] &&
               holoSection.footerConfigSEL &&
               [holoHeaderView respondsToSelector:holoSection.footerConfigSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [holoHeaderView performSelector:holoSection.footerConfigSEL withObject:model];
#pragma clang diagnostic pop
    }
    return holoHeaderView;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
        return [self.dataSource collectionView:collectionView canMoveItemAtIndexPath:indexPath];
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    return HoloProxyBOOLResult(holoItem.canMoveHandler, holoItem.model, holoItem.canMove);
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.dataSource respondsToSelector:@selector(collectionView:moveItemAtIndexPath:toIndexPath:)]) {
        [self.dataSource collectionView:collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        return;
    }
    
    HoloCollectionSection *sourceSection = HoloCollectionSectionWithIndex(self, sourceIndexPath.section);
    HoloCollectionItem *sourceItem = HoloCollectionItemWithIndexPath(self, sourceIndexPath);
    if (sourceItem.moveHandler) {
        sourceItem.moveHandler(sourceIndexPath, destinationIndexPath, ^(BOOL actionPerformed) {
            if (actionPerformed && self.proxyData.sections.count > destinationIndexPath.section) {
                HoloCollectionSection *destinationSection = self.proxyData.sections[destinationIndexPath.section];
                [sourceSection removeItem:sourceItem];
                [destinationSection insertItem:sourceItem atIndex:destinationIndexPath.item];
            }
        });
    }
}

- (NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView {
    if ([self.dataSource respondsToSelector:@selector(indexTitlesForCollectionView:)]) {
        return [self.dataSource indexTitlesForCollectionView:collectionView];
    }
    
    return self.proxyData.sectionIndexTitles;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index API_AVAILABLE(tvos(10.2)) {
    if ([self.dataSource respondsToSelector:@selector(collectionView:indexPathForIndexTitle:atIndex:)]) {
        return [self.dataSource collectionView:collectionView indexPathForIndexTitle:title atIndex:index];
    }
    
    if (self.proxyData.indexPathForIndexTitleHandler) {
        return self.proxyData.indexPathForIndexTitleHandler(title, index);
    }
    return [NSIndexPath indexPathWithIndex:index];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    Class cls = holoItem.cell;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    return HoloProxyItemSizeResult(cls, holoItem.sizeSEL, holoItem.sizeHandler, holoItem.model, holoItem.size, flowLayout.itemSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(self, section);
    if (holoSection.insetHandler) {
        return holoSection.insetHandler();
    } else if (holoSection.inset.top != CGFLOAT_MIN ||
        holoSection.inset.bottom != CGFLOAT_MIN ||
        holoSection.inset.left != CGFLOAT_MIN ||
        holoSection.inset.right != CGFLOAT_MIN) {
        return holoSection.inset;
    } else {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        return flowLayout.sectionInset;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(self, section);
    
    if (holoSection.minimumLineSpacingHandler) {
        return holoSection.minimumLineSpacingHandler();
    } else if (holoSection.minimumLineSpacing != CGFLOAT_MIN) {
        return holoSection.minimumLineSpacing;
    } else {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        return flowLayout.minimumLineSpacing;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(self, section);
    
    if (holoSection.minimumInteritemSpacingHandler) {
        return holoSection.minimumInteritemSpacingHandler();
    } else if (holoSection.minimumInteritemSpacing != CGFLOAT_MIN) {
        return holoSection.minimumInteritemSpacing;
    } else {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        return flowLayout.minimumInteritemSpacing;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(self, section);
    Class header = holoSection.header;
    
    if (holoSection.headerSizeSEL && [header respondsToSelector:holoSection.headerSizeSEL]) {
        return HoloProxyMethodSignatureSizeResult(header, holoSection.headerSizeSEL, holoSection.headerModel);
    } else if (holoSection.headerSizeHandler) {
        return holoSection.headerSizeHandler(holoSection.headerModel);
    } else if (holoSection.headerSize.width != CGFLOAT_MIN ||
        holoSection.headerSize.height != CGFLOAT_MIN) {
        return holoSection.headerSize;
    } else {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        return flowLayout.headerReferenceSize;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(self, section);
    Class footer = holoSection.footer;

    if (holoSection.footerSizeSEL && [footer respondsToSelector:holoSection.footerSizeSEL]) {
        return HoloProxyMethodSignatureSizeResult(footer, holoSection.footerSizeSEL, holoSection.footerModel);
    } else if (holoSection.footerSizeHandler) {
        return holoSection.footerSizeHandler(holoSection.footerModel);
    } else if (holoSection.footerSize.width != CGFLOAT_MIN ||
        holoSection.footerSize.height != CGFLOAT_MIN) {
        return holoSection.footerSize;
    } else {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        return flowLayout.footerReferenceSize;
    }
}


#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    return HoloProxyBOOLResultWithCell(cell, holoItem.shouldHighlightSEL, holoItem.shouldHighlightHandler, holoItem.model, holoItem.shouldHighlight);
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    HoloProxyCellPerform(cell, holoItem.didHighlightSEL, holoItem.didHighlightHandler, holoItem.model);
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    HoloProxyCellPerform(cell, holoItem.didUnHighlightSEL, holoItem.didUnHighlightHandler, holoItem.model);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    return HoloProxyBOOLResultWithCell(cell, holoItem.shouldSelectSEL, holoItem.shouldSelectHandler, holoItem.model, holoItem.shouldSelect);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    return HoloProxyBOOLResultWithCell(cell, holoItem.shouldDeselectSEL, holoItem.shouldDeselectHandler, holoItem.model, holoItem.shouldDeselect);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    HoloProxyCellPerform(cell, holoItem.didSelectSEL, holoItem.didSelectHandler, holoItem.model);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    HoloProxyCellPerform(cell, holoItem.didDeselectSEL, holoItem.didDeselectHandler, holoItem.model);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    HoloProxyCellPerformWithCell(cell, holoItem.willDisplaySEL, holoItem.willDisplayHandler, holoItem.model);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, indexPath);
    HoloProxyCellPerformWithCell(cell, holoItem.didEndDisplayingSEL, holoItem.didEndDisplayingHandler, holoItem.model);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)]) {
        [self.delegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
        return;
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(self, indexPath.section);
    
    if (elementKind == UICollectionElementKindSectionHeader) {
        HoloProxyViewPerformWithView(view, holoSection.willDisplayHeaderSEL, holoSection.willDisplayHeaderHandler, holoSection.headerModel);
    } else {
        HoloProxyViewPerformWithView(view, holoSection.willDisplayFooterSEL, holoSection.willDisplayFooterHandler, holoSection.footerModel);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
        return;
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(self, indexPath.section);
    if (elementKind == UICollectionElementKindSectionHeader) {
        HoloProxyViewPerformWithView(view, holoSection.didEndDisplayingHeaderSEL, holoSection.didEndDisplayingHeaderHandler, holoSection.headerModel);
    } else {
        HoloProxyViewPerformWithView(view, holoSection.didEndDisplayingFooterSEL, holoSection.didEndDisplayingFooterHandler, holoSection.footerModel);
    }
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.delegate respondsToSelector:@selector(collectionView:targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:)]) {
        return [self.delegate collectionView:collectionView targetIndexPathForMoveFromItemAtIndexPath:originalIndexPath toProposedIndexPath:proposedIndexPath];
    }
    
    HoloCollectionItem *holoItem = HoloCollectionItemWithIndexPath(self, originalIndexPath);
    if (holoItem.targetMoveHandler) {
        return holoItem.targetMoveHandler(originalIndexPath, proposedIndexPath);
    }
    return proposedIndexPath;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollDelegate scrollViewDidScroll:scrollView];
        return;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.scrollDelegate scrollViewDidZoom:scrollView];
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollDelegate scrollViewWillBeginDragging:scrollView];
        return;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
        return;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
        return;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollDelegate scrollViewWillBeginDecelerating:scrollView];
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollDelegate scrollViewDidEndDecelerating:scrollView];
        return;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollDelegate scrollViewDidEndScrollingAnimation:scrollView];
        return;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.scrollDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.scrollDelegate scrollViewWillBeginZooming:scrollView withView:view];
        return;
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.scrollDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
        return;
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.scrollDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.scrollDelegate scrollViewDidScrollToTop:scrollView];
        return;
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0)) {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]) {
        [self.scrollDelegate scrollViewDidChangeAdjustedContentInset:scrollView];
        return;
    }
}


#pragma mark - getter
- (HoloCollectionViewProxyData *)proxyData {
    if (!_proxyData) {
        _proxyData = [HoloCollectionViewProxyData new];
    }
    return _proxyData;
}

@end
