//
//  HoloCollectionViewMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/1/30.
//

#import <Foundation/Foundation.h>
#import "HoloCollectionViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSIndexPath * _Nullable (^HoloCollectionViewSectionForSectionIndexTitleHandler)(NSString *title, NSInteger index);

/// RHFMap: ItemHeaderFooterMap
@interface HoloCollectionViewRHFMap : NSObject

@property (nonatomic, copy, readonly) void (^map)(Class cls);

@end

/// RHFMapMaker: ItemHeaderFooterMaker
@interface HoloCollectionViewRHFMapMaker : NSObject

@end


@interface HoloCollectionViewItemMapMaker : HoloCollectionViewRHFMapMaker

@property (nonatomic, copy, readonly) HoloCollectionViewRHFMap *(^item)(NSString *item);

@end


@interface HoloCollectionViewHeaderMapMaker : HoloCollectionViewRHFMapMaker

@property (nonatomic, copy, readonly) HoloCollectionViewRHFMap *(^header)(NSString *header);

@end


@interface HoloCollectionViewFooterMapMaker : HoloCollectionViewRHFMapMaker

@property (nonatomic, copy, readonly) HoloCollectionViewRHFMap *(^footer)(NSString *footer);

@end


@interface HoloCollectionViewModel : NSObject

@property (nonatomic, copy, nullable) NSArray *indexTitles;

@property (nonatomic, copy, nullable) HoloCollectionViewSectionForSectionIndexTitleHandler indexTitlesHandler;

@property (nonatomic, weak, nullable) id<HoloCollectionViewDelegateFlowLayout> delegate;

@property (nonatomic, weak, nullable) id<HoloCollectionViewDataSource> dataSource;

@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> scrollDelegate;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, Class> *itemsMap;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, Class> *headersMap;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, Class> *footersMap;

@end


@interface HoloCollectionViewMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^sectionIndexTitles)(NSArray<NSString *> *sectionIndexTitles);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^indexPathForIndexTitleHandler)(NSIndexPath *(^handler)(NSString *title, NSInteger index));

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^delegate)(id<HoloCollectionViewDelegateFlowLayout> delegate);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^dataSource)(id<HoloCollectionViewDataSource> dataSource);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^scrollDelegate)(id<UIScrollViewDelegate> scrollDelegate);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^makeItemsMap)(void(NS_NOESCAPE ^)(HoloCollectionViewItemMapMaker *make));

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^makeHeadersMap)(void(NS_NOESCAPE ^)(HoloCollectionViewHeaderMapMaker *make));

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^makeFootersMap)(void(NS_NOESCAPE ^)(HoloCollectionViewFooterMapMaker *make));

- (HoloCollectionViewModel *)install;

@end
NS_ASSUME_NONNULL_END
