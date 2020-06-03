//
//  HoloCollectionViewCellProtocol.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloCollectionViewCellProtocol <NSObject>

@optional

- (void)holo_configureCellWithModel:(id)model;

+ (CGSize)holo_sizeForCellWithModel:(id)model;

- (BOOL)holo_shouldHighlightForCellWithModel:(id)model;

- (BOOL)holo_shouldSelectForCellWithModel:(id)model;

- (BOOL)holo_shouldDeselectForCellWithModel:(id)model;

- (BOOL)holo_canMoveForCellWithModel:(id)model;

- (void)holo_didSelectCellWithModel:(id)model;

- (void)holo_didDeselectCellWithModel:(id)model;

- (void)holo_willDisplayCellWithModel:(id)model;

- (void)holo_didEndDisplayingCellWithModel:(id)model;

- (void)holo_didHighlightCellWithModel:(id)model;

- (void)holo_didUnHighlightCellWithModel:(id)model;

@end


NS_ASSUME_NONNULL_END
