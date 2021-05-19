//
//  HoloCollectionViewSectionMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewSectionMaker.h"
#import "HoloCollectionSection.h"
#import "HoloCollectionSectionMaker.h"

@implementation HoloCollectionViewSectionMakerModel

@end


@interface HoloCollectionViewSectionMaker ()

@property (nonatomic, copy) NSArray<HoloCollectionSection *> *dataSections;

@property (nonatomic, assign) HoloCollectionViewSectionMakerType makerType;

@property (nonatomic, strong) NSMutableArray<HoloCollectionViewSectionMakerModel *> *makerModels;

@end

@implementation HoloCollectionViewSectionMaker

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections
                                makerType:(HoloCollectionViewSectionMakerType)makerType {
    self = [super init];
    if (self) {
        _dataSections = sections;
        _makerType = makerType;
    }
    return self;
}

- (HoloCollectionSectionMaker *(^)(NSString *))section {
    return ^id(NSString *tag) {
        HoloCollectionSectionMaker *sectionMaker = [HoloCollectionSectionMaker new];
        HoloCollectionSection *makerSection = [sectionMaker fetchCollectionSection];
        makerSection.tag = tag;
        
        __block NSNumber *operateIndex = nil;
        if (self.makerType == HoloCollectionViewSectionMakerTypeUpdate || self.makerType == HoloCollectionViewSectionMakerTypeRemake) {
            [self.dataSections enumerateObjectsUsingBlock:^(HoloCollectionSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([section.tag isEqualToString:tag] || (!section.tag && !tag)) {
                    operateIndex = @(idx);
                    
                    if (self.makerType == HoloCollectionViewSectionMakerTypeUpdate) {
                        // update: set the item object to maker from datasource
                        [sectionMaker giveCollectionSection:section];
                    }
                    
                    *stop = YES;
                }
            }];
        }
        
        HoloCollectionViewSectionMakerModel *makerModel = [HoloCollectionViewSectionMakerModel new];
        makerModel.operateSection = [sectionMaker fetchCollectionSection];
        makerModel.operateIndex = operateIndex;
        [self.makerModels addObject:makerModel];
        
        return sectionMaker;
    };
}

- (NSArray<HoloCollectionViewSectionMakerModel *> *)install {
    return self.makerModels.copy;
}

#pragma mark - getter
- (NSMutableArray<HoloCollectionViewSectionMakerModel *> *)makerModels {
    if (!_makerModels) {
        _makerModels = [NSMutableArray new];
    }
    return _makerModels;
}

@end
