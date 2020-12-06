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

/// RHFMap: RowHeaderFooterMap
@interface HoloCollectionViewRHFMap : NSObject

@property (nonatomic, copy, readonly) void (^map)(Class cls);

@end

/// RHFMapMaker: RowHeaderFooterMaker
@interface HoloCollectionViewRHFMapMaker : NSObject

@end


@interface HoloCollectionViewRowMapMaker : HoloCollectionViewRHFMapMaker

@property (nonatomic, copy, readonly) HoloCollectionViewRHFMap *(^row)(NSString *row);

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

@property (nonatomic, copy, nullable) NSDictionary<NSString *, Class> *rowsMap;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, Class> *headersMap;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, Class> *footersMap;

@end


@interface HoloCollectionViewMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^sectionIndexTitles)(NSArray<NSString *> *sectionIndexTitles);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^indexPathForIndexTitleHandler)(NSIndexPath *(^handler)(NSString *title, NSInteger index));

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^delegate)(id<HoloCollectionViewDelegateFlowLayout> delegate);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^dataSource)(id<HoloCollectionViewDataSource> dataSource);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^scrollDelegate)(id<UIScrollViewDelegate> scrollDelegate);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^makeRowsMap)(void(NS_NOESCAPE ^)(HoloCollectionViewRowMapMaker *make));

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^makeHeadersMap)(void(NS_NOESCAPE ^)(HoloCollectionViewHeaderMapMaker *make));

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^makeFootersMap)(void(NS_NOESCAPE ^)(HoloCollectionViewFooterMapMaker *make));

- (HoloCollectionViewModel *)install;

@end
NS_ASSUME_NONNULL_END
