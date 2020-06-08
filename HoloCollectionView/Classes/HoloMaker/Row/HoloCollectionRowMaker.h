//
//  HoloCollectionRowMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>
@class HoloCollectionRow;

NS_ASSUME_NONNULL_BEGIN

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

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didSelectSEL)(SEL didSelectSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didDeselectSEL)(SEL didDeselectSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^willDisplaySEL)(SEL willDisplaySEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didEndDisplayingSEL)(SEL didEndDisplayingSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didHighlightSEL)(SEL didHighlightSEL);

@property (nonatomic, copy, readonly) HoloCollectionRowMaker *(^didUnHighlightSEL)(SEL didUnHighlightSEL);


- (HoloCollectionRow *)fetchCollectionRow;

- (void)giveCollectionRow:(HoloCollectionRow *)collectionRow;

@end

NS_ASSUME_NONNULL_END
