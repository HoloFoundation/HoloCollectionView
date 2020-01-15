//
//  HoloViewController.m
//  HoloCollectionView
//
//  Created by gonghonglou on 09/13/2019.
//  Copyright (c) 2019 gonghonglou. All rights reserved.
//

#import "HoloViewController.h"
#import <HoloCollectionView/HoloCollectionView.h>
#import "HoloExampleHeaderView.h"
#import "HoloExampleFooterView.h"
#import "HoloExampleCollectionViewCell.h"

@interface HoloViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HoloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 44, HOLO_SCREEN_WIDTH - 100, 44);
    [button setTitle:@"add a cell" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(@"a")
        .header(HoloExampleHeaderView.class).headerSize(CGSizeMake(HOLO_SCREEN_WIDTH, 100))
        .footer(HoloExampleFooterView.class).footerSize(CGSizeMake(HOLO_SCREEN_WIDTH, 100))
        .makeRows(^(HoloCollectionViewRowMaker * _Nonnull make) {
            make.row(HoloExampleCollectionViewCell.class).model(@{@"bgColor": [UIColor lightGrayColor], @"text": @"cell"});
        });
    }];
    
    [self.collectionView holo_makeRows:^(HoloCollectionViewRowMaker * _Nonnull make) {
        for (NSDictionary *dict in [self _modelsFromOtherWay]) {
            make.row(HoloExampleCollectionViewCell.class)
            .model(dict)
            .didSelectHandler(^(id  _Nonnull model) {
                NSLog(@"did select model : %@", model);
            });
        }
    }];
    
    [self.collectionView reloadData];
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)sender {
    [self.collectionView holo_insertRowsAtIndex:0 inSection:@"a" block:^(HoloCollectionViewRowMaker * _Nonnull make) {
        make.row(HoloExampleCollectionViewCell.class);
    } autoReload:YES];
}

- (NSArray *)_modelsFromOtherWay {
    return @[
        @{@"bgColor": [UIColor yellowColor],   @"text": @"cell-1"},
        @{@"bgColor": [UIColor cyanColor],     @"text": @"cell-2"},
        @{@"bgColor": [UIColor orangeColor],   @"text": @"cell-3"}
    ];
}

#pragma mark-getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake((HOLO_SCREEN_WIDTH-30)/2, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        CGRect frame = CGRectMake(0, 100, HOLO_SCREEN_WIDTH, HOLO_SCREEN_HEIGHT-100);
        _collectionView.frame = frame;
    }
    return _collectionView;
}

@end
