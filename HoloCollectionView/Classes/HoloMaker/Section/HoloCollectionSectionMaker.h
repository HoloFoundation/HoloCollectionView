//
//  HoloCollectionSectionMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>
@class HoloCollectionSection, HoloCollectionViewRowMaker;

NS_ASSUME_NONNULL_BEGIN

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

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerReuseIdHandler)(NSString *(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerReuseIdHandler)(NSString *(^)(id _Nullable model));

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


- (HoloCollectionSection *)fetchCollectionSection;

- (void)giveCollectionSection:(HoloCollectionSection *)section;

@end

NS_ASSUME_NONNULL_END
