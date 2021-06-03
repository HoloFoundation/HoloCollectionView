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
        _items = [NSArray new];
        _header = UICollectionReusableView.class;
        _footer = UICollectionReusableView.class;
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
                
        _willDisplayHeaderSEL = @selector(holo_willDisplayHeaderWithModel:);
        _willDisplayFooterSEL = @selector(holo_sizeForFooterWithModel:);
        _didEndDisplayingHeaderSEL = @selector(holo_didEndDisplayingHeaderWithModel:);
        _didEndDisplayingFooterSEL = @selector(holo_didEndDisplayingFooterWithModel:);
#pragma clang diagnostic pop
    }
    return self;
}

- (void)addItem:(HoloCollectionItem *)item {
    if (!item) return;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
    [array addObject:item];
    self.items = array;
}

- (void)removeItem:(HoloCollectionItem *)item {
    if (!item) return;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
    [array removeObject:item];
    self.items = array;
}

- (void)removeAllItems {
    self.items = [NSArray new];
}

- (void)insertItem:(HoloCollectionItem *)item atIndex:(NSInteger)index {
    if (!item) return;
    
    if (index < 0) index = 0;
    if (index > self.items.count) index = self.items.count;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
    [array insertObject:item atIndex:index];
    self.items = array;
}

@end
