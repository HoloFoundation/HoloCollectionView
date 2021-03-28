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

@property (nonatomic, copy) NSArray<HoloCollectionItem *> *items;

@property (nonatomic, copy, nullable) NSString *tag;

@property (nonatomic, assign, nullable) Class header;

@property (nonatomic, assign, nullable) Class footer;

@property (nonatomic, copy, nullable) NSString *headerReuseId;

@property (nonatomic, copy, nullable) NSString *footerReuseId;


#pragma mark - priority low
@property (nonatomic, assign) UIEdgeInsets inset;

@property (nonatomic, assign) CGFloat minimumLineSpacing;

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (nonatomic, strong, nullable) id headerModel;

@property (nonatomic, strong, nullable) id footerModel;

@property (nonatomic, assign) CGSize headerSize;

@property (nonatomic, assign) CGSize footerSize;

#pragma mark - priority middle
@property (nonatomic, copy, nullable) UIEdgeInsets (^insetHandler)(void);

@property (nonatomic, copy, nullable) CGFloat (^minimumLineSpacingHandler)(void);

@property (nonatomic, copy, nullable) CGFloat (^minimumInteritemSpacingHandler)(void);

@property (nonatomic, copy, nullable) id (^headerModelHandler)(void);

@property (nonatomic, copy, nullable) id (^footerModelHandler)(void);

@property (nonatomic, copy, nullable) NSString *(^headerReuseIdHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) NSString *(^footerReuseIdHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) CGSize (^headerSizeHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) CGSize (^footerSizeHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) void (^willDisplayHeaderHandler)(UIView *header, id _Nullable model);

@property (nonatomic, copy, nullable) void (^willDisplayFooterHandler)(UIView *footer, id _Nullable model);

@property (nonatomic, copy, nullable) void (^didEndDisplayingHeaderHandler)(UIView *header, id _Nullable model);

@property (nonatomic, copy, nullable) void (^didEndDisplayingFooterHandler)(UIView *footer, id _Nullable model);

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


- (NSIndexSet *)insertItems:(NSArray<HoloCollectionItem *> *)items atIndex:(NSInteger)index;

- (void)removeItem:(HoloCollectionItem *)item;

- (void)removeAllItems;

@end

NS_ASSUME_NONNULL_END
