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
        HoloCollectionSection *section = [sectionMaker fetchCollectionSection];
        section.tag = tag;
        
        __block HoloCollectionSection *targetSection;
        __block NSNumber *operateIndex;
        if (self.makerType == HoloCollectionViewSectionMakerTypeUpdate || self.makerType == HoloCollectionViewSectionMakerTypeRemake) {
            [self.dataSections enumerateObjectsUsingBlock:^(HoloCollectionSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.tag isEqualToString:tag] || (!obj.tag && !tag)) {
                    targetSection = obj;
                    operateIndex = @(idx);
                    *stop = YES;
                }
            }];
        }
        
        if (targetSection && self.makerType == HoloCollectionViewSectionMakerTypeUpdate) {
            section = targetSection;
        }
        
        HoloCollectionViewSectionMakerModel *makerModel = [HoloCollectionViewSectionMakerModel new];
        makerModel.operateSection = section;
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
