//
//  HoloCollectionViewConfiger.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#import "HoloCollectionViewConfiger.h"

////////////////////////////////////////////////////////////
@implementation HoloCollectionViewCellConfiger

- (HoloCollectionViewCellConfiger *(^)(NSString *))cls {
    return ^id(id obj) {
        self.clsName = obj;
        return self;
    };
}

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewConfiger ()

@property (nonatomic, strong) NSMutableArray *cellClsConfigers;

@property (nonatomic, copy) NSArray *sectionIndexTitlesArray;

@property (nonatomic, copy) NSIndexPath *(^indexPathForIndexTitleBlock)(NSString *title, NSInteger index);

@end

@implementation HoloCollectionViewConfiger

- (HoloCollectionViewCellConfiger *(^)(NSString *))cell {
    return ^id(id obj) {
        HoloCollectionViewCellConfiger *configer = [HoloCollectionViewCellConfiger new];
        configer.cellName = obj;
        [self.cellClsConfigers addObject:configer];
        return configer;
    };
}

- (HoloCollectionViewConfiger * (^)(NSArray<NSString *> *))sectionIndexTitles {
    return ^id(id obj) {
        self.sectionIndexTitlesArray = obj;
        return self;
    };
}

- (HoloCollectionViewConfiger *(^)(NSIndexPath *(^)(NSString *, NSInteger)))indexPathForIndexTitleHandler {
    return ^id(id obj) {
        self.indexPathForIndexTitleBlock = obj;
        return self;
    };
}

- (NSDictionary *)install {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    NSMutableDictionary *cellClsMap = [NSMutableDictionary new];
    for (HoloCollectionViewCellConfiger *configer in self.cellClsConfigers) {
        cellClsMap[configer.cellName] = configer.clsName;
    }
    dict[kHoloCellClsMap] = [cellClsMap copy];
    dict[kHoloSectionIndexTitles] = self.sectionIndexTitlesArray;
    dict[kHoloIndexPathForIndexTitleHandler] = self.indexPathForIndexTitleBlock;
    return [dict copy];
}

#pragma mark - getter
- (NSMutableArray *)cellClsConfigers {
    if (!_cellClsConfigers) {
        _cellClsConfigers = [NSMutableArray new];
    }
    return _cellClsConfigers;
}

@end
