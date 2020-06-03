//
//  HoloCollectionViewRowMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <Foundation/Foundation.h>
@class HoloCollectionRow, HoloCollectionRowMaker;

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionViewRowMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^row)(Class row);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^rowS)(NSString *rowString);

- (NSArray<HoloCollectionRow *> *)install;

@end

NS_ASSUME_NONNULL_END
