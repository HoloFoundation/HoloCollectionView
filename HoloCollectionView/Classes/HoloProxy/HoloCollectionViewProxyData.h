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

@property (nonatomic, copy) NSDictionary<NSString *, Class> *rowsMap;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *headerFootersMap;

@property (nonatomic, copy) NSArray<NSString *> *sectionIndexTitles;

@property (nonatomic, copy) NSIndexPath *(^indexPathForIndexTitleHandler)(NSString *title, NSInteger index);

- (NSIndexSet *)insertSections:(NSArray<HoloCollectionSection *> *)sections anIndex:(NSInteger)index;

- (NSIndexSet *)removeAllSection;

- (NSIndexSet *)removeSections:(NSArray<NSString *> *)tags;

- (HoloCollectionSection *)sectionWithTag:(NSString * _Nullable)tag;

- (NSArray<NSIndexPath *> *)removeAllRowsInSections:(NSArray<NSString *> *)tags;

- (NSArray<NSIndexPath *> *)removeRows:(NSArray<NSString *> *)tags;

@end

NS_ASSUME_NONNULL_END
