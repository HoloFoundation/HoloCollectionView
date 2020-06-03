//
//  HoloCollectionViewUpdateRowMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#import "HoloCollectionViewUpdateRowMaker.h"
#import "HoloCollectionRow.h"
#import "HoloCollectionSection.h"
#import "HoloCollectionRowMaker.h"

@implementation HoloCollectionViewUpdateRowMakerModel

@end


@interface HoloCollectionViewUpdateRowMaker ()

@property (nonatomic, copy) NSArray<HoloCollectionSection *> *dataSections;

@property (nonatomic, assign) HoloCollectionViewUpdateRowMakerType makerType;

@property (nonatomic, strong) NSMutableArray<HoloCollectionViewUpdateRowMakerModel *> *makerModels;

@end

@implementation HoloCollectionViewUpdateRowMaker

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections
                                makerType:(HoloCollectionViewUpdateRowMakerType)makerType {
    self = [super init];
    if (self) {
        _dataSections = sections;
        _makerType = makerType;
    }
    return self;
}

- (HoloCollectionRowMaker *(^)(NSString *))tag {
    return ^id(NSString *tag) {
        HoloCollectionRowMaker *rowMaker = [HoloCollectionRowMaker new];
        HoloCollectionRow *updateRow = [rowMaker fetchCollectionRow];
        updateRow.tag = tag;
        
        __block HoloCollectionRow *targetRow;
        __block NSIndexPath *operateIndexPath;
        [self.dataSections enumerateObjectsUsingBlock:^(HoloCollectionSection * _Nonnull section, NSUInteger sectionIdx, BOOL * _Nonnull sectionStop) {
            [section.rows enumerateObjectsUsingBlock:^(HoloCollectionRow * _Nonnull row, NSUInteger rowIdx, BOOL * _Nonnull rowStop) {
                if ([row.tag isEqualToString:tag] || (!row.tag && !tag)) {
                    targetRow = row;
                    operateIndexPath = [NSIndexPath indexPathForRow:rowIdx inSection:sectionIdx];
                    *rowStop = YES;
                    *sectionStop = YES;
                }
            }];
        }];
        
        if (targetRow && self.makerType == HoloCollectionViewUpdateRowMakerTypeUpdate) {
            [rowMaker giveCollectionRow:targetRow];
        }
        
        HoloCollectionViewUpdateRowMakerModel *makerModel = [HoloCollectionViewUpdateRowMakerModel new];
        makerModel.operateRow = [rowMaker fetchCollectionRow];
        makerModel.operateIndexPath = operateIndexPath;
        [self.makerModels addObject:makerModel];
        
        return rowMaker;
    };
}

- (NSArray<HoloCollectionViewUpdateRowMakerModel *> *)install {
    return self.makerModels.copy;
}

#pragma mark - getter
- (NSMutableArray<HoloCollectionViewUpdateRowMakerModel *> *)makerModels {
    if (!_makerModels) {
        _makerModels = [NSMutableArray new];
    }
    return _makerModels;
}

@end
