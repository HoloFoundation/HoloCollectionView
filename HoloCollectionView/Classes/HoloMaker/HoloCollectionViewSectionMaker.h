//
//  HoloCollectionViewSectionMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <Foundation/Foundation.h>
@class HoloCollectionRow, HoloCollectionViewRowMaker;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HoloCollectionViewSectionMakerType) {
    HoloCollectionViewSectionMakerTypeMake,
    HoloCollectionViewSectionMakerTypeInsert,
    HoloCollectionViewSectionMakerTypeUpdate,
    HoloCollectionViewSectionMakerTypeRemake
};

////////////////////////////////////////////////////////////
@interface HoloCollectionSection : NSObject

@property (nonatomic, copy, nullable) NSArray<HoloCollectionRow *> *rows;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *header;

@property (nonatomic, copy) NSString *footer;

@property (nonatomic, copy) NSString *headerReuseId;

@property (nonatomic, copy) NSString *footerReuseId;


#pragma mark - priority low
@property (nonatomic, assign) UIEdgeInsets inset;

@property (nonatomic, assign) CGFloat minimumLineSpacing;

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (nonatomic, strong) id headerModel;

@property (nonatomic, strong) id footerModel;

@property (nonatomic, assign) CGSize headerSize;

@property (nonatomic, assign) CGSize footerSize;

#pragma mark - priority middle
@property (nonatomic, copy) UIEdgeInsets (^insetHandler)(void);

@property (nonatomic, copy) CGFloat (^minimumLineSpacingHandler)(void);

@property (nonatomic, copy) CGFloat (^minimumInteritemSpacingHandler)(void);

@property (nonatomic, copy) id (^headerModelHandler)(void);

@property (nonatomic, copy) id (^footerModelHandler)(void);

@property (nonatomic, copy) CGSize (^headerSizeHandler)(id _Nullable model);

@property (nonatomic, copy) CGSize (^footerSizeHandler)(id _Nullable model);

@property (nonatomic, copy) void (^willDisplayHeaderHandler)(UIView *header, id _Nullable model);

@property (nonatomic, copy) void (^willDisplayFooterHandler)(UIView *footer, id _Nullable model);

@property (nonatomic, copy) void (^didEndDisplayingHeaderHandler)(UIView *header, id _Nullable model);

@property (nonatomic, copy) void (^didEndDisplayingFooterHandler)(UIView *footer, id _Nullable model);

#pragma mark - priority high
@property (nonatomic, assign) SEL headerConfigSEL;

@property (nonatomic, assign) SEL footerConfigSEL;

@property (nonatomic, assign) SEL headerSizeSEL;

@property (nonatomic, assign) SEL footerSizeSEL;

@property (nonatomic, assign) SEL headerFooterConfigSEL;
@property (nonatomic, assign) SEL headerFooterSizeSEL;

@property (nonatomic, assign) SEL willDisplayHeaderSEL;

@property (nonatomic, assign) SEL willDisplayFooterSEL;

@property (nonatomic, assign) SEL didEndDisplayingHeaderSEL;

@property (nonatomic, assign) SEL didEndDisplayingFooterSEL;


- (NSIndexSet *)insertRows:(NSArray<HoloCollectionRow *> *)rows atIndex:(NSInteger)index;

- (void)removeRow:(HoloCollectionRow *)row;

- (void)removeAllRows;

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionSectionMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^header)(Class header);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footer)(Class footer);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerS)(NSString *headerString);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerS)(NSString *footerString);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerReuseId)(NSString *headerReuseId);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerReuseId)(NSString *footerReuseId);

#pragma mark - priority low
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^inset)(UIEdgeInsets inset);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumLineSpacing)(CGFloat minimumLineSpacing);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumInteritemSpacing)(CGFloat minimumInteritemSpacing);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerModel)(id headerModel);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerModel)(id footerModel);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerSize)(CGSize headerSize);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerSize)(CGSize footerSize);

#pragma mark - priority middle
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^insetHandler)(UIEdgeInsets (^)(void));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumLineSpacingHandler)(CGFloat (^)(void));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumInteritemSpacingHandler)(CGFloat (^)(void));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerModelHandler)(id (^)(void));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerModelHandler)(id (^)(void));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerSizeHandler)(CGSize (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerSizeHandler)(CGSize (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayHeaderHandler)(void(^)(UIView *header, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayFooterHandler)(void(^)(UIView *footer, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingHeaderHandler)(void(^)(UIView *header, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingFooterHandler)(void(^)(UIView *footer, id _Nullable model));

#pragma mark - priority high
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerConfigSEL)(SEL headerConfigSEL);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerConfigSEL)(SEL footerConfigSEL);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerSizeSEL)(SEL headerSizeSEL);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerSizeSEL)(SEL footerSizeSEL);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerFooterConfigSEL)(SEL headerFooterConfigSEL) DEPRECATED_MSG_ATTRIBUTE("Please use `headerConfigSEL` or `footerConfigSEL` api instead.");
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerFooterSizeSEL)(SEL headerFooterSizeSEL) DEPRECATED_MSG_ATTRIBUTE("Please use `headerSizeSEL` or `footerSizeSEL` api instead.");

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayHeaderSEL)(SEL willDisplayHeaderSEL);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayFooterSEL)(SEL willDisplayFooterSEL);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingHeaderSEL)(SEL didEndDisplayingHeaderSEL);

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingFooterSEL)(SEL didEndDisplayingFooterSEL);


@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^makeRows)(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make));

@end


////////////////////////////////////////////////////////////
@interface HoloCollectionViewSectionMakerModel : NSObject

@property (nonatomic, strong) HoloCollectionSection *operateSection;

@property (nonatomic, strong) NSNumber *operateIndex;

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewSectionMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^section)(NSString *tag);

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections
                                makerType:(HoloCollectionViewSectionMakerType)makerType;

- (NSArray<HoloCollectionViewSectionMakerModel *> *)install;

@end

NS_ASSUME_NONNULL_END
