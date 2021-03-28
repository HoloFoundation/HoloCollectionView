//
//  HoloCollectionSection.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>
@class HoloCollectionItem;

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionSection : NSObject

/**
 *  Set the items for the section using the `items` property.
 */
@property (nonatomic, copy) NSArray<HoloCollectionItem *> *items;

/**
 *  Set the tag for the section using the `tag` property.
 */
@property (nonatomic, copy, nullable) NSString *tag;

/**
 *  Header class.
 */
@property (nonatomic, assign, nullable) Class header;

/**
 *  Footer class.
 */
@property (nonatomic, assign, nullable) Class footer;

/**
 *  Set the data for the header using the `headerModel` property.
 *
 *  If the `headerModelHandler` property is nil, then use the `headerModel` property.
 */
@property (nonatomic, strong, nullable) id headerModel;
@property (nonatomic, copy, nullable) id (^headerModelHandler)(void);

/**
 *  Set the data for the footer using the `footerModel` property.
 *
 *  If the `footerModelHandler` property is nil, then use the `footerModel` property.
 */
@property (nonatomic, strong, nullable) id footerModel;
@property (nonatomic, copy, nullable) id (^footerModelHandler)(void);

/**
 * The header must implement the `headerConfigSEL` property setting method in order for the HoloTableView to pass the model for the header.
 */
@property (nonatomic, assign) SEL headerConfigSEL;

/**
 * The footer must implement the `footerConfigSEL` property setting method in order for the HoloTableView to pass the model for the footer.
 */
@property (nonatomic, assign) SEL footerConfigSEL;

/**
 *  Set the reuse identifier for the header using the `headerReuseId` property.
 *
 *  If the `headerReuseIdHandler` property is nil, then use the `headerReuseId` property.
 */
@property (nonatomic, copy, nullable) NSString *headerReuseId;
@property (nonatomic, copy, nullable) NSString *(^headerReuseIdHandler)(id _Nullable model);

/**
 *  Set the reuse identifier for the footer using the `footerReuseId` property.
 *
 *  If the `footerReuseIdHandler` property is nil, then use the `footerReuseId` property.
 */
@property (nonatomic, copy, nullable) NSString *footerReuseId;
@property (nonatomic, copy, nullable) NSString *(^footerReuseIdHandler)(id _Nullable model);

/**
 *  Set the section inset using the `inset` property.
 *
 *  If the `insetHandler` property is nil, then use the `inset` property.
 */
@property (nonatomic, assign) UIEdgeInsets inset;
@property (nonatomic, copy, nullable) UIEdgeInsets (^insetHandler)(void);

/**
 *  Set the section minimum line spacing using the `minimumLineSpacing` property.
 *
 *  If the `minimumLineSpacingHandler` property is nil, then use the `inset` property.
 */
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, copy, nullable) CGFloat (^minimumLineSpacingHandler)(void);

/**
 *  Set the section minimum item spacing using the `minimumInteritemSpacing` property.
 *
 *  If the `minimumInteritemSpacingHandler` property is nil, then use the `minimumInteritemSpacing` property.
 */
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, copy, nullable) CGFloat (^minimumInteritemSpacingHandler)(void);

/**
 *  Set the size for the header using the `headerSize` property.
 *
 *  If the `headerSizeSEL` property is nil or the header don't implement the `headerSizeSEL` property setting method, then use the `headerSizeHandler` property.
 *  If the `headerSizeHandler` property is nil, then use the `headerSize` property.
 */
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, copy, nullable) CGSize (^headerSizeHandler)(id _Nullable model);
@property (nonatomic, assign) SEL headerSizeSEL;

/**
 *  Set the size for the footer using the `footerSize` property.
 *
 *  If the `footerSizeSEL` property is nil or the header don't implement the `footerSizeSEL` property setting method, then use the `footerSizeHandler` property.
 *  If the `footerSizeHandler` property is nil, then use the `footerSize` property.
 */
@property (nonatomic, assign) CGSize footerSize;
@property (nonatomic, copy, nullable) CGSize (^footerSizeHandler)(id _Nullable model);
@property (nonatomic, assign) SEL footerSizeSEL;

/**
 *  If the header will display, the `willDisplayHeaderHandler` will be called.
 *
 *  If the `willDisplayHeaderSEL` property is nil or the header don't implement the `willDisplayHeaderSEL` property setting method, then use the `willDisplayHeaderHandler` property.
 */
@property (nonatomic, copy, nullable) void (^willDisplayHeaderHandler)(UIView *header, id _Nullable model);
@property (nonatomic, assign) SEL willDisplayHeaderSEL;

/**
 *  If the footer will display, the `willDisplayFooterSEL` will be called.
 *
 *  If the `willDisplayFooterSEL` property is nil or the footer don't implement the `willDisplayFooterSEL` property setting method, then use the `willDisplayFooterHandler` property.
 */
@property (nonatomic, copy, nullable) void (^willDisplayFooterHandler)(UIView *footer, id _Nullable model);
@property (nonatomic, assign) SEL willDisplayFooterSEL;

/**
 *  If the header did end displaying, the `didEndDisplayingHeaderHandler` will be called.
 *
 *  If the `didEndDisplayingHeaderSEL` property is nil or the header don't implement the `didEndDisplayingHeaderSEL` property setting method, then use the `didEndDisplayingHeaderHandler` property.
 */
@property (nonatomic, copy, nullable) void (^didEndDisplayingHeaderHandler)(UIView *header, id _Nullable model);
@property (nonatomic, assign) SEL didEndDisplayingHeaderSEL;

/**
 *  If the footer did end displaying, the `didEndDisplayingFooterHandler` will be called.
 *
 *  If the `didEndDisplayingFooterSEL` property is nil or the footer don't implement the `didEndDisplayingFooterSEL` property setting method, then use the `didEndDisplayingFooterHandler` property.
 */
@property (nonatomic, copy, nullable) void (^didEndDisplayingFooterHandler)(UIView *footer, id _Nullable model);
@property (nonatomic, assign) SEL didEndDisplayingFooterSEL;



@property (nonatomic, assign) SEL headerFooterConfigSEL;
@property (nonatomic, assign) SEL headerFooterSizeSEL;


- (NSIndexSet *)insertItems:(NSArray<HoloCollectionItem *> *)items atIndex:(NSInteger)index;

- (void)removeItem:(HoloCollectionItem *)item;

- (void)removeAllItems;

@end

NS_ASSUME_NONNULL_END
