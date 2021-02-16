# HoloCollectionView

[![CI Status](https://img.shields.io/travis/HoloFoundation/HoloCollectionView.svg?style=flat)](https://travis-ci.org/HoloFoundation/HoloCollectionView)
[![Version](https://img.shields.io/cocoapods/v/HoloCollectionView.svg?style=flat)](https://cocoapods.org/pods/HoloCollectionView)
[![License](https://img.shields.io/cocoapods/l/HoloCollectionView.svg?style=flat)](https://cocoapods.org/pods/HoloCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/HoloCollectionView.svg?style=flat)](https://cocoapods.org/pods/HoloCollectionView)


`HoloCollectionView` provides chained syntax calls that encapsulate delegate methods for `UICollectionView`. The delegate methods for `UICollectionView` is distributed to each `cell`, each `cell` having its own method for setting Class, model, size, and click event, etc.


## Features

- [x] Provide section and item maker to handle proxy events of `HoloCollectionView`.
- [x] Provide protocols, implemented in cells, headers and footers to handle proxy events of `HoloCollectionView`.
- [x] Support to regist maps (key-Class) for item, header and footer.
- [x] Diff reload data. [HoloCollectionViewDiffPlugin](https://github.com/HoloFoundation/HoloCollectionViewDiffPlugin) to support `DeepDiff`
- [ ] Adapt new APIs from iOS 13 and iOS 14.
- [ ] Modern Objective-C and better Swift support.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Integration with 3rd party libraries

- [HoloCollectionViewDiffPlugin](https://github.com/HoloFoundation/HoloCollectionViewDiffPlugin) - plugin to support [DeepDiff](https://github.com/onmyway133/DeepDiff), diff reload a section of `UICollectionView`. `DeepDiff` tells the difference between 2 collections and the changes as edit steps.

## Usage

[中文介绍](https://github.com/HoloFoundation/HoloCollectionView/blob/master/README_CN.md)、[文章介绍](http://gonghonglou.com/2020/08/10/HoloTableView-HoloCollectionView/)

### 1. Make a simple cell list

```objc
UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
flowLayout...

UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
[self.view addSubview:collectionView];

[collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
    // make a cell
    make.item(ExampleCollectionViewCell.class).model(NSDictionary.new).size(CGSizeMake(100, 200));
    
    // make a list
    for (NSObject *obj in NSArray.new) {
        make.item(ExampleCollectionViewCell.class).model(obj).didSelectHandler(^(id  _Nullable model) {
            NSLog(@"did select item : %@", model);
        });
    }
}];

[collectionView reloadData];

// etc.
```

The `holo_makeItems:` method is used to create a list of items. Each `item` is a `cell`. **More properties provided for item see: [HoloCollectionViewItemMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Item/HoloCollectionViewItemMaker.h) and [HoloCollectionItemMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Item/HoloCollectionItemMaker.h)**


#### Requirements for cell

Conforms to protocol `HoloCollectionViewCellProtocol`, `HoloCollectionView` will automatically identify `cell` whether implement these methods and calls, the commonly used two methods:

```objc
@required

// set the model to cell
// the model is the object passed in by make.model()
- (void)holo_configureCellWithModel:(id)model;


@optional

// return cell size（ Priority is higher than: 'sizeHandler' and 'size' of maker）
// the model is the object passed in by make.model()
+ (CGSize)holo_sizeForCellWithModel:(id)model;
```

**See `HoloCollectionViewCellProtocol` more methods: [HoloCollectionViewCellProtocol](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/Holo/HoloProtocol/HoloCollectionViewCellProtocol.h)**

You can also call your own methods by configuring properties such as `configSEL`, `sizeSEL`, etc. More properties can find in [HoloCollectionItemMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Item/HoloCollectionItemMaker.h).

Note that attributes such as `size`, `shouldHighlight`, etc. that exist `SEL` have priority:
1. First judge whether `cell` implements `sizeSEL` method
2. Secondly, verify the implementation of the `sizeHandler` block
3. Finally, determine whether the property `size` is assigned


### 2. Make a section list (contain header, footer, item)

```objc
UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
flowLayout...

UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
[self.view addSubview:collectionView];

[collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    make.section(TAG)
    .header(ExampleHeaderView.class).headerSize(CGSizeMake(HOLO_SCREEN_WIDTH, 100))
    .footer(ExampleFooterView.class).footerSize(CGSizeMake(HOLO_SCREEN_WIDTH, 100))
    .makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
        // make a cell
        make.item(ExampleCollectionViewCell.class).model(NSDictionary.new).size(CGSizeMake(100, 200));
        
        // make a list
        for (NSObject *obj in NSArray.new) {
            make.item(ExampleCollectionViewCell.class).model(obj).didSelectHandler(^(id  _Nullable model) {
                NSLog(@"did select item : %@", model);
            });
        }
    });
}];

[collectionView reloadData];
```

The `holo_makeSections:` method is used to create a list of `section`. **More properties provided for section see: [HoloCollectionViewSectionMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Section/HoloCollectionViewSectionMaker.h) and  [HoloCollectionSectionMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Section/HoloCollectionSectionMaker.h)**


#### Requirements for header and footer

1. header: conforms to protocol `HoloCollectionViewHeaderProtocol` , implement these methods, the commonly used two methods:

```objc
@required

// set the model to header
// the model is the object passed in by make.headerModel()
- (void)holo_configureHeaderWithModel:(id)model;

@optional
    
// return header size（ Priority is higher than: 'headerSizeHandler' and 'headerSize' of maker）
// the model is the object passed in by make.headerModel()
+ (CGSize)holo_sizeForHeaderWithModel:(id)model;
```

2. Footer: conforms to protocol `HoloCollectionViewFooterProtocol` , implement these methods, the commonly used two methods:

```objc
@required

// set the model to footer
// the model is the object passed in by make.footerModel()
- (void)holo_configureFooterWithModel:(id)model;

@optional

// return footer size（ Priority is higher than: 'footerSizeHandler' and 'footerSize' of maker）
// the model is the object passed in by make.footerModel()
+ (CGSize)holo_sizeForFooterWithModel:(id)model;
```

**See `HoloCollectionViewHeaderProtocol` and `HoloCollectionViewFooterProtocol` more methods: [HoloCollectionViewHeaderProtocol](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/Holo/HoloProtocol/HoloCollectionViewHeaderProtocol.h) and [HoloCollectionViewFooterProtocol](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/Holo/HoloProtocol/HoloCollectionViewFooterProtocol.h)**

You can also call your own methods by configuring properties such as `headerConfigSEL`, `footerConfigSEL`, etc. More properties can find in   [HoloCollectionSectionMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Section/HoloCollectionSectionMaker.h).

Like `cell`, properties that contain `SEL` also have a priority.


### 3. Methods for section

```objc
// adding
[self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// inserting at index
[self.collectionView holo_insertSectionsAtIndex:0 block:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// updating with tag value by maker
[self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// resetting with tag value by maker
[self.collectionView holo_remakeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// deleting
[self.collectionView holo_removeAllSections];

// deleting with tag value
[self.collectionView holo_removeSections:@[TAG]];


// reloadData
[self.collectionView reloadData];
```

`UICollectionView+HoloCollectionView.h` provides a series of methods for manipulating `sections`, including adding, inserting, updating, resetting, deleting, etc.
**More methods provided for section see: [UICollectionView+HoloCollectionView.h (about section)](https://github.com/HoloFoundation/HoloCollectionView/blob/ce4a62e040817e520e839583c97db012666d0ca4/HoloCollectionView/Classes/Holo/UICollectionView%2BHoloCollectionView.h#L24-L145)**


### 4. Methods for item

```objc
// adding
[self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
    make.item(ExampleCollectionViewCell.class);
}];

// adding to section with tag value
[self.collectionView holo_makeItemsInSection:TAG block:^(HoloCollectionViewItemMaker * _Nonnull make) {
    make.item(ExampleCollectionViewCell.class);
}];

// inserting at index
[self.collectionView holo_insertItemsAtIndex:0 block:^(HoloCollectionViewItemMaker * _Nonnull make) {
    make.item(ExampleCollectionViewCell.class);
}];

// inserting at index to section with tag value
[self.collectionView holo_insertItemsAtIndex:0 inSection:TAG block:^(HoloCollectionViewItemMaker * _Nonnull make) {
    make.item(ExampleCollectionViewCell.class);
}];

// updating
[self.collectionView holo_updateItems:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
    make.tag(TAG).size(CGSizeMake(100, 200));
}];

// resetting
[self.collectionView holo_remakeItems:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
    make.tag(TAG).model(NSDictionary.new).size(CGSizeMake(100, 200));
}];

// deleting
[self.collectionView holo_removeAllItemsInSections:@[TAG]];

// deleting
[self.collectionView holo_removeItems:@[TAG]];


// reloadData
[self.collectionView reloadData];
```

`UICollectionView+HoloCollectionView.h` provides a series of methods for manipulating items, including adding, inserting, updating, resetting, deleting, etc.
**More methods provided for item see: [UICollectionView+HoloCollectionView.h (about item)](https://github.com/HoloFoundation/HoloCollectionView/blob/ce4a62e040817e520e839583c97db012666d0ca4/HoloCollectionView/Classes/Holo/UICollectionView%2BHoloCollectionView.h#L147-L329)**


### 5. Retrieve Delegate

You can retrieve the delegate of `UICollectionView` at any time, such as:

```objc
// first way
self.collectionView.holo_proxy.dataSource = self;
self.collectionView.holo_proxy.delegate = self;
self.collectionView.holo_proxy.scrollDelegate = self;

// second way
[self.collectionView holo_makeCollectionView:^(HoloCollectionViewViewMaker * _Nonnull make) {
    make.dataSource(self).delegate(self).scrollDelegate(self);
}];
```

Once you set up `dataSource`, `delegate`, `scrollDelegate` and implement some of their methods, `HoloCollectionView` will use your methods and return values first. For specific logic, please refer to: [HoloCollectionViewProxy.m](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloProxy/HoloCollectionViewProxy.m)


### 6. Regist key-Class map

`HoloCollectionView` supports key value mappings for headers, footers, and items in advance. For example:

```objc
// regist key-Class map
[self.collectionView holo_makeCollectionView:^(HoloCollectionViewMaker * _Nonnull make) {
    make
    .makeHeadersMap(^(HoloCollectionViewHeaderMapMaker * _Nonnull make) {
        make.header(@"header1").map(ExampleHeaderView1.class);
        make.header(@"header2").map(ExampleHeaderView2.class);
        // ...
    })
    .makeFootersMap(^(HoloCollectionViewFooterMapMaker * _Nonnull make) {
        make.footer(@"footer1").map(ExampleFooterView1.class);
        make.footer(@"footer2").map(ExampleFooterView2.class);
        // ...
    })
    .makeItemsMap(^(HoloTCollectionViewItemMapMaker * _Nonnull make) {
        make.item(@"cell1").map(ExampleCollectionViewCell1.class);
        make.item(@"cell2").map(ExampleCollectionViewCell2.class);
        // ...
    });
}];


// use the key value
[self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    // section 1
    make.section(TAG1)
    .headerS(@"header1")
    .footerS(@"footer1")
    .makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.itemS(@"cell1");
        make.itemS(@"cell2");
    });
    
    // section 2
    make.section(TAG2)
    .headerS(@"header2")
    .footerS(@"footer2")
    .makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.itemS(@"cell1");
        make.itemS(@"cell2");
    });
    
    // ...
}];
```

If you have registered `key-class` mapping in advance, `headerS`, `footerS` and `itemS` are used to fetch `Class` according to the registered mapping

If you are not registered, `headerS`, `footerS`, `itemS` directly convert the string passed in to `Class` using the `NSClassFromString(NSString * _Nonnull aClassName)` method.


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


