//
//  HoloCollectionItemMaker.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>
@class HoloCollectionItem;

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionItemMaker : NSObject

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^item)(Class item);

#pragma mark - priority low
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^model)(id model);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^reuseId)(NSString *reuseId);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^tag)(NSString *tag);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^size)(CGSize size);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldHighlight)(BOOL shouldHighlight);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldSelect)(BOOL shouldSelect);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldDeselect)(BOOL shouldDeselect);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^canMove)(BOOL canMove);

#pragma mark - priority middle
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^modelHandler)(id (^)(void));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^reuseIdHandler)(NSString *(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^sizeHandler)(CGSize (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldHighlightHandler)(BOOL (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldSelectHandler)(BOOL (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldDeselectHandler)(BOOL (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^canMoveHandler)(BOOL (^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didSelectHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didDeselectHandler)(void(^)(id _Nullable model));

// Performed before `configSEL`
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^beforeConfigureHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

// Performed after `configSEL`
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^afterConfigureHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^willDisplayHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didEndDisplayingHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didHighlightHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didUnHighlightHandler)(void(^)(id _Nullable model));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^targetMoveHandler)(NSIndexPath *(^targetIndexPath)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath));

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^moveHandler)(void(^)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath, void(^completionHandler)(BOOL actionPerformed)));

#pragma mark - priority high
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^configSEL)(SEL configSEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^sizeSEL)(SEL sizeSEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldHighlightSEL)(SEL shouldHighlightSEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldSelectSEL)(SEL shouldSelectSEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldDeselectSEL)(SEL shouldDeselectSEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didSelectSEL)(SEL didSelectSEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didDeselectSEL)(SEL didDeselectSEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^willDisplaySEL)(SEL willDisplaySEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didEndDisplayingSEL)(SEL didEndDisplayingSEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didHighlightSEL)(SEL didHighlightSEL);

@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didUnHighlightSEL)(SEL didUnHighlightSEL);


- (HoloCollectionItem *)fetchCollectionItem;

- (void)giveCollectionItem:(HoloCollectionItem *)collectionItem;

@end

NS_ASSUME_NONNULL_END
