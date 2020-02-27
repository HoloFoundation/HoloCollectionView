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

@property (nonatomic, copy) NSArray<HoloCollectionSection *> *holo_sections;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *holo_cellClsMap;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *holo_headerFooterMap;

@property (nonatomic, copy) NSArray<NSString *> *holo_sectionIndexTitles;

@property (nonatomic, copy) NSIndexPath *(^holo_indexPathForIndexTitleHandler)(NSString *title, NSInteger index);

- (NSIndexSet *)holo_insertSections:(NSArray<HoloCollectionSection *> *)sections anIndex:(NSInteger)index;

- (NSIndexSet *)holo_removeAllSection;

- (NSIndexSet *)holo_removeSections:(NSArray<NSString *> *)tags;

- (HoloCollectionSection *)holo_sectionWithTag:(NSString * _Nullable)tag;

- (NSArray<NSIndexPath *> *)holo_removeAllRowsInSection:(NSString *)tag;

- (NSArray<NSIndexPath *> *)holo_removeRows:(NSArray<NSString *> *)tags;

@end

NS_ASSUME_NONNULL_END
