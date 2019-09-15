//
//  HoloCollectionViewSectionMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewSectionMaker.h"
#import <objc/runtime.h>

////////////////////////////////////////////////////////////
@implementation HoloCollectionSection

- (instancetype)init {
    self = [super init];
    if (self) {
        _rows = [NSArray new];
        _inset = UIEdgeInsetsMake(CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN);
        _headerReferenceSize = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        _footerReferenceSize = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        _minimumLineSpacing = CGFLOAT_MIN;
        _minimumInteritemSpacing = CGFLOAT_MIN;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _headerFooterConfigSEL = @selector(configureHeaderFooterWithModel:);
        _headerFooterSizeSEL = @selector(sizeForHeaderFooterWithModel:);
#pragma clang diagnostic pop
    }
    return self;
}

- (NSIndexSet *)holo_insertRows:(NSArray<HoloCollectionRow *> *)rows atIndex:(NSInteger)index {
    if (rows.count <= 0) return nil;
    
    if (index < 0) index = 0;
    if (index > self.rows.count) index = self.rows.count;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, rows.count)];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.rows];
    [array insertObjects:rows atIndexes:indexSet];
    self.rows = array;
    return indexSet;
}

- (void)holo_removeRow:(HoloCollectionRow *)row {
    if (!row) return;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.rows];
    [array removeObject:row];
    self.rows = array;
}

- (void)holo_removeAllRows {
    self.rows = [NSArray new];
}

@end

////////////////////////////////////////////////////////////
@implementation HoloCollectionSectionMaker

- (instancetype)init {
    self = [super init];
    if (self) {
        _section = [HoloCollectionSection new];
    }
    return self;
}

- (HoloCollectionSectionMaker * (^)(UIEdgeInsets))inset {
    return ^id(UIEdgeInsets i) {
        self.section.inset = i;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(NSString *))header {
    return ^id(id obj) {
        self.section.header = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(NSString *))footer {
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

- (HoloCollectionSectionMaker *(^)(CGSize))headerReferenceSize {
    return ^id(CGSize s) {
        self.section.headerReferenceSize = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(CGSize))footerReferenceSize {
    return ^id(CGSize s) {
        self.section.footerReferenceSize = s;
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

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewSectionMaker ()

@property (nonatomic, copy) NSArray<HoloCollectionSection *> *targetSections;

@property (nonatomic, assign) BOOL isRemark;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *holoUpdateSections;

@property (nonatomic, strong) NSMutableDictionary *sectionIndexsDict;

@end

@implementation HoloCollectionViewSectionMaker

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections isRemark:(BOOL)isRemark {
    self = [super init];
    if (self) {
        _targetSections = sections;
        _isRemark = isRemark;
        
        for (HoloCollectionSection *section in self.targetSections) {
            
            NSString *dictKey = section.tag ?: kHoloSectionTagNil;
            if (self.sectionIndexsDict[dictKey]) continue;
            
            NSMutableDictionary *dict = @{kHoloTargetSection : section}.mutableCopy;
            dict[kHoloTargetIndex] = [NSNumber numberWithInteger:[self.targetSections indexOfObject:section]];
            self.sectionIndexsDict[dictKey] = [dict copy];
        }
    }
    return self;
}

- (HoloCollectionSectionMaker *(^)(NSString *))section {
    return ^id(NSString *tag) {
        HoloCollectionSectionMaker *sectionMaker = [HoloCollectionSectionMaker new];
        HoloCollectionSection *updateSection = sectionMaker.section;
        updateSection.tag = tag;
        
        NSString *dictKey = tag ?: kHoloSectionTagNil;
        NSDictionary *sectionIndexDict = self.sectionIndexsDict[dictKey];
        
        HoloCollectionSection *targetSection = sectionIndexDict[kHoloTargetSection];
        NSNumber *targetIndex = sectionIndexDict[kHoloTargetIndex];
        
        if (!self.isRemark && targetSection) {
            // set value of CGFloat and BOOL
            unsigned int outCount;
            objc_property_t * properties = class_copyPropertyList([targetSection class], &outCount);
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                const char * propertyAttr = property_getAttributes(property);
                char t = propertyAttr[1];
                if (t == 'd' || t == 'B' || t == '{') { // CGFloat or BOOL or CGSize
                    const char *propertyName = property_getName(property);
                    NSString *propertyNameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
                    id value = [targetSection valueForKey:propertyNameStr];
                    if (value) [updateSection setValue:value forKey:propertyNameStr];
                }
            }
            
            // set value of SEL
            updateSection.headerFooterConfigSEL = targetSection.headerFooterConfigSEL;
            updateSection.headerFooterSizeSEL = targetSection.headerFooterSizeSEL;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        if (targetSection) {
            dict[kHoloTargetSection] = targetSection;
            dict[kHoloTargetIndex] = targetIndex;
        }
        dict[kHoloUpdateSection] = updateSection;
        [self.holoUpdateSections addObject:dict];
        
        return sectionMaker;
    };
}

- (NSArray<NSDictionary *> *)install {
    return [self.holoUpdateSections copy];
}

#pragma mark - getter
- (NSMutableArray<NSDictionary *> *)holoUpdateSections {
    if (!_holoUpdateSections) {
        _holoUpdateSections = [NSMutableArray new];
    }
    return _holoUpdateSections;
}

- (NSMutableDictionary *)sectionIndexsDict {
    if (!_sectionIndexsDict) {
        _sectionIndexsDict = [NSMutableDictionary new];
    }
    return _sectionIndexsDict;
}


@end
