//
//  HoloCollectionViewUpdateRowMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#import <Foundation/Foundation.h>
@class HoloCollectionSection, HoloCollectionRowMaker;

NS_ASSUME_NONNULL_BEGIN

static NSString * const kHoloTargetRow = @"holo_target_row";
static NSString * const kHoloTargetIndexPath = @"holo_target_indexPath";
static NSString * const kHoloUpdateRow = @"holo_update_row";
static NSString * const kHoloRowTagNil = @"holo_row_tag_nil";


////////////////////////////////////////////////////////////
@interface HoloCollectionViewUpdateRowMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^tag)(NSString *tag);

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections isRemark:(BOOL)isRemark;

- (NSArray<NSDictionary *> *)install;

@end

NS_ASSUME_NONNULL_END
