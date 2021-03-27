//
//  UICollectionView+HoloDeprecated.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2021/2/16.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+HoloCollectionView.h"
#import "HoloCollectionViewRowMaker.h"
#import "HoloCollectionViewUpdateRowMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (HoloDeprecated)

#pragma mark - row
/**
 *  Creates a HoloCollectionViewRowMaker in the callee for current UICollectionView.
 *  Append these rows in the callee to defult section of UICollectionView.
 *  If current UICollectionView don't contain any section, create a new one and append it to the data source.
 *
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 */
- (void)holo_makeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block DEPRECATED_MSG_ATTRIBUTE("Please use `holo_makeItems:` api instead.");

/**
 *  Creates a HoloCollectionViewRowMaker in the callee for current UICollectionView.
 *  Append these rows in the callee to defult section of UICollectionView.
 *  If current UICollectionView don't contain any section, create a new one and append it to the data source.
 *
 *  Refresh current UICollectionView automatically.
 *
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 *  @param autoReload Auto reload view if YES.
 */
- (void)holo_makeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block
           autoReload:(BOOL)autoReload DEPRECATED_MSG_ATTRIBUTE("Please use `holo_makeItems:autoReload:` api instead.");

/**
 *  Creates a HoloCollectionViewRowMaker in the callee for current UICollectionView.
 *  Append these rows in the callee to a section according to the tag.
 *  If current UICollectionView don't contain a section with the tag, create a new one with the tag and append it to the data source.
 *
 *  @param tag The tag of section which you wish to append rows.
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 */
- (void)holo_makeRowsInSection:(NSString *)tag
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block DEPRECATED_MSG_ATTRIBUTE("Please use `holo_makeItemsInSection:block:` api instead.");

/**
 *  Creates a HoloCollectionViewRowMaker in the callee for current UICollectionView.
 *  Append these rows in the callee to a section according to the tag.
 *  If current UICollectionView don't contain a section with the tag, create a new one with the tag and append it to the data source.
 *
 *  Refresh current UICollectionView automatically.
 *
 *  @param tag The tag of section which you wish to append rows.
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 *  @param autoReload Auto reload view if YES.
 */
- (void)holo_makeRowsInSection:(NSString *)tag
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block
                    autoReload:(BOOL)autoReload DEPRECATED_MSG_ATTRIBUTE("Please use `holo_makeItemsInSection:block:autoReload:` api instead.");

/**
 *  Creates a HoloCollectionViewRowMaker in the callee for current UICollectionView.
 *  Append these rows in the callee to defult section of UICollectionView.
 *  If current UICollectionView don't contain any section, create a new one and append it to the data source.
 *
 *  @param index The index in the array at which to insert rows. If this value is less than 0, insert an first index; if this value is greater than the count of elements in the array, insert an last index.
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 */
- (void)holo_insertRowsAtIndex:(NSInteger)index
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block DEPRECATED_MSG_ATTRIBUTE("Please use `holo_insertItemsAtIndex:block:` api instead.");

/**
 *  Creates a HoloCollectionViewRowMaker in the callee for current UICollectionView.
 *  Insert these rows in the callee to defult section of UICollectionView.
 *  If current UICollectionView don't contain any section, create a new one and append it to the data source.
 *
 *  Refresh current UICollectionView automatically.
 *
 *  @param index The index in the array at which to insert rows. If this value is less than 0, insert an first index; if this value is greater than the count of elements in the array, insert an last index.
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 *  @param autoReload Auto reload view if YES.
 */
- (void)holo_insertRowsAtIndex:(NSInteger)index
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block
                    autoReload:(BOOL)autoReload DEPRECATED_MSG_ATTRIBUTE("Please use `holo_insertItemsAtIndex:block:autoReload:` api instead.");

/**
 *  Creates a HoloCollectionViewRowMaker in the callee for current UICollectionView.
 *  Insert these rows in the callee to a section according to the tag.
 *  If current UICollectionView don't contain a section with the tag, create a new one with the tag and append it to the data source.
 *
 *  @param index The index in the array at which to insert rows. If this value is less than 0, insert an first index; if this value is greater than the count of elements in the array, insert an last index.
 *  @param tag The tag of section which you wish to append rows.
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 */
- (void)holo_insertRowsAtIndex:(NSInteger)index
                     inSection:(NSString *)tag
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block DEPRECATED_MSG_ATTRIBUTE("Please use `holo_insertItemsAtIndex:inSection:block:` api instead.");

/**
 *  Creates a HoloCollectionViewRowMaker in the callee for current UICollectionView.
 *  Insert these rows in the callee to a section according to the tag.
 *  If current UICollectionView don't contain a section with the tag, create a new one with the tag and append it to the data source.
 *
 *  Refresh current UICollectionView automatically.
 *
 *  @param index The index in the array at which to insert rows. If this value is less than 0, insert an first index; if this value is greater than the count of elements in the array, insert an last index.
 *  @param tag The tag of section which you wish to append rows.
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 *  @param autoReload Auto reload view if YES.
 */
- (void)holo_insertRowsAtIndex:(NSInteger)index
                     inSection:(NSString *)tag
                         block:(void(NS_NOESCAPE ^)(HoloCollectionViewRowMaker *make))block
                    autoReload:(BOOL)autoReload DEPRECATED_MSG_ATTRIBUTE("Please use `holo_insertItemsAtIndex:inSection:block:autoReload:` api instead.");

/**
 *  Creates a HoloCollectionViewUpdateRowMaker in the callee for current UICollectionView.
 *  Update these rows in the callee for current UICollectionView.
 *  If current UICollectionView don't contain these rows, ignore them.
 *
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 */
- (void)holo_updateRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block DEPRECATED_MSG_ATTRIBUTE("Please use `holo_updateRows:` api instead.");

/**
 *  Creates a HoloCollectionViewUpdateRowMaker in the callee for current UICollectionView.
 *  Update these rows in the callee for current UICollectionView.
 *  If current UICollectionView don't contain these rows, ignore them.
 *
 *  Refresh current UICollectionView automatically.
 *
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 *  @param autoReload Auto reload view if YES.
 */
- (void)holo_updateRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block
             autoReload:(BOOL)autoReload DEPRECATED_MSG_ATTRIBUTE("Please use `holo_updateRows:autoReload:` api instead.");

/**
 *  Creates a HoloCollectionViewUpdateRowMaker in the callee for current UICollectionView.
 *  Remake these rows (Reinit all properties) in the callee for current UICollectionView.
 *  If current UICollectionView don't contain these rows, ignore them.
 *
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 */
- (void)holo_remakeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block DEPRECATED_MSG_ATTRIBUTE("Please use `holo_remakeRows:` api instead.");

/**
 *  Creates a HoloCollectionViewUpdateRowMaker in the callee for current UICollectionView.
 *  Remake these rows (Reinit all properties) in the callee for current UICollectionView.
 *  If current UICollectionView don't contain these rows, ignore them.
 *
 *  Refresh current UICollectionView automatically.
 *
 *  @param block Scope within which you can create some rows which you wish to apply to current UICollectionView.
 *  @param autoReload Auto reload view if YES.
 */
- (void)holo_remakeRows:(void(NS_NOESCAPE ^)(HoloCollectionViewUpdateRowMaker *make))block
             autoReload:(BOOL)autoReload DEPRECATED_MSG_ATTRIBUTE("Please use `holo_remakeRows:autoReload:` api instead.");

/**
 *  Remove all rows in the sections according to the tags.
 *
 *  @param tags The tags of sections which you wish to remove all rows.
 */
- (void)holo_removeAllRowsInSections:(NSArray<NSString *> *)tags DEPRECATED_MSG_ATTRIBUTE("Please use `holo_removeAllRowsInSections:` api instead.");

/**
 *  Remove all rows in the sections according to the tags.
 *
 *  @param tags The tags of sections which you wish to remove all rows.
 *  @param autoReload Auto reload view if YES.
 */
- (void)holo_removeAllRowsInSections:(NSArray<NSString *> *)tags
                          autoReload:(BOOL)autoReload DEPRECATED_MSG_ATTRIBUTE("Please use `holo_removeAllRowsInSections:autoReload:` api instead.");

/**
 *  Remove the rows according to the tags in all sections.
 *
 *  @param tags The tags of rows which you wish to remove.
 */
- (void)holo_removeRows:(NSArray<NSString *> *)tags DEPRECATED_MSG_ATTRIBUTE("Please use `holo_removeRows:` api instead.");

/**
 *  Remove the rows according to the tags in all sections.
 *
 *  Refresh current UICollectionView automatically.
 *
 *  @param tags The tags of rows which you wish to remove.
 *  @param autoReload Auto reload view if YES.
 */
- (void)holo_removeRows:(NSArray<NSString *> *)tags
             autoReload:(BOOL)autoReload DEPRECATED_MSG_ATTRIBUTE("Please use `holo_removeRows:autoReload:` api instead.");

@end

NS_ASSUME_NONNULL_END
