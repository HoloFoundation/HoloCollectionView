//
//  HoloCollectionViewCellProtocol.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloCollectionViewCellProtocol <NSObject>

@required

- (void)holo_configureCellWithModel:(id _Nullable)model;


@optional

+ (CGSize)holo_sizeForCellWithModel:(id _Nullable)model;

- (BOOL)holo_shouldHighlightForCellWithModel:(id _Nullable)model;

- (BOOL)holo_shouldSelectForCellWithModel:(id _Nullable)model;

- (BOOL)holo_shouldDeselectForCellWithModel:(id _Nullable)model;

- (void)holo_didSelectCellWithModel:(id _Nullable)model;

- (void)holo_didDeselectCellWithModel:(id _Nullable)model;

- (void)holo_willDisplayCellWithModel:(id _Nullable)model;

- (void)holo_didEndDisplayingCellWithModel:(id _Nullable)model;

- (void)holo_didHighlightCellWithModel:(id _Nullable)model;

- (void)holo_didUnHighlightCellWithModel:(id _Nullable)model;

@end


NS_ASSUME_NONNULL_END
