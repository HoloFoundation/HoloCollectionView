//
//  HoloCollectionViewSectionMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewSectionMaker.h"
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
        _headerConfigSEL = @selector(holo_configureHeaderWithModel:);
        _footerConfigSEL = @selector(holo_configureFooterWithModel:);
        _headerSizeSEL = @selector(holo_sizeForHeaderWithModel:);
        _footerSizeSEL = @selector(holo_sizeForFooterWithModel:);
        
        _headerFooterConfigSEL = @selector(holo_configureHeaderFooterWithModel:);
        _headerFooterSizeSEL = @selector(holo_sizeForHeaderFooterWithModel:);
        
        _willDisplayHeaderSEL = @selector(holo_willDisplayHeaderWithModel:);
        _willDisplayFooterSEL = @selector(holo_sizeForFooterWithModel:);
        _didEndDisplayingHeaderSEL = @selector(holo_didEndDisplayingHeaderWithModel:);
        _didEndDisplayingFooterSEL = @selector(holo_didEndDisplayingFooterWithModel:);
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

- (HoloCollectionSectionMaker * (^)(Class))header {
    return ^id(Class cls) {
        self.section.header = NSStringFromClass(cls);
        // headerReuseId is equal to header by default
        if (self.section.headerReuseId.length <= 0) self.section.headerReuseId = self.section.header;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(Class))footer {
    return ^id(Class cls) {
        self.section.footer = NSStringFromClass(cls);
        // footerReuseId is equal to footer by default
        if (self.section.footerReuseId.length <= 0) self.section.footerReuseId = self.section.footer;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(NSString *))headerS {
    return ^id(id obj) {
        self.section.header = obj;
        // headerReuseId is equal to header by default
        if (self.section.headerReuseId.length <= 0) self.section.headerReuseId = self.section.header;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(NSString *))footerS {
    return ^id(id obj) {
        self.section.footer = obj;
        // footerReuseId is equal to footer by default
        if (self.section.footerReuseId.length <= 0) self.section.footerReuseId = self.section.footer;
        return self;
    };
}


- (HoloCollectionSectionMaker *(^)(NSString *))headerReuseId {
    return ^id(id obj) {
        self.section.headerReuseId = obj;
        return self;
    };
}


- (HoloCollectionSectionMaker *(^)(NSString *))footerReuseId {
    return ^id(id obj) {
        self.section.footerReuseId = obj;
        return self;
    };
}


#pragma mark - priority low
- (HoloCollectionSectionMaker * (^)(UIEdgeInsets))inset {
    return ^id(UIEdgeInsets i) {
        self.section.inset = i;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(CGFloat))minimumLineSpacing {
    return ^id(CGFloat f) {
        self.section.minimumLineSpacing = f;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(CGFloat))minimumInteritemSpacing {
    return ^id(CGFloat f) {
        self.section.minimumInteritemSpacing = f;
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

#pragma mark - priority middle
- (HoloCollectionSectionMaker * (^)(UIEdgeInsets (^)(void)))insetHandler {
    return ^id(id obj) {
        self.section.insetHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(CGFloat (^)(void)))minimumLineSpacingHandler {
    return ^id(id obj) {
        self.section.minimumLineSpacingHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(CGFloat (^)(void)))minimumInteritemSpacingHandler {
    return ^id(id obj) {
        self.section.minimumInteritemSpacingHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(id (^)(void)))headerModelHandler {
    return ^id(id obj) {
        self.section.headerModelHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(id (^)(void)))footerModelHandler {
    return ^id(id obj) {
        self.section.footerModelHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(CGSize (^)(id)))headerSizeHandler {
    return ^id(id obj) {
        self.section.headerSizeHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(CGSize (^)(id)))footerSizeHandler {
    return ^id(id obj) {
        self.section.footerSizeHandler = obj;
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

#pragma mark - priority high
- (HoloCollectionSectionMaker *(^)(SEL))headerConfigSEL {
    return ^id(SEL s) {
        self.section.headerConfigSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(SEL))footerConfigSEL {
    return ^id(SEL s) {
        self.section.footerConfigSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(SEL))headerSizeSEL {
    return ^id(SEL s) {
        self.section.headerSizeSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(SEL))footerSizeSEL {
    return ^id(SEL s) {
        self.section.footerSizeSEL = s;
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

- (HoloCollectionSectionMaker * (^)(SEL))willDisplayHeaderSEL {
    return ^id(SEL s) {
        self.section.willDisplayHeaderSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(SEL))willDisplayFooterSEL {
    return ^id(SEL s) {
        self.section.willDisplayFooterSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(SEL))didEndDisplayingHeaderSEL {
    return ^id(SEL s) {
        self.section.didEndDisplayingHeaderSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(SEL))didEndDisplayingFooterSEL {
    return ^id(SEL s) {
        self.section.didEndDisplayingFooterSEL = s;
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
