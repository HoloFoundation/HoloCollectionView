//
//  HoloExampleOneCollectionViewCell.m
//  HoloCollectionView_Example
//
//  Created by 与佳期 on 2019/9/15.
//  Copyright © 2019 gonghonglou. All rights reserved.
//

#import "HoloExampleOneCollectionViewCell.h"
#import <HoloCollectionView/HoloCollectionViewProtocol.h>

@interface HoloExampleOneCollectionViewCell () <HoloCollectionViewCellProtocol>

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HoloExampleOneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)holo_configureCellWithModel:(id)model {
    self.contentView.backgroundColor = model[@"bgColor"] ?: [UIColor redColor];
    self.titleLabel.text = model[@"text"] ?: nil;
}


#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = self.contentView.bounds;
    }
    return _titleLabel;
}

@end
