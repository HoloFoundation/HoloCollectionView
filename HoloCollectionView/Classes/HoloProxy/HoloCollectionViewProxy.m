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

@interface HoloCollectionViewProxy ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy, readonly) NSArray<HoloCollectionSection *> *holoSections;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, Class> *holoCellClsMap;

@end

@implementation HoloCollectionViewProxy

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
    }
    return self;
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
    if (section >= self.holoSections.count) return 0;
    
    HoloCollectionSection *holoSection = self.holoSections[section];
    return holoSection.rows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    
    NSString *clsName = NSStringFromClass(self.holoCellClsMap[holoRow.cell]);
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
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    
    NSString *reuseIdentifier = nil;
    id model = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reuseIdentifier = holoSection.header;
        model = holoSection.headerModel;
    } else {
        reuseIdentifier = holoSection.footer;
        model = holoSection.footerModel;
    }
    UICollectionReusableView *holoHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (holoSection.headerFooterConfigSEL && [holoHeaderView respondsToSelector:holoSection.headerFooterConfigSEL]) {
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
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    return holoRow.canMove;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.dataSource respondsToSelector:@selector(collectionView:moveItemAtIndexPath:toIndexPath:)]) {
        [self.dataSource collectionView:collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
    
    HoloCollectionSection *sourceSection = self.holoSections[sourceIndexPath.section];
    HoloCollectionRow *sourceRow = sourceSection.rows[sourceIndexPath.row];
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
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    
    Class cls = self.holoCellClsMap[holoRow.cell];
    if (holoRow.sizeSEL && [cls respondsToSelector:holoRow.sizeSEL]) {
        return [self _sizeWithMethodSignatureCls:cls selector:holoRow.sizeSEL model:holoRow.model];
    }
    if (holoRow.size.width != CGFLOAT_MIN || holoRow.size.height != CGFLOAT_MIN) {
        return holoRow.size;
    }
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    return flowLayout.itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[section];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (holoSection.inset.top != CGFLOAT_MIN ||
        holoSection.inset.bottom != CGFLOAT_MIN ||
        holoSection.inset.left != CGFLOAT_MIN ||
        holoSection.inset.right != CGFLOAT_MIN) {
        return holoSection.inset;
    } else {
        return flowLayout.sectionInset;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[section];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (holoSection.minimumLineSpacing != CGFLOAT_MIN) {
        return holoSection.minimumLineSpacing;
    } else {
        return flowLayout.minimumLineSpacing;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[section];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (holoSection.minimumInteritemSpacing != CGFLOAT_MIN) {
        return holoSection.minimumInteritemSpacing;
    } else {
        return flowLayout.minimumInteritemSpacing;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[section];
    Class header = NSClassFromString(holoSection.header);
    if (holoSection.headerFooterSizeSEL && [header respondsToSelector:holoSection.headerFooterSizeSEL]) {
        return [self _sizeWithMethodSignatureCls:header selector:holoSection.headerFooterSizeSEL model:holoSection.headerModel];
    }
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (holoSection.headerSize.width != CGFLOAT_MIN ||
        holoSection.headerSize.height != CGFLOAT_MIN) {
        return holoSection.headerSize;
    } else {
        return flowLayout.headerReferenceSize;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[section];
    Class footer = NSClassFromString(holoSection.footer);
    if (holoSection.headerFooterSizeSEL && [footer respondsToSelector:holoSection.headerFooterSizeSEL]) {
        return [self _sizeWithMethodSignatureCls:footer selector:holoSection.headerFooterSizeSEL model:holoSection.footerModel];
    }
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (holoSection.footerSize.width != CGFLOAT_MIN ||
        holoSection.footerSize.height != CGFLOAT_MIN) {
        return holoSection.footerSize;
    } else {
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
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    return holoRow.shouldHighlight;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    if (holoRow.didHighlightHandler) holoRow.didHighlightHandler(holoRow.model);
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    if (holoRow.didUnHighlightHandler) holoRow.didUnHighlightHandler(holoRow.model);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    return holoRow.shouldSelect;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    return holoRow.shouldDeselect;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    if (holoRow.didSelectHandler) holoRow.didSelectHandler(holoRow.model);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    if (holoRow.didDeselectHandler) holoRow.didDeselectHandler(holoRow.model);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    if (holoRow.willDisplayHandler) holoRow.willDisplayHandler(cell, holoRow.model);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
    
    if (indexPath.section >= self.holoSections.count) return;
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    if (indexPath.row >= holoSection.rows.count) return;
    HoloCollectionRow *holoRow = holoSection.rows[indexPath.row];
    if (holoRow.didEndDisplayingHandler) holoRow.didEndDisplayingHandler(cell, holoRow.model);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)]) {
        [self.delegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    if (elementKind == UICollectionElementKindSectionHeader) {
        if (holoSection.willDisplayHeaderHandler) holoSection.willDisplayHeaderHandler(view, holoSection.headerModel);
    } else {
        if (holoSection.willDisplayFooterHandler) holoSection.willDisplayFooterHandler(view, holoSection.footerModel);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
    }
    
    if (indexPath.section >= self.holoSections.count) return;
    HoloCollectionSection *holoSection = self.holoSections[indexPath.section];
    if (elementKind == UICollectionElementKindSectionHeader) {
        if (holoSection.didEndDisplayingHeaderHandler) holoSection.didEndDisplayingHeaderHandler(view, holoSection.headerModel);
    } else {
        if (holoSection.didEndDisplayingFooterHandler) holoSection.didEndDisplayingFooterHandler(view, holoSection.footerModel);
    }
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.delegate respondsToSelector:@selector(collectionView:targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:)]) {
        return [self.delegate collectionView:collectionView targetIndexPathForMoveFromItemAtIndexPath:originalIndexPath toProposedIndexPath:proposedIndexPath];
    }
    
    HoloCollectionSection *holoSection = self.holoSections[originalIndexPath.section];
    HoloCollectionRow *holoRow = holoSection.rows[originalIndexPath.row];
    if (holoRow.targetMoveHandler) {
        return holoRow.targetMoveHandler(originalIndexPath, proposedIndexPath);
    }
    return proposedIndexPath;
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

- (NSDictionary<NSString *, Class> *)holoCellClsMap {
    return self.proxyData.cellClsMap;
}

@end
