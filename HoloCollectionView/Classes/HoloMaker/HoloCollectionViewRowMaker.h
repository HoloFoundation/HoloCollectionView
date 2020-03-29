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

@property (nonatomic, strong) id model;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) SEL configSEL;

@property (nonatomic, assign) SEL sizeSEL;

@property (nonatomic, assign) BOOL shouldHighlight;

@property (nonatomic, assign) BOOL shouldSelect;

@property (nonatomic, assign) BOOL shouldDeselect;

@property (nonatomic, assign) BOOL canMove;

@property (nonatomic, copy) void (^didSelectHandler)(id _Nullable model);

@property (nonatomic, copy) void (^didDeselectHandler)(id _Nullable model);

@property (nonatomic, copy) void (^willDisplayHandler)(UICollectionViewCell *cell, id _Nullable model);

@property (nonatomic, copy) void (^didEndDisplayingHandler)(UICollectionViewCell *cell, id _Nullable model);

@property (nonatomic, copy) void (^didHighlightHandler)(id _Nullable model);

@property (nonatomic, copy) void (^didUnHighlightHandler)(id _Nullable model);

@property (nonatomic, copy) NSIndexPath *(^targetMoveHandler)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath);

@property (nonatomic, copy) void (^moveHandler)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath, void(^completionHandler)(BOOL actionPerformed));

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionRowMaker : NSObject

@property (nonatomic, strong, readonly) HoloCollectionRow *collectionRow;

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^row)(Class row);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^rowS)(NSString *rowString);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^model)(id model);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^size)(CGSize size);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^tag)(NSString *tag);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^configSEL)(SEL configSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^sizeSEL)(SEL sizeSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldHighlight)(BOOL shouldHighlight);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldSelect)(BOOL shouldSelect);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^shouldDeselect)(BOOL shouldDeselect);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^canMove)(BOOL canMove);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didSelectHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didDeselectHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^willDisplayHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didEndDisplayingHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didHighlightHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didUnHighlightHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^targetMoveHandler)(NSIndexPath *(^targetIndexPath)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath));

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^moveHandler)(void(^)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath, void(^completionHandler)(BOOL actionPerformed)));

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewRowMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^row)(Class row);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^rowS)(NSString *rowString);

- (NSArray<HoloCollectionRow *> *)install;

@end

NS_ASSUME_NONNULL_END
