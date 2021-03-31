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

/**
 *  Datasource of current UICollectionView.
 */
@property (nonatomic, copy) NSArray<HoloCollectionSection *> *sections;

/**
 *  Return list of section titles to display in section index view (e.g. "ABCD...Z#").
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *sectionIndexTitles;

/**
 *  Tell table which section corresponds to section title/index (e.g. "B",1)).
 */
@property (nonatomic, copy, nullable) NSIndexPath *(^indexPathForIndexTitleHandler)(NSString *title, NSInteger index);


@property (nonatomic, copy) NSDictionary<NSString *, Class> *itemsMap;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *headersMap;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *footersMap;

@end

NS_ASSUME_NONNULL_END
