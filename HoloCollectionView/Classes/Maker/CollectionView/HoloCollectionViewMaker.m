//
//  HoloCollectionViewMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/1/30.
//

#import "HoloCollectionViewMaker.h"

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
