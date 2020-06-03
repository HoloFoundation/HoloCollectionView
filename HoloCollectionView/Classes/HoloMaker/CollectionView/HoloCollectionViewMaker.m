//
//  HoloCollectionViewMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/1/30.
//

#import "HoloCollectionViewMaker.h"

@interface HoloCollectionViewRHFMap ()

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) Class cls;

@end

@implementation HoloCollectionViewRHFMap

- (void (^)(Class))map {
    return ^(Class cls) {
        self.cls = cls;
    };
}

@end


@interface HoloCollectionViewRHFMapMaker ()

@property (nonatomic, strong) NSMutableArray<HoloCollectionViewRHFMap *> *mapArray;

@end

@implementation HoloCollectionViewRHFMapMaker

- (NSDictionary<NSString *, Class> *)install {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [self.mapArray enumerateObjectsUsingBlock:^(HoloCollectionViewRHFMap * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.key) dict[obj.key] = obj.cls;
    }];
    return dict.copy;
}

#pragma mark - getter
- (NSMutableArray<HoloCollectionViewRHFMap *> *)mapArray {
    if (!_mapArray) {
        _mapArray = [NSMutableArray new];
    }
    return _mapArray;
}

@end


@implementation HoloCollectionViewRowMapMaker

- (HoloCollectionViewRHFMap * (^)(NSString *))row {
    return ^id(id obj) {
        HoloCollectionViewRHFMap *map = [HoloCollectionViewRHFMap new];
        map.key = obj;
        [self.mapArray addObject:map];
        return map;
    };
}

@end


@implementation HoloCollectionViewHeaderMapMaker

- (HoloCollectionViewRHFMap * (^)(NSString *))header {
    return ^id(id obj) {
        HoloCollectionViewRHFMap *map = [HoloCollectionViewRHFMap new];
        map.key = obj;
        [self.mapArray addObject:map];
        return map;
    };
}

@end


@implementation HoloCollectionViewFooterMapMaker

- (HoloCollectionViewRHFMap * (^)(NSString *))footer {
    return ^id(id obj) {
        HoloCollectionViewRHFMap *map = [HoloCollectionViewRHFMap new];
        map.key = obj;
        [self.mapArray addObject:map];
        return map;
    };
}

@end


@implementation HoloCollectionViewModel

@end


@interface HoloCollectionViewMaker ()

@property (nonatomic, strong) HoloCollectionViewModel *collectionViewModel;

@end

@implementation HoloCollectionViewMaker

- (HoloCollectionViewMaker * (^)(NSArray<NSString *> *))sectionIndexTitles {
    return ^id(id obj) {
        self.collectionViewModel.indexTitles = obj;
        return self;
    };
}

- (HoloCollectionViewMaker *(^)(NSIndexPath *(^)(NSString *, NSInteger)))indexPathForIndexTitleHandler {
    return ^id(id obj) {
        self.collectionViewModel.indexTitlesHandler = obj;
        return self;
    };
}

- (HoloCollectionViewMaker * (^)(id<HoloCollectionViewDelegateFlowLayout>))delegate {
    return ^id(id obj) {
        self.collectionViewModel.delegate = obj;
        return self;
    };
}

- (HoloCollectionViewMaker * (^)(id<HoloCollectionViewDataSource>))dataSource {
    return ^id(id obj) {
        self.collectionViewModel.dataSource = obj;
        return self;
    };
}

- (HoloCollectionViewMaker * (^)(id<UIScrollViewDelegate>))scrollDelegate {
    return ^id(id obj) {
        self.collectionViewModel.scrollDelegate = obj;
        return self;
    };
}

- (HoloCollectionViewMaker * (^)(void (NS_NOESCAPE ^)(HoloCollectionViewRowMapMaker *)))makeRowsMap {
    return ^id(void(^block)(HoloCollectionViewRowMapMaker *make)) {
        HoloCollectionViewRowMapMaker *maker = [HoloCollectionViewRowMapMaker new];
        if (block) block(maker);
        
        self.collectionViewModel.rowsMap = [maker install];
        return self;
    };
}

- (HoloCollectionViewMaker * (^)(void (NS_NOESCAPE ^)(HoloCollectionViewHeaderMapMaker *)))makeHeadersMap {
    return ^id(void(^block)(HoloCollectionViewHeaderMapMaker *make)) {
        HoloCollectionViewHeaderMapMaker *maker = [HoloCollectionViewHeaderMapMaker new];
        if (block) block(maker);
        
        self.collectionViewModel.headersMap = [maker install];
        return self;
    };
}

- (HoloCollectionViewMaker * (^)(void (NS_NOESCAPE ^)(HoloCollectionViewFooterMapMaker *)))makeFootersMap {
    return ^id(void(^block)(HoloCollectionViewFooterMapMaker *make)) {
        HoloCollectionViewFooterMapMaker *maker = [HoloCollectionViewFooterMapMaker new];
        if (block) block(maker);
        
        self.collectionViewModel.footersMap = [maker install];
        return self;
    };
}

- (HoloCollectionViewModel *)install {
    return self.collectionViewModel;
}

#pragma mark - getter
- (HoloCollectionViewModel *)collectionViewModel {
    if (!_collectionViewModel) {
        _collectionViewModel = [HoloCollectionViewModel new];
    }
    return _collectionViewModel;
}

@end
