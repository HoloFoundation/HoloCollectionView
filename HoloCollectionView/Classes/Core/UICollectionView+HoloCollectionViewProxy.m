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

- (NSArray<HoloCollectionSection *> *)holo_sections {
    return self.holo_proxy.proxyData.sections;
}

- (void)setHolo_sections:(NSArray<HoloCollectionSection *> *)holo_sections {
    self.holo_proxy.proxyData.sections = holo_sections;
}

- (NSArray<NSString *> *)holo_sectionIndexTitles {
    return self.holo_proxy.proxyData.sectionIndexTitles;
}

- (void)setHolo_sectionIndexTitles:(NSArray<NSString *> *)holo_sectionIndexTitles {
    self.holo_proxy.proxyData.sectionIndexTitles = holo_sectionIndexTitles;
}

- (NSIndexPath * _Nonnull (^)(NSString * _Nonnull, NSInteger))holo_indexPathForIndexTitleHandler {
    return self.holo_proxy.proxyData.indexPathForIndexTitleHandler;
}

- (void)setHolo_indexPathForIndexTitleHandler:(NSIndexPath * _Nonnull (^)(NSString * _Nonnull, NSInteger))holo_indexPathForIndexTitleHandler {
    self.holo_proxy.proxyData.indexPathForIndexTitleHandler = holo_indexPathForIndexTitleHandler;
}

- (id<UIScrollViewDelegate>)holo_scrollDelegate {
    return self.holo_proxy.scrollDelegate;
}

- (void)setHolo_scrollDelegate:(id<UIScrollViewDelegate>)holo_scrollDelegate {
    self.holo_proxy.scrollDelegate = holo_scrollDelegate;
}

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

- (void)setHolo_proxy:(HoloCollectionViewProxy * _Nonnull)holo_proxy {
    HoloCollectionViewProxy *collectionViewProxy = [[HoloCollectionViewProxy alloc] initWithCollectionView:self];
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

@end
