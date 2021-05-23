//
//  HoloCollectionItem.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import "HoloCollectionItem.h"

@implementation HoloCollectionItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _size = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        _shouldHighlight = YES;
        _shouldSelect = YES;
        _shouldDeselect = YES;
        _canMove = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _configSEL = @selector(holo_configureCellWithModel:);
        _sizeSEL = @selector(holo_sizeForCellWithModel:);
        _shouldHighlightSEL = @selector(holo_shouldHighlightForCellWithModel:);
        _shouldSelectSEL = @selector(holo_shouldSelectForCellWithModel:);
        _shouldDeselectSEL = @selector(holo_shouldDeselectForCellWithModel:);
        _didSelectSEL = @selector(holo_didSelectCellWithModel:);
        _didDeselectSEL = @selector(holo_didDeselectCellWithModel:);
        _willDisplaySEL = @selector(holo_willDisplayCellWithModel:);
        _didEndDisplayingSEL = @selector(holo_didEndDisplayingCellWithModel:);
        _didHighlightSEL = @selector(holo_didHighlightCellWithModel:);
        _didUnHighlightSEL = @selector(holo_didUnHighlightCellWithModel:);
#pragma clang diagnostic pop
    }
    
    return self;
}

@end
