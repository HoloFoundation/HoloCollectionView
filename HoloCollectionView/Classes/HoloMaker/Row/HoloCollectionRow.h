//
//  HoloCollectionRow.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

@property (nonatomic, copy) NSString *(^reuseIdHandler)(id _Nullable model);

@property (nonatomic, copy) CGSize (^sizeHandler)(id _Nullable model);

@property (nonatomic, copy) BOOL (^shouldHighlightHandler)(id _Nullable model);

@property (nonatomic, copy) BOOL (^shouldSelectHandler)(id _Nullable model);

@property (nonatomic, copy) BOOL (^shouldDeselectHandler)(id _Nullable model);

@property (nonatomic, copy) BOOL (^canMoveHandler)(id _Nullable model);

@property (nonatomic, copy) void (^didSelectHandler)(id _Nullable model);

@property (nonatomic, copy) void (^didDeselectHandler)(id _Nullable model);

@property (nonatomic, copy) void (^beforeConfigureHandler)(UICollectionViewCell *cell, id _Nullable model);

@property (nonatomic, copy) void (^afterConfigureHandler)(UICollectionViewCell *cell, id _Nullable model);

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

//@property (nonatomic, assign) SEL canMoveSEL;

@property (nonatomic, assign) SEL didSelectSEL;

@property (nonatomic, assign) SEL didDeselectSEL;

@property (nonatomic, assign) SEL willDisplaySEL;

@property (nonatomic, assign) SEL didEndDisplayingSEL;

@property (nonatomic, assign) SEL didHighlightSEL;

@property (nonatomic, assign) SEL didUnHighlightSEL;

@end

NS_ASSUME_NONNULL_END
