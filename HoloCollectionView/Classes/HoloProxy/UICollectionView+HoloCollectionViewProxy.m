//
//  UICollectionView+HoloCollectionViewProxy.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/13.
//

#import "UICollectionView+HoloCollectionViewProxy.h"
#import <objc/runtime.h>
#import "HoloCollectionViewProxy.h"
#import "HoloCollectionViewProxyData.h"

static char kHoloCollectionViewProxyKey;

@implementation UICollectionView (HoloCollectionViewProxy)

- (HoloCollectionViewProxy *)holo_proxy {
    HoloCollectionViewProxy *collectionViewProxy = objc_getAssociatedObject(self, &kHoloCollectionViewProxyKey);
    if (!collectionViewProxy) {
        collectionViewProxy = [[HoloCollectionViewProxy alloc] initWithCollectionView:self];
        objc_setAssociatedObject(self, &kHoloCollectionViewProxyKey, collectionViewProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (!self.dataSource || !self.delegate) {
            self.dataSource = collectionViewProxy;
            self.delegate = collectionViewProxy;
            
            // register UICollectionReusableView
            Class headerFooterCls = UICollectionReusableView.class;
            NSString *headerFooter = NSStringFromClass(headerFooterCls);
            [self registerClass:headerFooterCls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFooter];
            [self registerClass:headerFooterCls forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headerFooter];
            
            NSMutableDictionary *headerFootersMap = collectionViewProxy.proxyData.headerFootersMap.mutableCopy;
            headerFootersMap[headerFooter] = headerFooterCls;
            collectionViewProxy.proxyData.headerFootersMap = headerFootersMap;
        }
    }
    return collectionViewProxy;
}

@end
