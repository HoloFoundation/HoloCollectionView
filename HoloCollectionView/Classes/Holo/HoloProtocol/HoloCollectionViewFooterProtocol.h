//
//  HoloCollectionViewFooterProtocol.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloCollectionViewFooterProtocol <NSObject>

@required

- (void)holo_configureFooterWithModel:(id _Nullable)model;


@optional

+ (CGSize)holo_sizeForFooterWithModel:(id _Nullable)model;

- (void)holo_willDisplayFooterWithModel:(id _Nullable)model;

- (void)holo_didEndDisplayingFooterWithModel:(id _Nullable)model;

@end

NS_ASSUME_NONNULL_END
