//
//  HoloCollectionSectionMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>
@class HoloCollectionSection, HoloCollectionViewItemMaker, HoloCollectionViewRowMaker;

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionSectionMaker : NSObject

/**
 *  Header class.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^header)(Class header);

/**
 *  Footer class.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footer)(Class footer);

/**
 *  Set the data for the header using the `headerModel` property.
 *
 *  If the `headerModelHandler` property is nil, then use the `headerModel` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerModel)(id headerModel);
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerModelHandler)(id (^)(void));

/**
 *  Set the data for the footer using the `footerModel` property.
 *
 *  If the `footerModelHandler` property is nil, then use the `footerModel` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerModel)(id footerModel);
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerModelHandler)(id (^)(void));

/**
 * The header must implement the `headerConfigSEL` property setting method in order for the HoloTableView to pass the model for the header.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerConfigSEL)(SEL headerConfigSEL);

/**
 * The footer must implement the `footerConfigSEL` property setting method in order for the HoloTableView to pass the model for the footer.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerConfigSEL)(SEL footerConfigSEL);

/**
 *  Set the reuse identifier for the header using the `headerReuseId` property.
 *
 *  If the `headerReuseIdHandler` property is nil, then use the `headerReuseId` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerReuseId)(NSString *headerReuseId);
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerReuseIdHandler)(NSString *(^)(id _Nullable model));

/**
 *  Set the reuse identifier for the footer using the `footerReuseId` property.
 *
 *  If the `footerReuseIdHandler` property is nil, then use the `footerReuseId` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerReuseId)(NSString *footerReuseId);
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerReuseIdHandler)(NSString *(^)(id _Nullable model));

/**
 *  Set the section inset using the `inset` property.
 *
 *  If the `insetHandler` property is nil, then use the `inset` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^inset)(UIEdgeInsets inset);
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^insetHandler)(UIEdgeInsets (^)(void));

/**
 *  Set the section minimum line spacing using the `minimumLineSpacing` property.
 *
 *  If the `minimumLineSpacingHandler` property is nil, then use the `inset` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumLineSpacing)(CGFloat minimumLineSpacing);
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumLineSpacingHandler)(CGFloat (^)(void));

/**
 *  Set the section minimum item spacing using the `minimumInteritemSpacing` property.
 *
 *  If the `minimumInteritemSpacingHandler` property is nil, then use the `minimumInteritemSpacing` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumInteritemSpacing)(CGFloat minimumInteritemSpacing);
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^minimumInteritemSpacingHandler)(CGFloat (^)(void));

/**
 *  Set the size for the header using the `headerSize` property.
 *
 *  If the `headerSizeSEL` property is nil or the header don't implement the `headerSizeSEL` property setting method, then use the `headerSizeHandler` property.
 *  If the `headerSizeHandler` property is nil, then use the `headerSize` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerSize)(CGSize headerSize);
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerSizeHandler)(CGSize (^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^headerSizeSEL)(SEL headerSizeSEL);

/**
 *  Set the size for the footer using the `footerSize` property.
 *
 *  If the `footerSizeSEL` property is nil or the header don't implement the `footerSizeSEL` property setting method, then use the `footerSizeHandler` property.
 *  If the `footerSizeHandler` property is nil, then use the `footerSize` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerSize)(CGSize footerSize);
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerSizeHandler)(CGSize (^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^footerSizeSEL)(SEL footerSizeSEL);

/**
 *  If the header will display, the `willDisplayHeaderHandler` will be called.
 *
 *  If the `willDisplayHeaderSEL` property is nil or the header don't implement the `willDisplayHeaderSEL` property setting method, then use the `willDisplayHeaderHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayHeaderHandler)(void(^)(UIView *header, id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayHeaderSEL)(SEL willDisplayHeaderSEL);

/**
 *  If the footer will display, the `willDisplayFooterSEL` will be called.
 *
 *  If the `willDisplayFooterSEL` property is nil or the footer don't implement the `willDisplayFooterSEL` property setting method, then use the `willDisplayFooterHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayFooterHandler)(void(^)(UIView *footer, id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^willDisplayFooterSEL)(SEL willDisplayFooterSEL);

/**
 *  If the header did end displaying, the `didEndDisplayingHeaderHandler` will be called.
 *
 *  If the `didEndDisplayingHeaderSEL` property is nil or the header don't implement the `didEndDisplayingHeaderSEL` property setting method, then use the `didEndDisplayingHeaderHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingHeaderHandler)(void(^)(UIView *header, id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingHeaderSEL)(SEL didEndDisplayingHeaderSEL);

/**
 *  If the footer did end displaying, the `didEndDisplayingFooterHandler` will be called.
 *
 *  If the `didEndDisplayingFooterSEL` property is nil or the footer don't implement the `didEndDisplayingFooterSEL` property setting method, then use the `didEndDisplayingFooterHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingFooterHandler)(void(^)(UIView *footer, id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^didEndDisplayingFooterSEL)(SEL didEndDisplayingFooterSEL);


@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^makeItems)(void(NS_NOESCAPE ^)(HoloCollectionViewItemMaker *make));

@property (nonatomic, copy, readonly) HoloCollectionSectionMaker *(^makeRows)(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make)) DEPRECATED_MSG_ATTRIBUTE("Please use `makeItems` api instead.");


- (HoloCollectionSection *)fetchCollectionSection;

- (void)giveCollectionSection:(HoloCollectionSection *)section;

@end

NS_ASSUME_NONNULL_END
