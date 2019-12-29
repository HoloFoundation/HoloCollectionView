//
//  HoloCollectionViewRowMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "HoloCollectionViewRowMaker.h"

////////////////////////////////////////////////////////////
@implementation HoloCollectionRow

- (instancetype)init {
    self = [super init];
    if (self) {
        _size = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        _shouldHighlight = YES;
        _shouldSelect = YES;
        _shouldDeselect = YES;
        _canMove = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _configSEL = @selector(holo_configureCellWithModel:);
        _sizeSEL = @selector(holo_sizeForCellWithModel:);
#pragma clang diagnostic pop
    }
    
    return self;
}

@end

////////////////////////////////////////////////////////////
@implementation HoloCollectionRowMaker

- (instancetype)init {
    self = [super init];
    if (self) {
        _collectionRow = [HoloCollectionRow new];
    }
    return self;
}

- (HoloCollectionRowMaker *(^)(NSString *))row {
    return ^id(id obj) {
        self.collectionRow.cell = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(Class))rowCls {
    return ^id(Class cls) {
        self.collectionRow.cell = NSStringFromClass(cls);
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(id))model {
    return ^id(id obj) {
        self.collectionRow.model = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(CGSize))size {
    return ^id(CGSize s) {
        self.collectionRow.size = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(NSString *))tag {
    return ^id(id obj) {
        self.collectionRow.tag = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))configSEL {
    return ^id(SEL s) {
        self.collectionRow.configSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))sizeSEL {
    return ^id(SEL s) {
        self.collectionRow.sizeSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(BOOL))shouldHighlight {
    return ^id(BOOL b) {
        self.collectionRow.shouldHighlight = b;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(BOOL))shouldSelect {
    return ^id(BOOL b) {
        self.collectionRow.shouldSelect = b;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(BOOL))shouldDeselect {
    return ^id(BOOL b) {
        self.collectionRow.shouldDeselect = b;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(BOOL))canMove {
    return ^id(BOOL b) {
        self.collectionRow.canMove = b;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(void (^)(id)))didSelectHandler {
    return ^id(id obj) {
        self.collectionRow.didSelectHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(void (^)(id)))didDeselectHandler {
    return ^id(id obj) {
        self.collectionRow.didDeselectHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(UICollectionViewCell *, id)))willDisplayHandler {
    return ^id(id obj) {
        self.collectionRow.willDisplayHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(UICollectionViewCell *, id)))didEndDisplayingHandler {
    return ^id(id obj) {
        self.collectionRow.didEndDisplayingHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(id)))didHighlightHandler {
    return ^id(id obj) {
        self.collectionRow.didHighlightHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(id)))didUnHighlightHandler {
    return ^id(id obj) {
        self.collectionRow.didUnHighlightHandler = obj;
        return self;
    };
}


- (HoloCollectionRowMaker *(^)(NSIndexPath *(^)(NSIndexPath *, NSIndexPath *)))targetMoveHandler {
    return ^id(id obj) {
        self.collectionRow.targetMoveHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(NSIndexPath *, NSIndexPath *, void(^)(BOOL))))moveHandler {
    return ^id(id obj) {
        if (obj) {
            self.collectionRow.canMove = YES;
        }
        self.collectionRow.moveHandler = obj;
        return self;
    };
}

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewRowMaker ()

@property (nonatomic, strong) NSMutableArray<HoloCollectionRow *> *holoRows;

@end

@implementation HoloCollectionViewRowMaker

- (HoloCollectionRowMaker *(^)(NSString *))row {
    return ^id(id obj) {
        HoloCollectionRowMaker *rowMaker = [HoloCollectionRowMaker new];
        rowMaker.collectionRow.cell = obj;
        [self.holoRows addObject:rowMaker.collectionRow];
        return rowMaker;
    };
}

- (HoloCollectionRowMaker * (^)(Class))rowCls {
    return ^id(Class cls) {
        HoloCollectionRowMaker *rowMaker = [HoloCollectionRowMaker new];
        rowMaker.collectionRow.cell = NSStringFromClass(cls);
        [self.holoRows addObject:rowMaker.collectionRow];
        return rowMaker;
    };
}

- (NSArray<HoloCollectionRow *> *)install {
    return self.holoRows;
}

#pragma mark - getter
- (NSMutableArray<HoloCollectionRow *> *)holoRows {
    if (!_holoRows) {
        _holoRows = [NSMutableArray new];
    }
    return _holoRows;
}

@end
