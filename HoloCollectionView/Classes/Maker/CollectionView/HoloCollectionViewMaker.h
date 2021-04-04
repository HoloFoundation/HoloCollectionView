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


@interface HoloCollectionViewModel : NSObject

@property (nonatomic, copy, nullable) NSArray *indexTitles;

@property (nonatomic, copy, nullable) HoloCollectionViewSectionForSectionIndexTitleHandler indexTitlesHandler;

@property (nonatomic, weak, nullable) id<HoloCollectionViewDelegateFlowLayout> delegate;

@property (nonatomic, weak, nullable) id<HoloCollectionViewDataSource> dataSource;

@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> scrollDelegate;

@end


@interface HoloCollectionViewMaker : NSObject

/**
 *  Return list of section titles to display in section index view (e.g. "ABCD...Z#").
 */
@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^sectionIndexTitles)(NSArray<NSString *> *sectionIndexTitles);

/**
 *  Tell table which section corresponds to section title/index (e.g. "B",1)).
 */
@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^indexPathForIndexTitleHandler)(NSIndexPath *(^handler)(NSString *title, NSInteger index));

/**
 *  The delegate of the scroll-view object.
 */
@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^scrollDelegate)(id<UIScrollViewDelegate> scrollDelegate);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^delegate)(id<HoloCollectionViewDelegateFlowLayout> delegate);

@property (nonatomic, copy, readonly) HoloCollectionViewMaker *(^dataSource)(id<HoloCollectionViewDataSource> dataSource);

- (HoloCollectionViewModel *)install;

@end
NS_ASSUME_NONNULL_END
