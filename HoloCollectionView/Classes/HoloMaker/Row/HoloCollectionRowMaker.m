//
//  HoloCollectionRowMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import "HoloCollectionRowMaker.h"
#import "HoloCollectionRow.h"

@interface HoloCollectionRowMaker ()

@property (nonatomic, strong) HoloCollectionRow *collectionRow;

@end

@implementation HoloCollectionRowMaker

- (HoloCollectionRowMaker * (^)(Class))row {
    return ^id(Class cls) {
        self.collectionRow.cell = NSStringFromClass(cls);
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(NSString *))rowS {
    return ^id(id obj) {
        self.collectionRow.cell = obj;
        return self;
    };
}

#pragma mark - priority low
- (HoloCollectionRowMaker *(^)(id))model {
    return ^id(id obj) {
        self.collectionRow.model = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(NSString *))reuseId {
    return ^id(id obj) {
        self.collectionRow.reuseId = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(NSString *))tag {
    return ^id(id obj) {
        self.collectionRow.tag = obj;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(CGSize))size {
    return ^id(CGSize s) {
        self.collectionRow.size = s;
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

#pragma mark - priority middle
- (HoloCollectionRowMaker * (^)(id (^)(void)))modelHandler {
    return ^id(id obj) {
        self.collectionRow.modelHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(NSString * (^)(id)))reuseIdHandler {
    return ^id(id obj) {
        self.collectionRow.reuseIdHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(CGSize (^)(id)))sizeHandler {
    return ^id(id obj) {
        self.collectionRow.sizeHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(BOOL (^)(id)))shouldHighlightHandler {
    return ^id(id obj) {
        self.collectionRow.shouldHighlightHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(BOOL (^)(id)))shouldSelectHandler {
    return ^id(id obj) {
        self.collectionRow.shouldSelectHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(BOOL (^)(id)))shouldDeselectHandler {
    return ^id(id obj) {
        self.collectionRow.shouldDeselectHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(BOOL (^)(id)))canMoveHandler {
    return ^id(id obj) {
        self.collectionRow.canMoveHandler = obj;
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

- (HoloCollectionRowMaker * (^)(void (^)(UICollectionViewCell *, id)))beforeConfigureHandler {
    return ^id(id obj) {
        self.collectionRow.beforeConfigureHandler = obj;
        return self;
    };
}

- (HoloCollectionRowMaker * (^)(void (^)(UICollectionViewCell *, id)))afterConfigureHandler {
    return ^id(id obj) {
        self.collectionRow.afterConfigureHandler = obj;
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

#pragma mark - priority high
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

- (HoloCollectionRowMaker *(^)(SEL))shouldHighlightSEL {
    return ^id(SEL s) {
        self.collectionRow.shouldHighlightSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))shouldSelectSEL {
    return ^id(SEL s) {
        self.collectionRow.shouldSelectSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))shouldDeselectSEL {
    return ^id(SEL s) {
        self.collectionRow.shouldDeselectSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))didSelectSEL {
    return ^id(SEL s) {
        self.collectionRow.didSelectSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))didDeselectSEL {
    return ^id(SEL s) {
        self.collectionRow.didDeselectSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))willDisplaySEL {
    return ^id(SEL s) {
        self.collectionRow.willDisplaySEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))didEndDisplayingSEL {
    return ^id(SEL s) {
        self.collectionRow.didEndDisplayingSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))didHighlightSEL {
    return ^id(SEL s) {
        self.collectionRow.didHighlightSEL = s;
        return self;
    };
}

- (HoloCollectionRowMaker *(^)(SEL))didUnHighlightSEL {
    return ^id(SEL s) {
        self.collectionRow.didUnHighlightSEL = s;
        return self;
    };
}



- (HoloCollectionRow *)fetchCollectionRow {
    return self.collectionRow;
}

- (void)giveCollectionRow:(HoloCollectionRow *)collectionRow {
    self.collectionRow = collectionRow;
}

#pragma mark - getter
- (HoloCollectionRow *)collectionRow {
    if (!_collectionRow) {
        _collectionRow = [HoloCollectionRow new];
    }
    return _collectionRow;
}

@end
