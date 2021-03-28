//
//  HoloCollectionItem.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionItem : NSObject

/**
 *  Cell class.
 */
@property (nonatomic, assign, nullable) Class cell;

/**
 *  Set the data for the cell using the `model` property.
 *
 *  If the `modelHandler` property is nil, then use the `model` property.
 */
@property (nonatomic, strong, nullable) id model;
@property (nonatomic, copy, nullable) id (^modelHandler)(void);

/**
 * The cell must implement the `configSEL` property setting method in order for the HoloTableView to pass the model for the cell.
 */
@property (nonatomic, assign) SEL configSEL;

/**
 *  Performed before `configSEL`.
 */
@property (nonatomic, copy, nullable) void (^beforeConfigureHandler)(UICollectionViewCell *cell, id _Nullable model);

/**
 *  Performed after `configSEL`.
 */
@property (nonatomic, copy, nullable) void (^afterConfigureHandler)(UICollectionViewCell *cell, id _Nullable model);

/**
 *  Set the reuse identifier for the cell using the `reuseId` property.
 *
 *  If the `reuseIdHandler` property is nil, then use the `reuseId` property.
 */
@property (nonatomic, copy, nullable) NSString *reuseId;
@property (nonatomic, copy, nullable) NSString *(^reuseIdHandler)(id _Nullable model);

/**
 *  Set the tag for the cell using the `tag` property.
 */
@property (nonatomic, copy, nullable) NSString *tag;

/**
 *  Set the size for the cell using the `size` property.
 *
 *  If the `sizeSEL` property is nil or the cell don't implement the `sizeSEL` property setting method, then use the `sizeHandler` property.
 *  If the `sizeHandler` property is nil, then use the `size` property.
 */
@property (nonatomic, assign) CGSize size;
@property (nonatomic, copy, nullable) CGSize (^sizeHandler)(id _Nullable model);
@property (nonatomic, assign) SEL sizeSEL;

/**
 *  Set the should highlight or not for the cell using the `shouldHighlight` property.
 *
 *  If the `shouldHighlightSEL` property is nil or the cell don't implement the `shouldHighlightSEL` property setting method, then use the `shouldHighlightHandler` property.
 *  If the `shouldHighlightHandler` property is nil, then use the `shouldHighlight` property.
 */
@property (nonatomic, assign) BOOL shouldHighlight;
@property (nonatomic, copy, nullable) BOOL (^shouldHighlightHandler)(id _Nullable model);
@property (nonatomic, assign) SEL shouldHighlightSEL;

/**
 *  Set the should select or not for the cell using the `shouldSelect` property.
 *
 *  If the `shouldSelectSEL` property is nil or the cell don't implement the `shouldSelectSEL` property setting method, then use the `shouldSelectHandler` property.
 *  If the `shouldSelectHandler` property is nil, then use the `shouldSelect` property.
 */
@property (nonatomic, assign) BOOL shouldSelect;
@property (nonatomic, copy, nullable) BOOL (^shouldSelectHandler)(id _Nullable model);
@property (nonatomic, assign) SEL shouldSelectSEL;

/**
 *  Set the should deselect or not for the cell using the `shouldDeselect` property.
 *
 *  If the `shouldDeselectSEL` property is nil or the cell don't implement the `shouldDeselectSEL` property setting method, then use the `shouldDeselectHandler` property.
 *  If the `shouldDeselectHandler` property is nil, then use the `shouldDeselect` property.
 */
@property (nonatomic, assign) BOOL shouldDeselect;
@property (nonatomic, copy, nullable) BOOL (^shouldDeselectHandler)(id _Nullable model);
@property (nonatomic, assign) SEL shouldDeselectSEL;

/**
 *  Set the can move or not for the cell using the `canMove` property.
 *
 *  If the `canMoveHandler` property is nil, then use the `canEdit` property.
 */
@property (nonatomic, assign) BOOL canMove;
@property (nonatomic, copy, nullable) BOOL (^canMoveHandler)(id _Nullable model);
//@property (nonatomic, assign) SEL canMoveSEL;

/**
 *  If the cell did select, the `didSelectHandler` will be called.
 *
 *  If the `didSelectSEL` property is nil or the cell don't implement the `didSelectSEL` property setting method, then use the `didSelectHandler` property.
 */
@property (nonatomic, copy, nullable) void (^didSelectHandler)(id _Nullable model);
@property (nonatomic, assign) SEL didSelectSEL;

/**
 *  If the cell did deselect, the `didDeselectHandler` will be called.
 *
 *  If the `didDeselectSEL` property is nil or the cell don't implement the `didDeselectSEL` property setting method, then use the `didDeselectHandler` property.
 */
@property (nonatomic, copy, nullable) void (^didDeselectHandler)(id _Nullable model);
@property (nonatomic, assign) SEL didDeselectSEL;

/**
 *  If the cell will display, the `willDisplayHandler` will be called.
 *
 *  If the `willDisplaySEL` property is nil or the cell don't implement the `willDisplaySEL` property setting method, then use the `willDisplayHandler` property.
 */
@property (nonatomic, copy, nullable) void (^willDisplayHandler)(UICollectionViewCell *cell, id _Nullable model);
@property (nonatomic, assign) SEL willDisplaySEL;

/**
 *  If the cell did end displaying, the `didEndDisplayingHandler` will be called.
 *
 *  If the `didEndDisplayingSEL` property is nil or the cell don't implement the `didEndDisplayingSEL` property setting method, then use the `didEndDisplayingHandler` property.
 */
@property (nonatomic, copy, nullable) void (^didEndDisplayingHandler)(UICollectionViewCell *cell, id _Nullable model);
@property (nonatomic, assign) SEL didEndDisplayingSEL;

/**
 *  If the cell did highlight, the `didHighlightHandler` will be called.
 *
 *  If the `didHighlightSEL` property is nil or the cell don't implement the `didHighlightSEL` property setting method, then use the `didHighlightHandler` property.
 */
@property (nonatomic, copy, nullable) void (^didHighlightHandler)(id _Nullable model);
@property (nonatomic, assign) SEL didHighlightSEL;

/**
 *  If the cell did unhighlight, the `didUnHighlightHandler` will be called.
 *
 *  If the `didUnHighlightSEL` property is nil or the cell don't implement the `didUnHighlightSEL` property setting method, then use the `didUnHighlightHandler` property.
 */
@property (nonatomic, copy, nullable) void (^didUnHighlightHandler)(id _Nullable model);
@property (nonatomic, assign) SEL didUnHighlightSEL;

/**
 *  Set the target move index for the cell using the `targetMoveHandler` property.
 */
@property (nonatomic, copy, nullable) NSIndexPath *(^targetMoveHandler)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath);

/**
 *  If the cell is moved, the `moveHandler` will be called.
 */
@property (nonatomic, copy, nullable) void (^moveHandler)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath, void(^completionHandler)(BOOL actionPerformed));

@end

NS_ASSUME_NONNULL_END
