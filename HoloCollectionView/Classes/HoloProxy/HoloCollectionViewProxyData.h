//
//  HoloCollectionViewProxyData.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <Foundation/Foundation.h>
@class HoloCollectionSection;

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionViewProxyData : NSObject

@property (nonatomic, copy) NSArray<HoloCollectionSection *> *sections;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *itemsMap;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *headersMap;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *footersMap;

@property (nonatomic, copy, nullable) NSArray<NSString *> *sectionIndexTitles;

@property (nonatomic, copy, nullable) NSIndexPath *(^indexPathForIndexTitleHandler)(NSString *title, NSInteger index);

- (NSIndexSet *)insertSections:(NSArray<HoloCollectionSection *> *)sections anIndex:(NSInteger)index;

- (NSIndexSet *)removeAllSection;

- (NSIndexSet *)removeSections:(NSArray<NSString *> *)tags;

- (HoloCollectionSection * _Nullable)sectionWithTag:(NSString * _Nullable)tag;

- (NSArray<NSIndexPath *> *)removeAllItemsInSections:(NSArray<NSString *> *)tags;

- (NSArray<NSIndexPath *> *)removeItems:(NSArray<NSString *> *)tags;

@end

NS_ASSUME_NONNULL_END
