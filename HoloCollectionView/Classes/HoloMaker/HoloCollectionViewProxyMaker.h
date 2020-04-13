//
//  HoloCollectionViewProxyMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/4/14.
//

#import <Foundation/Foundation.h>
#import "HoloCollectionViewProxy.h"

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////
@interface HoloCollectionViewProxyModel : NSObject

@property (nonatomic, strong) id<HoloCollectionViewDelegateFlowLayout> delegate;

@property (nonatomic, strong) id<HoloCollectionViewDataSource> dataSource;

@property (nonatomic, strong) id<UIScrollViewDelegate> scrollDelegate;

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewProxyMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionViewProxyMaker *(^delegate)(id<HoloCollectionViewDelegateFlowLayout> delegate);

@property (nonatomic, copy, readonly) HoloCollectionViewProxyMaker *(^dataSource)(id<HoloCollectionViewDataSource> dataSource);

@property (nonatomic, copy, readonly) HoloCollectionViewProxyMaker *(^scrollDelegate)(id<UIScrollViewDelegate> scrollDelegate);

- (HoloCollectionViewProxyModel *)install;

@end

NS_ASSUME_NONNULL_END
