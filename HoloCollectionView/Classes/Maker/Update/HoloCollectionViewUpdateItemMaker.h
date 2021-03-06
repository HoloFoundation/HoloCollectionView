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


@interface HoloCollectionViewUpdateItemMaker : NSObject

/**
 *  Fetch a HoloCollectionItem object with the tag.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^tag)(NSString *tag);

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections
                                makerType:(HoloCollectionViewUpdateItemMakerType)makerType
                            targetSection:(BOOL)targetSection
                               sectionTag:(NSString * _Nullable)sectionTag;

- (NSArray<NSIndexPath *> *)install;

@end

NS_ASSUME_NONNULL_END
