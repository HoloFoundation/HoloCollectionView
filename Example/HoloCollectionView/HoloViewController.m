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

#define HOLO_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define HOLO_SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

@interface HoloViewController ()

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *modelArray;

@end

@implementation HoloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.collectionView];
    
    [self makeSectionByMaker];
    
//    [self makeRowListWithDefaultSection];
    
//    [self makeSectionListByObject];
}

#pragma mark - Maker

- (void)makeSectionByMaker {
    [self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
        make.section(TAG)
        .header(HoloExampleHeaderView.class).headerSize(CGSizeMake(HOLO_SCREEN_WIDTH, 100))
        .footer(HoloExampleFooterView.class).footerSize(CGSizeMake(HOLO_SCREEN_WIDTH, 100))
        .makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
            for (NSDictionary *dict in self.modelArray) {
                make.item(HoloExampleCollectionViewCell.class).model(dict).didSelectHandler(^(id  _Nullable model) {
                    NSLog(@"did select row : %@", model);
                });
            }
        });
    }];
    // make.section(@"1")
    // make.section(@"2")
    // ...
    [self.collectionView reloadData];
}

- (void)insertItemToSectionWithAutoReload {
    [self.collectionView holo_insertItemsAtIndex:0 inSection:TAG block:^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(HoloExampleCollectionViewCell.class);
    } autoReload:YES];
}

- (void)makeRowListWithDefaultSection {
    [self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
        for (NSDictionary *dict in self.modelArray) {
            make.item(HoloExampleCollectionViewCell.class).model(dict).didSelectHandler(^(id  _Nullable model) {
                NSLog(@"did select row : %@", model);
            });
        }
    }];
    [self.collectionView reloadData];
}


#pragma mark - Object

- (void)makeSectionListByObject {
    HoloCollectionSection *section = [HoloCollectionSection new];
    section.tag = TAG;
    
    section.header = HoloExampleHeaderView.class;
    section.headerModel = @{@"title":@"header"};
    section.headerSize = CGSizeMake(HOLO_SCREEN_WIDTH, 100);
    
    section.footer = HoloExampleFooterView.class;
    section.footerModel = @{@"title":@"footer"};
    section.footerSize = CGSizeMake(HOLO_SCREEN_WIDTH, 100);
    
    NSMutableArray *items = [NSMutableArray new];
    for (NSDictionary *dict in self.modelArray) {
        HoloCollectionItem *item = [HoloCollectionItem new];
        item.cell = HoloExampleCollectionViewCell.class;
        item.model = dict;
        [items addObject:item];
    }
    section.items = items;
    
    self.collectionView.holo_sections = @[section];
    [self.collectionView reloadData];
}


#pragma mark - buttonAction

- (void)_addButtonAction:(UIButton *)sender {
    [self insertItemToSectionWithAutoReload];
}

#pragma mark - getter

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _addButton.frame = CGRectMake(50, 44, HOLO_SCREEN_WIDTH - 100, 44);
        [_addButton setTitle:@"add a cell" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(_addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake((HOLO_SCREEN_WIDTH-30)/2, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        CGRect frame = CGRectMake(0, 100, HOLO_SCREEN_WIDTH, HOLO_SCREEN_HEIGHT - 100);
        _collectionView.frame = frame;
    }
    return _collectionView;
}

- (NSArray *)modelArray {
    if (!_modelArray) {
        _modelArray = @[
            @{@"bgColor": [UIColor yellowColor],   @"text": @"cell-1"},
            @{@"bgColor": [UIColor cyanColor],     @"text": @"cell-2"},
            @{@"bgColor": [UIColor orangeColor],   @"text": @"cell-3"}
        ];
    }
    return _modelArray;
}

@end
