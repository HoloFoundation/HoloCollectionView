//
//  HoloCollectionViewConfiger.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#import "HoloCollectionViewConfiger.h"

@interface HoloCollectionViewConfiger ()

@property (nonatomic, copy) NSArray *sectionIndexTitlesArray;

@property (nonatomic, copy) NSIndexPath *(^indexPathForIndexTitleBlock)(NSString *title, NSInteger index);

@end

@implementation HoloCollectionViewConfiger

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
    
    dict[kHoloSectionIndexTitles] = self.sectionIndexTitlesArray;
    dict[kHoloIndexPathForIndexTitleHandler] = self.indexPathForIndexTitleBlock;
    return [dict copy];
}

@end
