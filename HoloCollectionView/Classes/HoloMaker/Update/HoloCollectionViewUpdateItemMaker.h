//
//  HoloCollectionViewUpdateItemMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2021/2/16.
//

#import <Foundation/Foundation.h>
@class HoloCollectionItem, HoloCollectionSection, HoloCollectionItemMaker;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HoloCollectionViewUpdateItemMakerType) {
    HoloCollectionViewUpdateItemMakerTypeUpdate,
    HoloCollectionViewUpdateItemMakerTypeRemake
};


@interface HoloCollectionViewUpdateItemMakerModel : NSObject

@property (nonatomic, strong, nullable) HoloCollectionItem *operateItem;

@property (nonatomic, strong, nullable) NSIndexPath *operateIndexPath;

@end


@interface HoloCollectionViewUpdateItemMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^tag)(NSString *tag);

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections
                                makerType:(HoloCollectionViewUpdateItemMakerType)makerType;

- (NSArray<HoloCollectionViewUpdateItemMakerModel *> *)install;

@end

NS_ASSUME_NONNULL_END
