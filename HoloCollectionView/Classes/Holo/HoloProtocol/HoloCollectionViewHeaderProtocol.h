//
//  HoloCollectionViewHeaderProtocol.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloCollectionViewHeaderProtocol <NSObject>

@required

- (void)holo_configureHeaderWithModel:(id _Nullable)model;


@optional

+ (CGSize)holo_sizeForHeaderWithModel:(id _Nullable)model;

- (void)holo_willDisplayHeaderWithModel:(id _Nullable)model;

- (void)holo_didEndDisplayingHeaderWithModel:(id _Nullable)model;

@end

NS_ASSUME_NONNULL_END
