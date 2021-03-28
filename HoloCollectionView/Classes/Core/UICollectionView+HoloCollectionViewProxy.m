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
        
        self.dataSource = collectionViewProxy;
        self.delegate = collectionViewProxy;
        
        // register UICollectionReusableView
        Class cls = UICollectionReusableView.class;
        NSString *key = NSStringFromClass(cls);
        // headersMap
        if (!collectionViewProxy.proxyData.headersMap[key]) {
            [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:key];
            NSMutableDictionary *headersMap = collectionViewProxy.proxyData.headersMap.mutableCopy;
            headersMap[key] = cls;
            collectionViewProxy.proxyData.headersMap = headersMap;
        }
        // footersMap
        if (!collectionViewProxy.proxyData.footersMap[key]) {
            [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:key];
            NSMutableDictionary *footersMap = collectionViewProxy.proxyData.footersMap.mutableCopy;
            footersMap[key] = cls;
            collectionViewProxy.proxyData.footersMap = footersMap;
        }
    }
    return collectionViewProxy;
}

@end
