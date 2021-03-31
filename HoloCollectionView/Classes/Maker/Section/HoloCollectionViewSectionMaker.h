//
//  HoloCollectionViewSectionMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <Foundation/Foundation.h>
@class HoloCollectionSection, HoloCollectionSectionMaker;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HoloCollectionViewSectionMakerType) {
    HoloCollectionViewSectionMakerTypeMake,
    HoloCollectionViewSectionMakerTypeInsert,
    HoloCollectionViewSectionMakerTypeUpdate,
    HoloCollectionViewSectionMakerTypeRemake
};


@interface HoloCollectionViewSectionMakerModel : NSObject

@property (nonatomic, strong, nullable) HoloCollectionSection *operateSection;

@property (nonatomic, strong, nullable) NSNumber *operateIndex;

@end


@interface HoloCollectionViewSectionMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^section)(NSString *tag);

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections
                                makerType:(HoloCollectionViewSectionMakerType)makerType;

- (NSArray<HoloCollectionViewSectionMakerModel *> *)install;

@end

NS_ASSUME_NONNULL_END
