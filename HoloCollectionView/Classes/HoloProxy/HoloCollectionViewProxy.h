//
//  HoloCollectionViewProxy.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <Foundation/Foundation.h>
#import "HoloCollectionViewProtocol.h"
@class HoloCollectionViewProxyData;

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionViewProxy : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@property (nonatomic, strong) HoloCollectionViewProxyData *proxyData;

@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> scrollDelegate;

@property (nonatomic, weak, nullable) id<HoloCollectionViewDataSource> dataSource;

@property (nonatomic, weak, nullable) id<HoloCollectionViewDelegateFlowLayout> delegate;

@end

NS_ASSUME_NONNULL_END
