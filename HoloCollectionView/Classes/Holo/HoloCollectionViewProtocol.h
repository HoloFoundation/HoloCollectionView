//
//  HoloCollectionViewProtocol.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#ifndef HoloCollectionViewProtocol_h
#define HoloCollectionViewProtocol_h

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////
@protocol HoloCollectionViewCellProtocol <NSObject>

@optional

- (void)holo_configureCellWithModel:(id)model;

+ (CGSize)holo_sizeForCellWithModel:(id)model;

+ (CGSize)holo_shouldHighlightWithModel:(id)model;

+ (CGSize)holo_shouldSelectWithModel:(id)model;

+ (CGSize)holo_shouldDeselectWithModel:(id)model;

+ (CGSize)holo_canMoveWithModel:(id)model;

+ (CGSize)holo_didSelectWithModel:(id)model;

+ (CGSize)holo_didDeselectWithModel:(id)model;

+ (CGSize)holo_willDisplayForCell:(UICollectionViewCell *)cell withModel:(id)model;

+ (CGSize)holo_didEndDisplayingForCell:(UICollectionViewCell *)cell withModel:(id)model;

+ (CGSize)holo_didHighlightWithModel:(id)model;

+ (CGSize)holo_didUnHighlightWithModel:(id)model;

@end

////////////////////////////////////////////////////////////
@protocol HoloCollectionViewHeaderProtocol <NSObject>

@optional

- (void)holo_configureHeaderWithModel:(id)model;

+ (CGSize)holo_sizeForHeaderWithModel:(id)model;

+ (void)holo_willDisplayHeaderWithModel:(id)model;

+ (void)holo_didEndDisplayingHeaderWithModel:(id)model;

@end

////////////////////////////////////////////////////////////
@protocol HoloCollectionViewFooterProtocol <NSObject>

@optional

- (void)holo_configureFooterWithModel:(id)model;

+ (CGSize)holo_sizeForFooterWithModel:(id)model;

+ (void)holo_willDisplayFooterWithModel:(id)model;

+ (void)holo_didEndDisplayingFooterWithModel:(id)model;

@end

////////////////////////////////////////////////////////////
@protocol HoloCollectionViewHeaderFooterProtocol <NSObject>
@optional
- (void)holo_configureHeaderFooterWithModel:(id)model DEPRECATED_MSG_ATTRIBUTE("Please use `headerConfigSEL` or `footerConfigSEL` api instead.");
+ (CGSize)holo_sizeForHeaderFooterWithModel:(id)model DEPRECATED_MSG_ATTRIBUTE("Please use `headerSizeSEL` or `footerSizeSEL` api instead.");
@end

////////////////////////////////////////////////////////////
@protocol HoloCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>


@end

////////////////////////////////////////////////////////////
@protocol HoloCollectionViewDataSource <NSObject>

@optional

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0);

/// Returns a list of index titles to display in the index view (e.g. ["A", "B", "C" ... "Z", "#"])
- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView API_AVAILABLE(tvos(10.2));

/// Returns the index path that corresponds to the given title / index. (e.g. "B",1)
/// Return an index path with a single index to indicate an entire section, instead of a specific item.
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index API_AVAILABLE(tvos(10.2));

@end

NS_ASSUME_NONNULL_END

#endif /* HoloCollectionViewProtocol_h */
