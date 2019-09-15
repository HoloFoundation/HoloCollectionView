# HoloCollectionView

[![CI Status](https://img.shields.io/travis/gonghonglou/HoloCollectionView.svg?style=flat)](https://travis-ci.org/gonghonglou/HoloCollectionView)
[![Version](https://img.shields.io/cocoapods/v/HoloCollectionView.svg?style=flat)](https://cocoapods.org/pods/HoloCollectionView)
[![License](https://img.shields.io/cocoapods/l/HoloCollectionView.svg?style=flat)](https://cocoapods.org/pods/HoloCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/HoloCollectionView.svg?style=flat)](https://cocoapods.org/pods/HoloCollectionView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

If you want to set the model to your UICollectionViewCell or change it's height according to the model, the UICollectionViewCell could conform to protocol: `HoloCollectionViewCellProtocol` and implement their selectors: 

```objective-c
- (void)configureCellWithModel:(id)model;

+ (CGSize)sizeForCellWithModel:(id)model;
```

## Usage

```objective-c
UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
flowLayout.minimumLineSpacing = 10;
flowLayout.minimumInteritemSpacing = 10;
flowLayout.itemSize = CGSizeMake((HOLO_SCREEN_WIDTH-30)/2, 100);

UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
collectionView.backgroundColor = [UIColor whiteColor];
[self.view addSubview:collectionView];

[collectionView holo_makeRows:^(HoloCollectionViewRowMaker * _Nonnull make) {
    // one cell
    make.row(@"OneCollectionViewCell").model(@{@"key":@"value1"});
    make.row(@"OneCollectionViewCell").model(@{@"key":@"value1"});

    // two cell
    make.row(@"TwoCollectionViewCell").size(CGSizeMake(100, 200));

    // three cell
    make.row(@"ThreeCollectionViewCell").didSelectHandler(^(id  _Nonnull model) {
        NSLog(@"did select row, model: %@", model);
    });
} autoReload:YES];

// etc...
```

## Installation

HoloCollectionView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HoloCollectionView'
```

## Author

gonghonglou, gonghonglou@icloud.com

## License

HoloCollectionView is available under the MIT license. See the LICENSE file for more info.


