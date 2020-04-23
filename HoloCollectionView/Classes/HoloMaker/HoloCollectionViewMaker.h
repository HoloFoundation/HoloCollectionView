//
//  HoloCollectionViewMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/1/30.
//

#import <Foundation/Foundation.h>
#import "HoloCollectionViewProxy.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSIndexPath * _Nullable (^HoloCollectionViewSectionForSectionIndexTitleHandler)(NSString *title, NSInteger index);

////////////////////////////////////////////////////////////
@interface HoloCollectionViewRHFMap : NSObject // RHFMap: RowHeaderFooterMap

@property (nonatomic, copy, readonly) void (^map)(Class cls);

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewRHFMapMaker : NSObject // RHFMapMaker: RowHeaderFooterMaker

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewRowMapMaker : HoloCollectionViewRHFMapMaker

@property (nonatomic, copy, readonly) HoloCollectionViewRHFMap *(^row)(NSString *row);

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewHeaderMapMaker : HoloCollectionViewRHFMapMaker

@property (nonatomic, copy, readonly) HoloCollectionViewRHFMap *(^header)(NSString *header);

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewFooterMapMaker : HoloCollectionViewRHFMapMaker

@property (nonatomic, copy, readonly) HoloCollectionViewRHFMap *(^footer)(NSString *footer);

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewModel : NSObject

@property (nonatomic, copy) NSArray *indexTitles;

@property (nonatomic, copy) HoloCollectionViewSectionForSectionIndexTitleHandler indexTitlesHandler;

@property (nonatomic, strong) id<HoloCollectionViewDelegateFlowLayout> delegate;

@property (nonatomic, strong) id<HoloCollectionViewDataSource> dataSource;

@property (nonatomic, strong) id<UIScrollViewDelegate> scrollDelegate;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *rowsMap;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *headersMap;

@property (nonatomic, copy) NSDictionary<NSString *, Class> *footersMap;

@end

////////////////////////////////////////////////////////////
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
