//
//  HoloCollectionViewMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/1/30.
//

#import "HoloCollectionViewMaker.h"

////////////////////////////////////////////////////////////
@implementation HoloCollectionViewRowMapMaker

@end

////////////////////////////////////////////////////////////
@implementation HoloCollectionViewHeaderMapMaker

@end

////////////////////////////////////////////////////////////
@implementation HoloCollectionViewFooterMapMaker

@end

////////////////////////////////////////////////////////////
@implementation HoloCollectionViewModel

@end

////////////////////////////////////////////////////////////
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
        
//        [self.section insertRows:[maker install] atIndex:NSIntegerMax];
        return self;
    };
}

- (HoloCollectionViewMaker * (^)(void (NS_NOESCAPE ^)(HoloCollectionViewHeaderMapMaker *)))makeHeadersMap {
    return ^id(void(^block)(HoloCollectionViewHeaderMapMaker *make)) {
        HoloCollectionViewHeaderMapMaker *maker = [HoloCollectionViewHeaderMapMaker new];
        if (block) block(maker);
        
//        [self.section insertRows:[maker install] atIndex:NSIntegerMax];
        return self;
    };
}

- (HoloCollectionViewMaker * (^)(void (NS_NOESCAPE ^)(HoloCollectionViewFooterMapMaker *)))makeFootersMap {
    return ^id(void(^block)(HoloCollectionViewFooterMapMaker *make)) {
        HoloCollectionViewFooterMapMaker *maker = [HoloCollectionViewFooterMapMaker new];
        if (block) block(maker);
        
//        [self.section insertRows:[maker install] atIndex:NSIntegerMax];
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
