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

/**
 *  Cell class.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^item)(Class item);

/**
 *  Set the data for the cell using the `model` property.
 *
 *  If the `modelHandler` property is nil, then use the `model` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^model)(id model);
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^modelHandler)(id (^)(void));

/**
 * The cell must implement the `configSEL` property setting method in order for the HoloTableView to pass the model for the cell.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^configSEL)(SEL configSEL);

/**
 *  Performed before `configSEL`.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^beforeConfigureHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

/**
 *  Performed after `configSEL`.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^afterConfigureHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));

/**
 *  Set the reuse identifier for the cell using the `reuseId` property.
 *
 *  If the `reuseIdHandler` property is nil, then use the `reuseId` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^reuseId)(NSString *reuseId);
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^reuseIdHandler)(NSString *(^)(id _Nullable model));

/**
 *  Set the tag for the cell using the `tag` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^tag)(NSString *tag);

/**
 *  Set the size for the cell using the `size` property.
 *
 *  If the `sizeSEL` property is nil or the cell don't implement the `sizeSEL` property setting method, then use the `sizeHandler` property.
 *  If the `sizeHandler` property is nil, then use the `size` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^size)(CGSize size);
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^sizeHandler)(CGSize (^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^sizeSEL)(SEL sizeSEL);

/**
 *  Set the should highlight or not for the cell using the `shouldHighlight` property.
 *
 *  If the `shouldHighlightSEL` property is nil or the cell don't implement the `shouldHighlightSEL` property setting method, then use the `shouldHighlightHandler` property.
 *  If the `shouldHighlightHandler` property is nil, then use the `shouldHighlight` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldHighlight)(BOOL shouldHighlight);
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldHighlightHandler)(BOOL (^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldHighlightSEL)(SEL shouldHighlightSEL);

/**
 *  Set the should select or not for the cell using the `shouldSelect` property.
 *
 *  If the `shouldSelectSEL` property is nil or the cell don't implement the `shouldSelectSEL` property setting method, then use the `shouldSelectHandler` property.
 *  If the `shouldSelectHandler` property is nil, then use the `shouldSelect` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldSelect)(BOOL shouldSelect);
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldSelectHandler)(BOOL (^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldSelectSEL)(SEL shouldSelectSEL);

/**
 *  Set the should deselect or not for the cell using the `shouldDeselect` property.
 *
 *  If the `shouldDeselectSEL` property is nil or the cell don't implement the `shouldDeselectSEL` property setting method, then use the `shouldDeselectHandler` property.
 *  If the `shouldDeselectHandler` property is nil, then use the `shouldDeselect` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldDeselect)(BOOL shouldDeselect);
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldDeselectHandler)(BOOL (^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^shouldDeselectSEL)(SEL shouldDeselectSEL);

/**
 *  Set the can move or not for the cell using the `canMove` property.
 *
 *  If the `canMoveHandler` property is nil, then use the `canEdit` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^canMove)(BOOL canMove);
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^canMoveHandler)(BOOL (^)(id _Nullable model));

/**
 *  If the cell did select, the `didSelectHandler` will be called.
 *
 *  If the `didSelectSEL` property is nil or the cell don't implement the `didSelectSEL` property setting method, then use the `didSelectHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didSelectHandler)(void(^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didSelectSEL)(SEL didSelectSEL);

/**
 *  If the cell did deselect, the `didDeselectHandler` will be called.
 *
 *  If the `didDeselectSEL` property is nil or the cell don't implement the `didDeselectSEL` property setting method, then use the `didDeselectHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didDeselectHandler)(void(^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didDeselectSEL)(SEL didDeselectSEL);

/**
 *  If the cell will display, the `willDisplayHandler` will be called.
 *
 *  If the `willDisplaySEL` property is nil or the cell don't implement the `willDisplaySEL` property setting method, then use the `willDisplayHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^willDisplayHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^willDisplaySEL)(SEL willDisplaySEL);

/**
 *  If the cell did end displaying, the `didEndDisplayingHandler` will be called.
 *
 *  If the `didEndDisplayingSEL` property is nil or the cell don't implement the `didEndDisplayingSEL` property setting method, then use the `didEndDisplayingHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didEndDisplayingHandler)(void(^)(UICollectionViewCell *cell, id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didEndDisplayingSEL)(SEL didEndDisplayingSEL);

/**
 *  If the cell did highlight, the `didHighlightHandler` will be called.
 *
 *  If the `didHighlightSEL` property is nil or the cell don't implement the `didHighlightSEL` property setting method, then use the `didHighlightHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didHighlightHandler)(void(^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didHighlightSEL)(SEL didHighlightSEL);

/**
 *  If the cell did unhighlight, the `didUnHighlightHandler` will be called.
 *
 *  If the `didUnHighlightSEL` property is nil or the cell don't implement the `didUnHighlightSEL` property setting method, then use the `didUnHighlightHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didUnHighlightHandler)(void(^)(id _Nullable model));
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^didUnHighlightSEL)(SEL didUnHighlightSEL);

/**
 *  Set the target move index for the cell using the `targetMoveHandler` property.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^targetMoveHandler)(NSIndexPath *(^targetIndexPath)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath));

/**
 *  If the cell is moved, the `moveHandler` will be called.
 */
@property (nonatomic, copy, readonly) HoloCollectionItemMaker *(^moveHandler)(void(^)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath, void(^completionHandler)(BOOL actionPerformed)));


- (HoloCollectionItem *)fetchCollectionItem;

- (void)giveCollectionItem:(HoloCollectionItem *)collectionItem;

@end

NS_ASSUME_NONNULL_END
