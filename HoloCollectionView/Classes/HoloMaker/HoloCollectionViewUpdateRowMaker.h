//
//  HoloCollectionViewUpdateRowMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#import <Foundation/Foundation.h>
#import "HoloCollectionViewRowMaker.h"
@class HoloCollectionSection;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HoloCollectionViewUpdateRowMakerType) {
    HoloCollectionViewUpdateRowMakerTypeUpdate,
    HoloCollectionViewUpdateRowMakerTypeRemake
};

////////////////////////////////////////////////////////////
@interface HoloCollectionViewUpdateRowMakerModel : NSObject

@property (nonatomic, strong) HoloCollectionRow *operateRow;

@property (nonatomic, strong) NSIndexPath *operateIndexPath;

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewUpdateRowMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^tag)(NSString *tag);

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections
                                makerType:(HoloCollectionViewUpdateRowMakerType)makerType;

- (NSArray<HoloCollectionViewUpdateRowMakerModel *> *)install;

@end

NS_ASSUME_NONNULL_END
