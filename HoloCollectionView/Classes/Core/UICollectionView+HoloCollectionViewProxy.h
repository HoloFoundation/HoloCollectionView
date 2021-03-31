//
//  UICollectionView+HoloCollectionViewProxy.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <UIKit/UIKit.h>
@class HoloCollectionSection, HoloCollectionViewProxy;

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (HoloCollectionViewProxy)

/**
 *  Datasource of current UITableView.
 */
@property (nonatomic, copy) NSArray<HoloCollectionSection *> *holo_sections;

/**
 *  Return list of section titles to display in section index view (e.g. "ABCD...Z#").
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *holo_sectionIndexTitles;

/**
 *  Tell table which section corresponds to section title/index (e.g. "B",1)).
 */
@property (nonatomic, copy, nullable) NSIndexPath *(^holo_indexPathForIndexTitleHandler)(NSString *title, NSInteger index);

/**
 *  The delegate of the scroll-view object.
 */
@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> holo_scrollDelegate;

/**
 *  Proxy of current UITableView.
 */
@property (nonatomic, strong, readonly) HoloCollectionViewProxy *holo_proxy;

@end

NS_ASSUME_NONNULL_END
