//
//  HoloCollectionViewRowMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////
@interface HoloCollectionRow : NSObject

@property (nonatomic, copy) NSString *cell;

#pragma mark - priority low
@property (nonatomic, strong) id model;

@property (nonatomic, copy) NSString *reuseId;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) BOOL shouldHighlight;

@property (nonatomic, assign) BOOL shouldSelect;

@property (nonatomic, assign) BOOL shouldDeselect;

@property (nonatomic, assign) BOOL canMove;

#pragma mark - priority middle
@property (nonatomic, copy) id (^modelHandler)(void);

@property (nonatomic, copy) CGSize (^sizeHandler)(id _Nullable model);

@property (nonatomic, copy) BOOL (^shouldHighlightHandler)(id _Nullable model);

@property (nonatomic, copy) BOOL (^shouldSelectHandler)(id _Nullable model);

@property (nonatomic, copy) BOOL (^shouldDeselectHandler)(id _Nullable model);

@property (nonatomic, copy) BOOL (^canMoveHandler)(id _Nullable model);

@property (nonatomic, copy) void (^didSelectHandler)(id _Nullable model);

@property (nonatomic, copy) void (^didDeselectHandler)(id _Nullable model);

@property (nonatomic, copy) void (^willDisplayHandler)(UICollectionViewCell *cell, id _Nullable model);

@property (nonatomic, copy) void (^didEndDisplayingHandler)(UICollectionViewCell *cell, id _Nullable model);

@property (nonatomic, copy) void (^didHighlightHandler)(id _Nullable model);

@property (nonatomic, copy) void (^didUnHighlightHandler)(id _Nullable model);

@property (nonatomic, copy) NSIndexPath *(^targetMoveHandler)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath);

@property (nonatomic, copy) void (^moveHandler)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath, void(^completionHandler)(BOOL actionPerformed));

#pragma mark - priority high
@property (nonatomic, assign) SEL configSEL;

@property (nonatomic, assign) SEL sizeSEL;

@property (nonatomic, assign) SEL shouldHighlightSEL;

@property (nonatomic, assign) SEL shouldSelectSEL;

@property (nonatomic, assign) SEL shouldDeselectSEL;

@property (nonatomic, assign) SEL canMoveSEL;

@property (nonatomic, assign) SEL didSelectSEL;

@property (nonatomic, assign) SEL didDeselectSEL;

@property (nonatomic, assign) SEL willDisplaySEL;

@property (nonatomic, assign) SEL didEndDisplayingSEL;

@property (nonatomic, assign) SEL didHighlightSEL;

@property (nonatomic, assign) SEL didUnHighlightSEL;

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionRowMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^row)(Class row);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^rowS)(NSString *rowString);

#pragma mark - priority low
@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^model)(id model);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^reuseId)(NSString *reuseId);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^tag)(NSString *tag);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^size)(CGSize size);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldHighlight)(BOOL shouldHighlight);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldSelect)(BOOL shouldSelect);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldDeselect)(BOOL shouldDeselect);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^canMove)(BOOL canMove);

#pragma mark - priority middle
@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^modelHandler)(id (^)(void));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^sizeHandler)(CGSize (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldHighlightHandler)(BOOL (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldSelectHandler)(BOOL (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldDeselectHandler)(BOOL (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^canMoveHandler)(BOOL (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didSelectHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didDeselectHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^willDisplayHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didEndDisplayingHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didHighlightHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didUnHighlightHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^targetMoveHandler)(NSIndexPath *(^targetIndexPath)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^moveHandler)(void(^)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath, void(^completionHandler)(BOOL actionPerformed)));

#pragma mark - priority high
@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^configSEL)(SEL configSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^sizeSEL)(SEL sizeSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldHighlightSEL)(SEL shouldHighlightSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldSelectSEL)(SEL shouldSelectSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldDeselectSEL)(SEL shouldDeselectSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^canMoveSEL)(SEL canMoveSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didSelectSEL)(SEL didSelectSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didDeselectSEL)(SEL didDeselectSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^willDisplaySEL)(SEL willDisplaySEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didEndDisplayingSEL)(SEL didEndDisplayingSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didHighlightSEL)(SEL didHighlightSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didUnHighlightSEL)(SEL didUnHighlightSEL);


- (HoloCollectionRow *)fetchCollectionRow;

- (void)giveCollectionRow:(HoloCollectionRow *)collectionRow;

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewRowMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^row)(Class row);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^rowS)(NSString *rowString);

- (NSArray<HoloCollectionRow *> *)install;

@end

NS_ASSUME_NONNULL_END
