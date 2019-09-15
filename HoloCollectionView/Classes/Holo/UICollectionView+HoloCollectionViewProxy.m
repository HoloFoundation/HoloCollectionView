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
            NSString *reuseIdentifier = @"UICollectionReusableView";
            Class headerFooterCls = NSClassFromString(@"UICollectionReusableView");
            [self registerClass:headerFooterCls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
            [self registerClass:headerFooterCls forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifier];
            
            NSMutableDictionary *headerFooterMap = collectionViewProxy.holo_proxyData.holo_headerFooterMap.mutableCopy;
            headerFooterMap[reuseIdentifier] = headerFooterCls;
            collectionViewProxy.holo_proxyData.holo_headerFooterMap = headerFooterMap;
        }
    }
    return collectionViewProxy;
}

@end
