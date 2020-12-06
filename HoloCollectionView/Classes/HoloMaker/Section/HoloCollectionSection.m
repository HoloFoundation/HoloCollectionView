//
//  HoloCollectionSection.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import "HoloCollectionSection.h"

@implementation HoloCollectionSection

- (instancetype)init {
    self = [super init];
    if (self) {
        _rows = [NSArray new];
        _inset = UIEdgeInsetsMake(CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN);
        _headerSize = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        _footerSize = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        _minimumLineSpacing = CGFLOAT_MIN;
        _minimumInteritemSpacing = CGFLOAT_MIN;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _headerConfigSEL = @selector(holo_configureHeaderWithModel:);
        _footerConfigSEL = @selector(holo_configureFooterWithModel:);
        _headerSizeSEL = @selector(holo_sizeForHeaderWithModel:);
        _footerSizeSEL = @selector(holo_sizeForFooterWithModel:);
        
        _headerFooterConfigSEL = @selector(holo_configureHeaderFooterWithModel:);
        _headerFooterSizeSEL = @selector(holo_sizeForHeaderFooterWithModel:);
        
        _willDisplayHeaderSEL = @selector(holo_willDisplayHeaderWithModel:);
        _willDisplayFooterSEL = @selector(holo_sizeForFooterWithModel:);
        _didEndDisplayingHeaderSEL = @selector(holo_didEndDisplayingHeaderWithModel:);
        _didEndDisplayingFooterSEL = @selector(holo_didEndDisplayingFooterWithModel:);
#pragma clang diagnostic pop
    }
    return self;
}

- (NSIndexSet *)insertRows:(NSArray<HoloCollectionRow *> *)rows atIndex:(NSInteger)index {
    if (rows.count <= 0) return [NSIndexSet new];
    
    if (index < 0) index = 0;
    if (index > self.rows.count) index = self.rows.count;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, rows.count)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.rows];
    [array insertObjects:rows atIndexes:indexSet];
    self.rows = array;
    return indexSet;
}

- (void)removeRow:(HoloCollectionRow *)row {
    if (!row) return;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.rows];
    [array removeObject:row];
    self.rows = array;
}

- (void)removeAllRows {
    self.rows = [NSArray new];
}

@end
