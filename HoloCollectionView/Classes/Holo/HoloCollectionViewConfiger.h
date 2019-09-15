//
//  HoloCollectionViewConfiger.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kHoloCellClsMap = @"holo_cell_cls_map";
static NSString * const kHoloSectionIndexTitles = @"holo_section_index_titles";
static NSString * const kHoloIndexPathForIndexTitleHandler = @"holo_indexPath_for_index_title_handler";


////////////////////////////////////////////////////////////
@interface HoloCollectionViewCellConfiger : NSObject

@property (nonatomic, copy) NSString *cellName;

@property (nonatomic, copy) NSString *clsName;

@property (nonatomic, copy, readonly) HoloCollectionViewCellConfiger *(^cls)(NSString *cls);

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewConfiger : NSObject

@property (nonatomic, copy, readonly) HoloCollectionViewCellConfiger *(^cell)(NSString *cell);

@property (nonatomic, copy, readonly) HoloCollectionViewConfiger *(^sectionIndexTitles)(NSArray<NSString *> *sectionIndexTitles);

@property (nonatomic, copy, readonly) HoloCollectionViewConfiger *(^indexPathForIndexTitleHandler)(NSIndexPath *(^handler)(NSString *title, NSInteger index));

- (NSDictionary *)install;

@end

NS_ASSUME_NONNULL_END
