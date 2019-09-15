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
        _configSEL = @selector(configureCellWithModel:);
        _sizeSEL = @selector(sizeForCellWithModel:);
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
        _row = [HoloCollectionRow new];
    }
    return self;
}

- (HoloCollectionRowMaker *(^)(id))model {
    return ^id(id obj) {
        self.row.model = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(CGSize))size {
    return ^id(CGSize s) {
        self.row.size = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(NSString *))tag {
    return ^id(id obj) {
        self.row.tag = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))configSEL {
    return ^id(SEL s) {
        self.row.configSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))sizeSEL {
    return ^id(SEL s) {
        self.row.sizeSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(BOOL))shouldHighlight {
    return ^id(BOOL b) {
        self.row.shouldHighlight = b;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(BOOL))shouldSelect {
    return ^id(BOOL b) {
        self.row.shouldSelect = b;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(BOOL))shouldDeselect {
    return ^id(BOOL b) {
        self.row.shouldDeselect = b;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(BOOL))canMove {
    return ^id(BOOL b) {
        self.row.canMove = b;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(void (^)(id)))didSelectHandler {
    return ^id(id obj) {
        self.row.didSelectHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(void (^)(id)))didDeselectHandler {
    return ^id(id obj) {
        self.row.didDeselectHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(UICollectionViewCell *, id)))willDisplayHandler {
    return ^id(id obj) {
        self.row.willDisplayHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(UICollectionViewCell *, id)))didEndDisplayingHandler {
    return ^id(id obj) {
        self.row.didEndDisplayingHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(id)))didHighlightHandler {
    return ^id(id obj) {
        self.row.didHighlightHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(id)))didUnHighlightHandler {
    return ^id(id obj) {
        self.row.didUnHighlightHandler = obj;
        return self;
    };
}


- (HoloCollectionRowMaker *(^)(NSIndexPath *(^)(NSIndexPath *, NSIndexPath *)))targetMoveHandler {
    return ^id(id obj) {
        self.row.targetMoveHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(void (^)(NSIndexPath *, NSIndexPath *, void(^)(BOOL))))moveHandler {
    return ^id(id obj) {
        if (obj) {
            self.row.canMove = YES;
        }
        self.row.moveHandler = obj;
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
        rowMaker.row.cell = obj;
        [self.holoRows addObject:rowMaker.row];
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
