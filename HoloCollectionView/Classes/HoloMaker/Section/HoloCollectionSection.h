//
//  HoloCollectionSection.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>
@class HoloCollectionRow;

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
