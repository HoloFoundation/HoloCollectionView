//
//  HoloCollectionViewRowMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <Foundation/Foundation.h>
@class HoloCollectionItem, HoloCollectionItemMaker;

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionViewRowMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^row)(Class row);

- (NSArray<HoloCollectionItem *> *)install;

@end

NS_ASSUME_NONNULL_END
