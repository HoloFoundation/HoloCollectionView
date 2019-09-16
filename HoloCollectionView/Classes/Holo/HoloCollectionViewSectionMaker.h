//
//  HoloCollectionViewSectionMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <Foundation/Foundation.h>
@class HoloCollectionRow;

NS_ASSUME_NONNULL_BEGIN

static NSString * const kHoloTargetSection = @"holo_target_section";
static NSString * const kHoloTargetIndex = @"holo_target_index";
static NSString * const kHoloUpdateSection = @"holo_update_section";
static NSString * const kHoloSectionTagNil = @"holo_section_tag_nil";


////////////////////////////////////////////////////////////
@interface HoloCollectionSection : NSObject

@property (nonatomic, copy, nullable) NSArray<HoloCollectionRow *> *rows;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) UIEdgeInsets inset;

@property (nonatomic, assign) CGFloat minimumLineSpacing;

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (nonatomic, strong) NSString *header;

@property (nonatomic, strong) NSString *footer;

@property (nonatomic, strong) id headerModel;

@property (nonatomic, strong) id footerModel;

@property (nonatomic, assign) CGSize headerSize;

@property (nonatomic, assign) CGSize footerSize;

@property (nonatomic, assign) SEL headerFooterConfigSEL;

@property (nonatomic, assign) SEL headerFooterSizeSEL;

@property (nonatomic, copy) void (^willDisplayHeaderHandler)(UIView *header, id model);

@property (nonatomic, copy) void (^willDisplayFooterHandler)(UIView *footer, id model);

@property (nonatomic, copy) void (^didEndDisplayingHeaderHandler)(UIView *header, id model);

@property (nonatomic, copy) void (^didEndDisplayingFooterHandler)(UIView *footer, id model);

- (NSIndexSet *)holo_insertRows:(NSArray<HoloCollectionRow *> *)rows atIndex:(NSInteger)index;

- (void)holo_removeRow:(HoloCollectionRow *)row;

- (void)holo_removeAllRows;

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionSectionMaker : NSObject

@property (nonatomic, strong, readonly) HoloCollectionSection *section;

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^inset)(UIEdgeInsets inset);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumLineSpacing)(CGFloat minimumLineSpacing);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumInteritemSpacing)(CGFloat minimumInteritemSpacing);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^header)(NSString *header);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footer)(NSString *footer);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerModel)(id headerModel);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerModel)(id footerModel);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerSize)(CGSize headerSize);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerSize)(CGSize footerSize);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerFooterConfigSEL)(SEL headerConfigSEL);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerFooterSizeSEL)(SEL headerSizeSEL);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayHeaderHandler)(void(^)(UIView *header, id model));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayFooterHandler)(void(^)(UIView *footer, id model));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingHeaderHandler)(void(^)(UIView *header, id model));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingFooterHandler)(void(^)(UIView *footer, id model));

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewSectionMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^section)(NSString *  _Nullable tag);

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections isRemark:(BOOL)isRemark;

- (NSArray<NSDictionary *> *)install;

@end

NS_ASSUME_NONNULL_END
