//
//  HoloCollectionViewMacro.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#ifndef HoloCollectionViewMacro_h
#define HoloCollectionViewMacro_h

#ifdef DEBUG
#define HoloLog(...) NSLog(__VA_ARGS__)
#else
#define HoloLog(...)
#endif

#endif /* HoloCollectionViewMacro_h */
