//
//  HoloCollectionSectionMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import "HoloCollectionSectionMaker.h"
#import "HoloCollectionSection.h"
#import "HoloCollectionViewItemMaker.h"
#import "HoloCollectionViewRowMaker.h"

@interface HoloCollectionSectionMaker ()

@property (nonatomic, strong) HoloCollectionSection *section;

@end

@implementation HoloCollectionSectionMaker

- (HoloCollectionSectionMaker * (^)(Class))header {
    return ^id(Class cls) {
        self.section.header = cls;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(Class))footer {
    return ^id(Class cls) {
        self.section.footer = cls;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(id))headerModel {
    return ^id(id obj) {
        self.section.headerModel = obj;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(id (^)(void)))headerModelHandler {
    return ^id(id obj) {
        self.section.headerModelHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(id))footerModel {
    return ^id(id obj) {
        self.section.footerModel = obj;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(id (^)(void)))footerModelHandler {
    return ^id(id obj) {
        self.section.footerModelHandler = obj;
        return self;
    };
}

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

- (HoloCollectionSectionMaker * (^)(UIEdgeInsets))inset {
    return ^id(UIEdgeInsets i) {
        self.section.inset = i;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(UIEdgeInsets (^)(void)))insetHandler {
    return ^id(id obj) {
        self.section.insetHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(CGFloat))minimumLineSpacing {
    return ^id(CGFloat f) {
        self.section.minimumLineSpacing = f;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(CGFloat (^)(void)))minimumLineSpacingHandler {
    return ^id(id obj) {
        self.section.minimumLineSpacingHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(CGFloat))minimumInteritemSpacing {
    return ^id(CGFloat f) {
        self.section.minimumInteritemSpacing = f;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(CGFloat (^)(void)))minimumInteritemSpacingHandler {
    return ^id(id obj) {
        self.section.minimumInteritemSpacingHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(NSString * (^)(id)))headerReuseIdHandler {
    return ^id(id obj) {
        self.section.headerReuseIdHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(NSString * (^)(id)))footerReuseIdHandler {
    return ^id(id obj) {
        self.section.footerReuseIdHandler = obj;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(CGSize))headerSize {
    return ^id(CGSize s) {
        self.section.headerSize = s;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(CGSize (^)(id)))headerSizeHandler {
    return ^id(id obj) {
        self.section.headerSizeHandler = obj;
        return self;
    };
}
- (HoloCollectionSectionMaker *(^)(SEL))headerSizeSEL {
    return ^id(SEL s) {
        self.section.headerSizeSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(CGSize))footerSize {
    return ^id(CGSize s) {
        self.section.footerSize = s;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(CGSize (^)(id)))footerSizeHandler {
    return ^id(id obj) {
        self.section.footerSizeHandler = obj;
        return self;
    };
}
- (HoloCollectionSectionMaker *(^)(SEL))footerSizeSEL {
    return ^id(SEL s) {
        self.section.footerSizeSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(void (^)(UIView *, id)))willDisplayHeaderHandler {
    return ^id(id obj) {
        self.section.willDisplayHeaderHandler = obj;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(SEL))willDisplayHeaderSEL {
    return ^id(SEL s) {
        self.section.willDisplayHeaderSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(void (^)(UIView *, id)))willDisplayFooterHandler {
    return ^id(id obj) {
        self.section.willDisplayFooterHandler = obj;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(SEL))willDisplayFooterSEL {
    return ^id(SEL s) {
        self.section.willDisplayFooterSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(void (^)(UIView *, id)))didEndDisplayingHeaderHandler {
    return ^id(id obj) {
        self.section.didEndDisplayingHeaderHandler = obj;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(SEL))didEndDisplayingHeaderSEL {
    return ^id(SEL s) {
        self.section.didEndDisplayingHeaderSEL = s;
        return self;
    };
}

- (HoloCollectionSectionMaker *(^)(void (^)(UIView *, id)))didEndDisplayingFooterHandler {
    return ^id(id obj) {
        self.section.didEndDisplayingFooterHandler = obj;
        return self;
    };
}
- (HoloCollectionSectionMaker * (^)(SEL))didEndDisplayingFooterSEL {
    return ^id(SEL s) {
        self.section.didEndDisplayingFooterSEL = s;
        return self;
    };
}


- (HoloCollectionSectionMaker * (^)(void (NS_NOESCAPE ^)(HoloCollectionViewItemMaker *)))makeItems {
    return ^id(void(^block)(HoloCollectionViewItemMaker *make)) {
        HoloCollectionViewItemMaker *maker = [HoloCollectionViewItemMaker new];
        if (block) block(maker);
        
        [self.section insertItems:[maker install] atIndex:NSIntegerMax];
        return self;
    };
}

- (HoloCollectionSectionMaker * (^)(void (NS_NOESCAPE ^)(HoloCollectionViewRowMaker *)))makeRows {
    return ^id(void(^block)(HoloCollectionViewRowMaker *make)) {
        HoloCollectionViewRowMaker *maker = [HoloCollectionViewRowMaker new];
        if (block) block(maker);
        
        [self.section insertItems:[maker install] atIndex:NSIntegerMax];
        return self;
    };
}


- (HoloCollectionSection *)fetchCollectionSection {
    return self.section;
}

- (void)giveCollectionSection:(HoloCollectionSection *)section {
    self.section = section;
}

#pragma mark - getter
- (HoloCollectionSection *)section {
    if (!_section) {
        _section = [HoloCollectionSection new];
    }
    return _section;
}

@end
