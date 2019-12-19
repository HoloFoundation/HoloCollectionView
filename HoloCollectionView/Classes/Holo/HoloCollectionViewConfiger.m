//
//  HoloCollectionViewConfiger.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#import "HoloCollectionViewConfiger.h"

////////////////////////////////////////////////////////////
@interface HoloCollectionViewCellConfiger ()

@property (nonatomic, copy) NSString *row;

@property (nonatomic, copy) NSString *rowName;

@end

@implementation HoloCollectionViewCellConfiger

- (HoloCollectionViewCellConfiger *(^)(Class))cls {
    return ^id(Class cls) {
        self.rowName = NSStringFromClass(cls);
        return self;
    };
}

- (HoloCollectionViewCellConfiger * (^)(NSString *))clsName {
    return ^id(id obj) {
        self.rowName = obj;
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

- (HoloCollectionViewCellConfiger * (^)(NSString *))row {
    return ^id(id obj) {
        HoloCollectionViewCellConfiger *configer = [HoloCollectionViewCellConfiger new];
        configer.row = obj;
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
        cellClsMap[configer.row] = configer.rowName;
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
