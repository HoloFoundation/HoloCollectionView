//
//  HoloCollectionViewSectionMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewSectionMaker.h"
#import <objc/runtime.h>
#import "HoloCollectionViewRowMaker.h"

////////////////////////////////////////////////////////////
@implementation HoloCollectionSection

- (instancetype)init {
    self = [super init];
    if (self) {
        _rows = [NSArray new];
        _inset = UIEdgeInsetsMake(CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN);
        _headerSize = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        _footerSize = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        _minimumLineSpacing = CGFLOAT_MIN;
        _minimumInteritemSpacing = CGFLOAT_MIN;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _headerFooterConfigSEL = @selector(holo_configureHeaderFooterWithModel:);
        _headerFooterSizeSEL = @selector(holo_sizeForHeaderFooterWithModel:);
#pragma clang diagnostic pop
    }
    return self;
}

- (NSIndexSet *)insertRows:(NSArray<HoloCollectionRow *> *)rows atIndex:(NSInteger)index {
    if (rows.count <= 0) return nil;
    
    if (index < 0) index = 0;
    if (index > self.rows.count) index = self.rows.count;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, rows.count)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.rows];
    [array insertObjects:rows atIndexes:indexSet];
    self.rows = array;
    return indexSet;
}

- (void)removeRow:(HoloCollectionRow *)row {
    if (!row) return;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.rows];
    [array removeObject:row];
    self.rows = array;
}

- (void)removeAllRows {
    self.rows = [NSArray new];
}

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionSectionMaker ()

@property (nonatomic, strong) HoloCollectionSection *section;

@end

@implementation HoloCollectionSectionMaker

- (HoloCollectionSectionMaker * (^)(UIEdgeInsets))inset {
    return ^id(UIEdgeInsets i) {
        self.section.inset = i;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(Class))header {
    return ^id(Class cls) {
        self.section.header = NSStringFromClass(cls);
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(Class))footer {
    return ^id(Class cls) {
        self.section.footer = NSStringFromClass(cls);
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(NSString *))headerS {
    return ^id(id obj) {
        self.section.header = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(NSString *))footerS {
    return ^id(id obj) {
        self.section.footer = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(id))headerModel {
    return ^id(id obj) {
        self.section.headerModel = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(id))footerModel {
    return ^id(id obj) {
        self.section.footerModel = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(CGSize))headerSize {
    return ^id(CGSize s) {
        self.section.headerSize = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(CGSize))footerSize {
    return ^id(CGSize s) {
        self.section.footerSize = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(SEL))headerFooterConfigSEL {
    return ^id(SEL s) {
        self.section.headerFooterConfigSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(SEL))headerFooterSizeSEL {
    return ^id(SEL s) {
        self.section.headerFooterSizeSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(void (^)(UIView *, id)))willDisplayHeaderHandler {
    return ^id(id obj) {
        self.section.willDisplayHeaderHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(void (^)(UIView *, id)))willDisplayFooterHandler {
    return ^id(id obj) {
        self.section.willDisplayFooterHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(void (^)(UIView *, id)))didEndDisplayingHeaderHandler {
    return ^id(id obj) {
        self.section.didEndDisplayingHeaderHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(void (^)(UIView *, id)))didEndDisplayingFooterHandler {
    return ^id(id obj) {
        self.section.didEndDisplayingFooterHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *)))makeRows {
    return ^id(void(^block)(HoloCollectionViewRowMaker *make)) {
        HoloCollectionViewRowMaker *maker = [HoloCollectionViewRowMaker new];
        if (block) block(maker);
        
        [self.section insertRows:[maker install] atIndex:NSIntegerMax];
        return self;
    };
}

#pragma mark - getter
- (HoloCollectionSection *)section {
    if (!_section) {
        _section = [HoloCollectionSection new];
    }
    return _section;
}

@end


////////////////////////////////////////////////////////////
@implementation HoloCollectionViewSectionMakerModel

@end

////////////////////////////////////////////////////////////
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
        sectionMaker.section.tag = tag;
        
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
            sectionMaker.section = targetSection;
        }
        
        HoloCollectionViewSectionMakerModel *makerModel = [HoloCollectionViewSectionMakerModel new];
        makerModel.operateSection = sectionMaker.section;
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
