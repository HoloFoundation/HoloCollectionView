//
//  HoloCollectionViewProxy.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewProxy.h"
#import "HoloCollectionViewProxyData.h"
#import "HoloCollectionViewRowMaker.h"
#import "HoloCollectionViewSectionMaker.h"

static HoloCollectionViewProxy *kProxySelf;

@interface HoloCollectionViewProxy ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy, readonly) NSArray<HoloCollectionSection *> *holoSections;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, Class> *holoRowsMap;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, Class> *holoHeadersMap;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, Class> *holoFootersMap;

@end

@implementation HoloCollectionViewProxy

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        kProxySelf = self;
    }
    return self;
}


static HoloCollectionSection *HoloCollectionSectionWithIndex(NSInteger section) {
    if (section >= kProxySelf.proxyData.sections.count) return nil;
    HoloCollectionSection *holoSection = kProxySelf.proxyData.sections[section];
    return holoSection;
}

static HoloCollectionRow *HoloCollectionRowWithIndexPath(NSIndexPath *indexPath) {
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(indexPath.section);
    if (indexPath.row >= holoSection.rows.count) return nil;
    
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    return holoRow;
}

static NSInvocation *HoloProxyAPIInvocation(id target, SEL sel, id model) {
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = sel;
    [invocation setArgument:&model atIndex:2];
    [invocation invoke];
    return invocation;
}

static CGSize HoloProxyAPISizeResultWithMethodSignature(id target, SEL sel, id model) {
    NSInvocation *invocation = HoloProxyAPIInvocation(target, sel, model);
    CGSize retLoc;
    [invocation getReturnValue:&retLoc];
    return retLoc;
}

static CGSize HoloProxyAPISizeResult(Class cls, SEL sel, CGSize (^handler)(id), id model, CGSize size) {
    if (!cls) return CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
    
    if (sel && [cls respondsToSelector:sel]) {
        return HoloProxyAPISizeResultWithMethodSignature(cls, sel, model);
    } else if (handler) {
        return handler(model);
    } else if (size.width != CGFLOAT_MIN || size.height != CGFLOAT_MIN) {
        return size;
    } else {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)kProxySelf.collectionView.collectionViewLayout;
        return flowLayout.itemSize;
    }
}

static BOOL HoloProxyAPIBOOLResult(UICollectionViewCell *cell, SEL sel, BOOL (^handler)(id), id model, BOOL can) {
    if (!cell) return NO;
    
    if (cell && [cell respondsToSelector:sel]) {
        NSInvocation *invocation = HoloProxyAPIInvocation(cell, sel, model);
        BOOL retLoc;
        [invocation getReturnValue:&retLoc];
        return retLoc;
    } else if (handler) {
        return handler(model);
    }
    return can;
}

static void HoloProxyAPIPerform(UICollectionViewCell *cell, SEL sel, void (^handler)(id), id model) {
    if (!cell) return;
    
    if (cell && [cell respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [cell performSelector:sel withObject:model];
#pragma clang diagnostic pop
    } else if (handler) {
        handler(model);
    }
}

static void HoloProxyAPIRowPerformWithCell(HoloCollectionRow *row, SEL sel, void (^handler)(UICollectionViewCell *, id), UICollectionViewCell *cell) {
    if (!row) return;
    
    Class cls = kProxySelf.proxyData.rowsMap[row.cell];
    if (sel && [cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [cls performSelector:sel withObject:cell withObject:row.model];
#pragma clang diagnostic pop
    } else if (handler) {
        handler(cell, row.model);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [self.dataSource numberOfSectionsInCollectionView:collectionView];
    }
    
    return self.holoSections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [self.dataSource collectionView:collectionView numberOfItemsInSection:section];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(section);
    return holoSection.rows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    if (holoRow.modelHandler) holoRow.model = holoRow.modelHandler();
    
    NSString *clsName = NSStringFromClass(self.holoRowsMap[holoRow.cell]);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:clsName forIndexPath:indexPath];
    
    if (holoRow.configSEL && [cell respondsToSelector:holoRow.configSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [cell performSelector:holoRow.configSEL withObject:holoRow.model];
#pragma clang diagnostic pop
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.dataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(indexPath.section);
    
    NSString *reuseIdentifier = nil;
    id model = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reuseIdentifier = holoSection.header;
        
        if (holoSection.headerModelHandler) {
            model = holoSection.headerModelHandler();
        } else {
            model = holoSection.headerModel;
        }
    } else {
        reuseIdentifier = holoSection.footer;
        
        if (holoSection.footerModelHandler) {
            model = holoSection.footerModelHandler();
        } else {
            model = holoSection.footerModel;
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
    } else if (holoSection.headerFooterConfigSEL &&
               [holoHeaderView respondsToSelector:holoSection.headerFooterConfigSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [holoHeaderView performSelector:holoSection.headerFooterConfigSEL withObject:model];
#pragma clang diagnostic pop
    }
    return holoHeaderView;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
        return [self.dataSource collectionView:collectionView canMoveItemAtIndexPath:indexPath];
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    return HoloProxyAPIBOOLResult(cell, holoRow.canMoveSEL, holoRow.canMoveHandler, holoRow.model, holoRow.canMove);
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.dataSource respondsToSelector:@selector(collectionView:moveItemAtIndexPath:toIndexPath:)]) {
        [self.dataSource collectionView:collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        return;
    }
    
    HoloCollectionSection *sourceSection = HoloCollectionSectionWithIndex(sourceIndexPath.section);
    HoloCollectionRow *sourceRow = HoloCollectionRowWithIndexPath(sourceIndexPath);
    if (sourceRow.moveHandler) {
        sourceRow.moveHandler(sourceIndexPath, destinationIndexPath, ^(BOOL actionPerformed) {
            if (actionPerformed) {
                HoloCollectionSection *destinationSection = self.holoSections[destinationIndexPath.section];
                [sourceSection removeRow:sourceRow];
                [destinationSection insertRows:@[sourceRow] atIndex:destinationIndexPath.row];
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
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    Class cls = self.holoRowsMap[holoRow.cell];
    return HoloProxyAPISizeResult(cls, holoRow.sizeSEL, holoRow.sizeHandler, holoRow.model, holoRow.size);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(section);
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
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(section);
    
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
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(section);
    
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
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(section);
    Class header = self.holoHeadersMap[holoSection.header];
    
    if (holoSection.headerSizeSEL && [header respondsToSelector:holoSection.headerSizeSEL]) {
        return [self _sizeWithMethodSignatureCls:header selector:holoSection.headerSizeSEL model:holoSection.headerModel];
    } else if (holoSection.headerFooterSizeSEL && [header respondsToSelector:holoSection.headerFooterSizeSEL]) {
        return [self _sizeWithMethodSignatureCls:header selector:holoSection.headerFooterSizeSEL model:holoSection.headerModel];
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
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(section);
    Class footer = self.holoFootersMap[holoSection.footer];

    if (holoSection.footerSizeSEL && [footer respondsToSelector:holoSection.footerSizeSEL]) {
        return [self _sizeWithMethodSignatureCls:footer selector:holoSection.footerSizeSEL model:holoSection.footerModel];
    } else if (holoSection.headerFooterSizeSEL && [footer respondsToSelector:holoSection.headerFooterSizeSEL]) {
        return [self _sizeWithMethodSignatureCls:footer selector:holoSection.headerFooterSizeSEL model:holoSection.footerModel];
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

- (CGSize)_sizeWithMethodSignatureCls:(Class)cls selector:(SEL)selector model:(id)model {
    NSMethodSignature *signature = [cls methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = cls;
    invocation.selector = selector;
    [invocation setArgument:&model atIndex:2];
    [invocation invoke];
    
    CGSize size;
    [invocation getReturnValue:&size];
    return size;
}


#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    return HoloProxyAPIBOOLResult(cell, holoRow.shouldHighlightSEL, holoRow.shouldHighlightHandler, holoRow.model, holoRow.shouldHighlight);
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    HoloProxyAPIPerform(cell, holoRow.didHighlightSEL, holoRow.didHighlightHandler, holoRow.model);
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    HoloProxyAPIPerform(cell, holoRow.didUnHighlightSEL, holoRow.didUnHighlightHandler, holoRow.model);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    return HoloProxyAPIBOOLResult(cell, holoRow.shouldSelectSEL, holoRow.shouldSelectHandler, holoRow.model, holoRow.shouldSelect);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    return HoloProxyAPIBOOLResult(cell, holoRow.shouldDeselectSEL, holoRow.shouldDeselectHandler, holoRow.model, holoRow.shouldDeselect);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    HoloProxyAPIPerform(cell, holoRow.didSelectSEL, holoRow.didSelectHandler, holoRow.model);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    HoloProxyAPIPerform(cell, holoRow.didDeselectSEL, holoRow.didDeselectHandler, holoRow.model);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    HoloProxyAPIRowPerformWithCell(holoRow, holoRow.willDisplaySEL, holoRow.willDisplayHandler, cell);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
        return;
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(indexPath);
    HoloProxyAPIRowPerformWithCell(holoRow, holoRow.didEndDisplayingSEL, holoRow.didEndDisplayingHandler, cell);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)]) {
        [self.delegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
        return;
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(indexPath.section);
    
    if (elementKind == UICollectionElementKindSectionHeader) {
        if (holoSection.willDisplayHeaderSEL && [view respondsToSelector:holoSection.willDisplayHeaderSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [view performSelector:holoSection.willDisplayHeaderSEL withObject:holoSection.headerModel];
#pragma clang diagnostic pop
        } else if (holoSection.willDisplayHeaderHandler) {
            holoSection.willDisplayHeaderHandler(view, holoSection.headerModel);
        }
    } else {
        if (holoSection.willDisplayFooterSEL && [view respondsToSelector:holoSection.willDisplayFooterSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [view performSelector:holoSection.willDisplayFooterSEL withObject:holoSection.footerModel];
#pragma clang diagnostic pop
        } else if (holoSection.willDisplayFooterHandler) {
            holoSection.willDisplayFooterHandler(view, holoSection.footerModel);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
        return;
    }
    
    HoloCollectionSection *holoSection = HoloCollectionSectionWithIndex(indexPath.section);
    if (elementKind == UICollectionElementKindSectionHeader) {
        if (holoSection.didEndDisplayingHeaderSEL && [view respondsToSelector:holoSection.didEndDisplayingHeaderSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [view performSelector:holoSection.didEndDisplayingHeaderSEL withObject:holoSection.headerModel];
#pragma clang diagnostic pop
        } else if (holoSection.didEndDisplayingHeaderHandler) {
            holoSection.didEndDisplayingHeaderHandler(view, holoSection.headerModel);
        }
    } else {
        if (holoSection.didEndDisplayingFooterSEL && [view respondsToSelector:holoSection.didEndDisplayingFooterSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [view performSelector:holoSection.didEndDisplayingFooterSEL withObject:holoSection.footerModel];
#pragma clang diagnostic pop
        } else if (holoSection.didEndDisplayingFooterHandler) {
            holoSection.didEndDisplayingFooterHandler(view, holoSection.footerModel);
        }
    }
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.delegate respondsToSelector:@selector(collectionView:targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:)]) {
        return [self.delegate collectionView:collectionView targetIndexPathForMoveFromItemAtIndexPath:originalIndexPath toProposedIndexPath:proposedIndexPath];
    }
    
    HoloCollectionRow *holoRow = HoloCollectionRowWithIndexPath(originalIndexPath);
    if (holoRow.targetMoveHandler) {
        return holoRow.targetMoveHandler(originalIndexPath, proposedIndexPath);
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

- (NSArray<HoloCollectionSection *> *)holoSections {
    return self.proxyData.sections;
}

- (NSDictionary<NSString *, Class> *)holoRowsMap {
    return self.proxyData.rowsMap;
}

- (NSDictionary<NSString *,Class> *)holoHeadersMap {
    return self.proxyData.headersMap;
}

- (NSDictionary<NSString *,Class> *)holoFootersMap {
    return self.proxyData.footersMap;
}

@end
