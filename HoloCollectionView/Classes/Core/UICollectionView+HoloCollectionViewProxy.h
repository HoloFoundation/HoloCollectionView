//
//  UICollectionView+HoloCollectionViewProxy.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <UIKit/UIKit.h>
@class HoloCollectionViewProxy;

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (HoloCollectionViewProxy)

@property (nonatomic, strong, readonly) HoloCollectionViewProxy *holo_proxy;

@end

NS_ASSUME_NONNULL_END
