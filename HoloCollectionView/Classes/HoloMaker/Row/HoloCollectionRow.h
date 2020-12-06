//
//  HoloCollectionRow.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoloCollectionRow : NSObject

@property (nonatomic, copy, nullable) NSString *cell;

#pragma mark - priority low
@property (nonatomic, strong, nullable) id model;

@property (nonatomic, copy, nullable) NSString *reuseId;

@property (nonatomic, copy, nullable) NSString *tag;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) BOOL shouldHighlight;

@property (nonatomic, assign) BOOL shouldSelect;

@property (nonatomic, assign) BOOL shouldDeselect;

@property (nonatomic, assign) BOOL canMove;

#pragma mark - priority middle
@property (nonatomic, copy, nullable) id (^modelHandler)(void);

@property (nonatomic, copy, nullable) NSString *(^reuseIdHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) CGSize (^sizeHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) BOOL (^shouldHighlightHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) BOOL (^shouldSelectHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) BOOL (^shouldDeselectHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) BOOL (^canMoveHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) void (^didSelectHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) void (^didDeselectHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) void (^beforeConfigureHandler)(UICollectionViewCell *cell, id _Nullable model);

@property (nonatomic, copy, nullable) void (^afterConfigureHandler)(UICollectionViewCell *cell, id _Nullable model);

@property (nonatomic, copy, nullable) void (^willDisplayHandler)(UICollectionViewCell *cell, id _Nullable model);

@property (nonatomic, copy, nullable) void (^didEndDisplayingHandler)(UICollectionViewCell *cell, id _Nullable model);

@property (nonatomic, copy, nullable) void (^didHighlightHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) void (^didUnHighlightHandler)(id _Nullable model);

@property (nonatomic, copy, nullable) NSIndexPath *(^targetMoveHandler)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath);

@property (nonatomic, copy, nullable) void (^moveHandler)(NSIndexPath *atIndexPath, NSIndexPath *toIndexPath, void(^completionHandler)(BOOL actionPerformed));

#pragma mark - priority high
@property (nonatomic, assign) SEL configSEL;

@property (nonatomic, assign) SEL sizeSEL;

@property (nonatomic, assign) SEL shouldHighlightSEL;

@property (nonatomic, assign) SEL shouldSelectSEL;

@property (nonatomic, assign) SEL shouldDeselectSEL;

//@property (nonatomic, assign) SEL canMoveSEL;

@property (nonatomic, assign) SEL didSelectSEL;

@property (nonatomic, assign) SEL didDeselectSEL;

@property (nonatomic, assign) SEL willDisplaySEL;

@property (nonatomic, assign) SEL didEndDisplayingSEL;

@property (nonatomic, assign) SEL didHighlightSEL;

@property (nonatomic, assign) SEL didUnHighlightSEL;

@end

NS_ASSUME_NONNULL_END
