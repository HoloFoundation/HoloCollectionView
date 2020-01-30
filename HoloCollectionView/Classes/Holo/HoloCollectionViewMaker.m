//
//  HoloCollectionViewMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/1/30.
//

#import "HoloCollectionViewMaker.h"

@interface HoloCollectionViewMaker ()

@property (nonatomic, copy) NSArray *sectionIndexTitlesArray;

@property (nonatomic, copy) NSIndexPath *(^indexPathForIndexTitleBlock)(NSString *title, NSInteger index);

@end

@implementation HoloCollectionViewMaker

- (HoloCollectionViewMaker * (^)(NSArray<NSString *> *))sectionIndexTitles {
    return ^id(id obj) {
        self.sectionIndexTitlesArray = obj;
        return self;
    };
}

- (HoloCollectionViewMaker *(^)(NSIndexPath *(^)(NSString *, NSInteger)))indexPathForIndexTitleHandler {
    return ^id(id obj) {
        self.indexPathForIndexTitleBlock = obj;
        return self;
    };
}

- (NSDictionary *)install {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    dict[kHoloSectionIndexTitles] = self.sectionIndexTitlesArray;
    dict[kHoloIndexPathForIndexTitleHandler] = self.indexPathForIndexTitleBlock;
    return [dict copy];
}

@end
