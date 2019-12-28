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

static NSString * const kHoloTargetRow = @"holo_target_row";
static NSString * const kHoloTargetIndexPath = @"holo_target_indexPath";
static NSString * const kHoloUpdateRow = @"holo_update_row";
static NSString * const kHoloRowTagNil = @"holo_row_tag_nil";


////////////////////////////////////////////////////////////
@interface HoloUpdateCollectionRowMaker : HoloCollectionRowMaker

@property (nonatomic, copy, readonly) HoloUpdateCollectionRowMaker *(^row)(NSString *rowName);

@property (nonatomic, copy, readonly) HoloUpdateCollectionRowMaker *(^rowCls)(Class rowCls);

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewUpdateRowMaker : NSObject

@property (nonatomic, copy, readonly) HoloUpdateCollectionRowMaker *(^tag)(NSString * _Nullable tag);

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections isRemark:(BOOL)isRemark;

- (NSArray<NSDictionary *> *)install;

@end

NS_ASSUME_NONNULL_END
