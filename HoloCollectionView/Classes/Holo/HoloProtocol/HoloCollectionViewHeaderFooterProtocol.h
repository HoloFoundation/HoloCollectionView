//
//  HoloCollectionViewHeaderFooterProtocol.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloCollectionViewHeaderFooterProtocol <NSObject>

@optional

- (void)holo_configureHeaderFooterWithModel:(id)model DEPRECATED_MSG_ATTRIBUTE("Please use `headerConfigSEL` or `footerConfigSEL` api instead.");

+ (CGSize)holo_sizeForHeaderFooterWithModel:(id)model DEPRECATED_MSG_ATTRIBUTE("Please use `headerSizeSEL` or `footerSizeSEL` api instead.");

@end

NS_ASSUME_NONNULL_END
