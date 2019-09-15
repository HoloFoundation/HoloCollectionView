//
//  HOLOViewController.m
//  HoloCollectionView
//
//  Created by gonghonglou on 09/13/2019.
//  Copyright (c) 2019 gonghonglou. All rights reserved.
//

#import "HOLOViewController.h"
#import <HoloCollectionView/HoloCollectionView.h>

@interface HOLOViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HOLOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView holo_configureCollectionView:^(HoloCollectionViewConfiger * _Nonnull configer) {
        configer.cell(@"one").cls(@"HoloExampleOneCollectionViewCell");
    }];
    
    [self.collectionView holo_makeRows:^(HoloCollectionViewRowMaker * _Nonnull make) {
        make.row(@"one").size(CGSizeMake((HOLO_SCREEN_WIDTH-30)/2, 200));
        make.row(@"one");
        make.row(@"one");
        make.row(@"one").didSelectHandler(^(id  _Nonnull model) {
            NSLog(@"----%@", model);
        });
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.collectionView holo_makeRows:^(HoloCollectionViewRowMaker * _Nonnull make) {
        make.row(@"HoloExampleOneCollectionViewCell");
    } autoReload:YES];
}


#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake((HOLO_SCREEN_WIDTH-30)/2, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        CGRect frame = CGRectMake(0, 88, HOLO_SCREEN_WIDTH, HOLO_SCREEN_HEIGHT-88);
        _collectionView.frame = frame;
    }
    return _collectionView;
}

@end
