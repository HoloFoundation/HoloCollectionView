//
//  HoloCollectionItemMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import "HoloCollectionItemMaker.h"
#import "HoloCollectionItem.h"

@interface HoloCollectionItemMaker ()

@property (nonatomic, strong) HoloCollectionItem *collectionItem;

@end

@implementation HoloCollectionItemMaker

- (HoloCollectionItemMaker * (^)(Class))item {
    return ^id(Class cls) {
        self.collectionItem.cell = NSStringFromClass(cls);
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(NSString *))itemS {
    return ^id(id obj) {
        self.collectionItem.cell = obj;
        return self;
    };
}

#pragma mark - priority low
- (HoloCollectionItemMaker *(^)(id))model {
    return ^id(id obj) {
        self.collectionItem.model = obj;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(NSString *))reuseId {
    return ^id(id obj) {
        self.collectionItem.reuseId = obj;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(NSString *))tag {
    return ^id(id obj) {
        self.collectionItem.tag = obj;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(CGSize))size {
    return ^id(CGSize s) {
        self.collectionItem.size = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(BOOL))shouldHighlight {
    return ^id(BOOL b) {
        self.collectionItem.shouldHighlight = b;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(BOOL))shouldSelect {
    return ^id(BOOL b) {
        self.collectionItem.shouldSelect = b;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(BOOL))shouldDeselect {
    return ^id(BOOL b) {
        self.collectionItem.shouldDeselect = b;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(BOOL))canMove {
    return ^id(BOOL b) {
        self.collectionItem.canMove = b;
        return self;
    };
}

#pragma mark - priority middle
- (HoloCollectionItemMaker * (^)(id (^)(void)))modelHandler {
    return ^id(id obj) {
        self.collectionItem.modelHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(NSString * (^)(id)))reuseIdHandler {
    return ^id(id obj) {
        self.collectionItem.reuseIdHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(CGSize (^)(id)))sizeHandler {
    return ^id(id obj) {
        self.collectionItem.sizeHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(BOOL (^)(id)))shouldHighlightHandler {
    return ^id(id obj) {
        self.collectionItem.shouldHighlightHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(BOOL (^)(id)))shouldSelectHandler {
    return ^id(id obj) {
        self.collectionItem.shouldSelectHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(BOOL (^)(id)))shouldDeselectHandler {
    return ^id(id obj) {
        self.collectionItem.shouldDeselectHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(BOOL (^)(id)))canMoveHandler {
    return ^id(id obj) {
        self.collectionItem.canMoveHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(void (^)(id)))didSelectHandler {
    return ^id(id obj) {
        self.collectionItem.didSelectHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(void (^)(id)))didDeselectHandler {
    return ^id(id obj) {
        self.collectionItem.didDeselectHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(void (^)(UICollectionViewCell *, id)))beforeConfigureHandler {
    return ^id(id obj) {
        self.collectionItem.beforeConfigureHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker * (^)(void (^)(UICollectionViewCell *, id)))afterConfigureHandler {
    return ^id(id obj) {
        self.collectionItem.afterConfigureHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(void (^)(UICollectionViewCell *, id)))willDisplayHandler {
    return ^id(id obj) {
        self.collectionItem.willDisplayHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(void (^)(UICollectionViewCell *, id)))didEndDisplayingHandler {
    return ^id(id obj) {
        self.collectionItem.didEndDisplayingHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(void (^)(id)))didHighlightHandler {
    return ^id(id obj) {
        self.collectionItem.didHighlightHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(void (^)(id)))didUnHighlightHandler {
    return ^id(id obj) {
        self.collectionItem.didUnHighlightHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(NSIndexPath *(^)(NSIndexPath *, NSIndexPath *)))targetMoveHandler {
    return ^id(id obj) {
        self.collectionItem.targetMoveHandler = obj;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(void (^)(NSIndexPath *, NSIndexPath *, void(^)(BOOL))))moveHandler {
    return ^id(id obj) {
        if (obj) {
            self.collectionItem.canMove = YES;
        }
        self.collectionItem.moveHandler = obj;
        return self;
    };
}

#pragma mark - priority high
- (HoloCollectionItemMaker *(^)(SEL))configSEL {
    return ^id(SEL s) {
        self.collectionItem.configSEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))sizeSEL {
    return ^id(SEL s) {
        self.collectionItem.sizeSEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))shouldHighlightSEL {
    return ^id(SEL s) {
        self.collectionItem.shouldHighlightSEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))shouldSelectSEL {
    return ^id(SEL s) {
        self.collectionItem.shouldSelectSEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))shouldDeselectSEL {
    return ^id(SEL s) {
        self.collectionItem.shouldDeselectSEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))didSelectSEL {
    return ^id(SEL s) {
        self.collectionItem.didSelectSEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))didDeselectSEL {
    return ^id(SEL s) {
        self.collectionItem.didDeselectSEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))willDisplaySEL {
    return ^id(SEL s) {
        self.collectionItem.willDisplaySEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))didEndDisplayingSEL {
    return ^id(SEL s) {
        self.collectionItem.didEndDisplayingSEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))didHighlightSEL {
    return ^id(SEL s) {
        self.collectionItem.didHighlightSEL = s;
        return self;
    };
}

- (HoloCollectionItemMaker *(^)(SEL))didUnHighlightSEL {
    return ^id(SEL s) {
        self.collectionItem.didUnHighlightSEL = s;
        return self;
    };
}



- (HoloCollectionItem *)fetchCollectionItem {
    return self.collectionItem;
}

- (void)giveCollectionItem:(HoloCollectionItem *)collectionItem {
    self.collectionItem = collectionItem;
}

#pragma mark - getter
- (HoloCollectionItem *)collectionItem {
    if (!_collectionItem) {
        _collectionItem = [HoloCollectionItem new];
    }
    return _collectionItem;
}

@end
