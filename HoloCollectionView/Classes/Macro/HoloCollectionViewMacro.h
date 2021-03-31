//
//  HoloCollectionViewMacro.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#ifndef HoloCollectionViewMacro_h
#define HoloCollectionViewMacro_h

#if !defined(TAG)
#define TAG @"HOLO_DEFAULT_TAG"
#endif

#if !defined(HoloLog)
#ifdef DEBUG
#define HoloLog(...) NSLog(__VA_ARGS__)
#else
#define HoloLog(...)
#endif
#endif

#endif /* HoloCollectionViewMacro_h */
