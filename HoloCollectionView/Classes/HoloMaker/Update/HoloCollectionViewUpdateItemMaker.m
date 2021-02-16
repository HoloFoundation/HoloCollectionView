//
//  HoloCollectionViewUpdateItemMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2021/2/16.
//

#import "HoloCollectionViewUpdateItemMaker.h"
#import "HoloCollectionItem.h"
#import "HoloCollectionSection.h"
#import "HoloCollectionItemMaker.h"

@implementation HoloCollectionViewUpdateItemMakerModel

@end


@interface HoloCollectionViewUpdateItemMaker ()

@property (nonatomic, copy) NSArray<HoloCollectionSection *> *dataSections;

@property (nonatomic, assign) HoloCollectionViewUpdateItemMakerType makerType;

@property (nonatomic, strong) NSMutableArray<HoloCollectionViewUpdateItemMakerModel *> *makerModels;

@end

@implementation HoloCollectionViewUpdateItemMaker

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections
                                makerType:(HoloCollectionViewUpdateItemMakerType)makerType {
    self = [super init];
    if (self) {
        _dataSections = sections;
        _makerType = makerType;
    }
    return self;
}

- (HoloCollectionItemMaker *(^)(NSString *))tag {
    return ^id(NSString *tag) {
        HoloCollectionItemMaker *itemMaker = [HoloCollectionItemMaker new];
        HoloCollectionItem *updateItem = [itemMaker fetchCollectionItem];
        updateItem.tag = tag;
        
        __block HoloCollectionItem *targetItem;
        __block NSIndexPath *operateIndexPath;
        [self.dataSections enumerateObjectsUsingBlock:^(HoloCollectionSection * _Nonnull section, NSUInteger sectionIdx, BOOL * _Nonnull sectionStop) {
            [section.items enumerateObjectsUsingBlock:^(HoloCollectionItem * _Nonnull item, NSUInteger itemIdx, BOOL * _Nonnull itemStop) {
                if ([item.tag isEqualToString:tag] || (!item.tag && !tag)) {
                    targetItem = item;
                    operateIndexPath = [NSIndexPath indexPathForItem:itemIdx inSection:sectionIdx];
                    *itemStop = YES;
                    *sectionStop = YES;
                }
            }];
        }];
        
        if (targetItem && self.makerType == HoloCollectionViewUpdateItemMakerTypeUpdate) {
            [itemMaker giveCollectionItem:targetItem];
        }
        
        HoloCollectionViewUpdateItemMakerModel *makerModel = [HoloCollectionViewUpdateItemMakerModel new];
        makerModel.operateItem = [itemMaker fetchCollectionItem];
        makerModel.operateIndexPath = operateIndexPath;
        [self.makerModels addObject:makerModel];
        
        return itemMaker;
    };
}

- (NSArray<HoloCollectionViewUpdateItemMakerModel *> *)install {
    return self.makerModels.copy;
}

#pragma mark - getter
- (NSMutableArray<HoloCollectionViewUpdateItemMakerModel *> *)makerModels {
    if (!_makerModels) {
        _makerModels = [NSMutableArray new];
    }
    return _makerModels;
}

@end
