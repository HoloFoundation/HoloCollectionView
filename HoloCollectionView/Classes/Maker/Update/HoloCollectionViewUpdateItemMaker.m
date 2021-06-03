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
#import "HoloCollectionViewMacro.h"

@interface HoloCollectionViewUpdateItemMaker ()

@property (nonatomic, copy) NSArray<HoloCollectionSection *> *dataSections;

@property (nonatomic, assign) HoloCollectionViewUpdateItemMakerType makerType;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *updateIndexPaths;

// has target section or not
@property (nonatomic, assign) BOOL targetSection;
// target section tag
@property (nonatomic, copy) NSString *sectionTag;

@end

@implementation HoloCollectionViewUpdateItemMaker

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections
                                makerType:(HoloCollectionViewUpdateItemMakerType)makerType
                            targetSection:(BOOL)targetSection
                               sectionTag:(NSString * _Nullable)sectionTag {
    self = [super init];
    if (self) {
        _dataSections = sections;
        _makerType = makerType;
        _targetSection = targetSection;
        _sectionTag = sectionTag;
    }
    return self;
}

- (HoloCollectionItemMaker *(^)(NSString *))tag {
    return ^id(NSString *tag) {
        HoloCollectionItemMaker *itemMaker = [HoloCollectionItemMaker new];
        HoloCollectionItem *makerItem = [itemMaker fetchCollectionItem];
        makerItem.tag = tag;
        
        __block NSIndexPath *operateIndexPath = nil;
        [self.dataSections enumerateObjectsUsingBlock:^(HoloCollectionSection * _Nonnull section, NSUInteger sectionIdx, BOOL * _Nonnull sectionStop) {
            if (self.targetSection && !([section.tag isEqualToString:self.sectionTag] || (!section.tag && !self.sectionTag))) {
                return;
            }
            [section.items enumerateObjectsUsingBlock:^(HoloCollectionItem * _Nonnull item, NSUInteger itemIdx, BOOL * _Nonnull itemStop) {
                if ([item.tag isEqualToString:tag] || (!item.tag && !tag)) {
                    operateIndexPath = [NSIndexPath indexPathForItem:itemIdx inSection:sectionIdx];
                    
                    if (self.makerType == HoloCollectionViewUpdateItemMakerTypeUpdate) {
                        // update: set the item object to maker from datasource
                        [itemMaker giveCollectionItem:item];
                    } else if (self.makerType == HoloCollectionViewUpdateItemMakerTypeRemake) {
                        // remake: set the item object to datasource from maker
                        NSMutableArray *items = [NSMutableArray arrayWithArray:section.items];
                        [items replaceObjectAtIndex:operateIndexPath.item withObject:makerItem];
                        section.items = items.copy;
                    }
                    
                    *itemStop = YES;
                    *sectionStop = YES;
                }
            }];
        }];
        
        if (operateIndexPath) {
            [self.updateIndexPaths addObject:operateIndexPath];
        } else {
            HoloLog(@"[HoloCollectionView] No item found with the tag: `%@`.", tag);
        }
        
        return itemMaker;
    };
}

- (NSArray<NSIndexPath *> *)install {
    return self.updateIndexPaths.copy;
}

#pragma mark - getter
- (NSMutableArray<NSIndexPath *> *)updateIndexPaths {
    if (!_updateIndexPaths) {
        _updateIndexPaths = [NSMutableArray new];
    }
    return _updateIndexPaths;
}

@end
