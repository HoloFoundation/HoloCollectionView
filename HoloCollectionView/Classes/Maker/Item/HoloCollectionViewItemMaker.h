//
//  HoloCollectionViewItemMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2021/2/16.
//

#import <Foundation/Foundation.h>
@class HoloCollectionItem, HoloCollectionItemMaker;

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionViewItemMaker : NSObject

/**
 * Make a HoloCollectionRow object and set the cell class.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^item)(Class item);

- (NSArray<HoloCollectionItem *> *)install;

@end

NS_ASSUME_NONNULL_END
