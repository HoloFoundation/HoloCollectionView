# HoloCollectionView（中文介绍）

`HoloCollectionView` 提供了链式语法的调用，封装了 `UICollectionView` 的代理方法。将 `UICollectionView` 的代理方法分发到每个 `cell` 上，每个 `cell` 拥有单独的设置 类型、数据、大小、点击事件的方法。


## 1、常见用法：创建 cell 列表

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

// etc...
```

`holo_makeItems:` 方法的作用是创建一系列的 `item`，每个 `item` 就是一个 `cell`，你可以方便的通过 for 循环创建一个 `cell` 列表。**关于 item 提供的更多功能参见： [HoloCollectionViewItemMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Item/HoloCollectionViewItemMaker.h) 及 [HoloCollectionItemMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Item/HoloCollectionItemMaker.h)**


### 对 Cell 的要求

遵守 `HoloCollectionViewCellProtocol` 协议，`HoloCollectionView` 会自动识别 `cell` 是否实现了该协议的方法并调用，常用的两个方法：

```objc
@required

// 给 cell 赋值 model
// 这里的 model 就是 make.model() 传入的对象
- (void)holo_configureCellWithModel:(id)model;


@optional

// 返回 cell 的大小（优先于 make 配置的 sizeHandler 属性及 size 属性使用）
// 这里的 model 就是 make.model() 传入的对象
+ (CGSize)holo_sizeForCellWithModel:(id)model;
```

 **`HoloCollectionViewCellProtocol` 协议更多方法参见：[HoloCollectionViewCellProtocol](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/Holo/HoloProtocol/HoloCollectionViewCellProtocol.h)**

你也可以通过配置 `configSEL` 、 `sizeSEL` 等属性去调用你自己的方法。更多功能同样可以在 [HoloCollectionItemMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Item/HoloCollectionItemMaker.h) 里找到。

注意像：`size`、`shouldHighlight` 等存在 `SEL` 的属性存在优先级：
1. 优先判断 `cell` 是否实现了 `sizeSEL` 方法
2. 其次判断 `sizeHandler` block 回调是否实现
3. 最后判断 `size` 属性是否赋值


## 2、常见用法：创建 section 列表，包含 header、footer、item列表

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

`holo_makeSections:` 方法的作用是创建一系列的 `section`，你可以方便的通过 for 循环创建一个 `section` 列表。**关于 section 提供的更多功能参见：[HoloCollectionViewSectionMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Section/HoloCollectionViewSectionMaker.h) 及  [HoloCollectionSectionMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Section/HoloCollectionSectionMaker.h)**


### 对 header、footer 的要求

1、header： 遵守 `HoloCollectionViewHeaderProtocol` 协议，选择实现其中的方法，常用的两个方法：

```objc
@required

// 给 header 赋值 model
// 这里的 model 就是 make.headerModel() 传入的对象
- (void)holo_configureHeaderWithModel:(id)model;


@optional
  
// 返回 header 的大小（优先于 make 配置的 headerSizeHandler 属性及 headerSize 属性使用）
// 这里的 model 就是 make.headerModel() 传入的对象
+ (CGSize)holo_sizeForHeaderWithModel:(id)model;
```

2、Footer：遵守 `HoloCollectionViewFooterProtocol` 协议，选择实现其中的方法，常用的两个方法：

```objc
@required

// 给 footer 赋值 model
// 这里的 model 就是 make.footerModel() 传入的对象
- (void)holo_configureFooterWithModel:(id)model;


@optional

// 返回 footer 的大小（优先于 make 配置的 footerSizeHandler 属性及 footerSize 属性使用）
// 这里的 model 就是 make.footerModel() 传入的对象
+ (CGSize)holo_sizeForFooterWithModel:(id)model;
```


 **`HoloCollectionViewHeaderProtocol`、`HoloCollectionViewFooterProtocol` 协议更多方法参见：[HoloCollectionViewHeaderProtocol](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/Holo/HoloProtocol/HoloCollectionViewHeaderProtocol.h) 及 [HoloCollectionViewFooterProtocol](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/Holo/HoloProtocol/HoloCollectionViewFooterProtocol.h)**
 
 
你也可以通过配置 `headerConfigSEL` 、 `footerConfigSEL` 等属性去调用你自己的方法。更多功能同样可以在 [HoloCollectionSectionMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Section/HoloCollectionSectionMaker.h) 里找到。

和 `cell` 一样，包含 `SEL` 的属性同样存在优先级。


## 3、section 的增删改

```objc
// 创建 section
[self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// 在指定位置创建 section
[self.collectionView holo_insertSectionsAtIndex:0 block:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// 更新 section，根据 tag 值匹配 section 更新给定的属性
[self.collectionView holo_updateSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// 重置 section，根据 tag 值匹配 cell，将原有属性清空，赋值新的属性
[self.collectionView holo_remakeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    make.section(TAG);
}];

// 删除所有 section
[self.collectionView holo_removeAllSections];

// 根据 tag 值匹配 section 删除
[self.collectionView holo_removeSections:@[TAG]];


// reloadData
[self.collectionView reloadData];
```

`UICollectionView+HoloCollectionView.h` 提供了一系列的操作 `section` 的方法，包括添加、插入、更新、重置、删除等操作，**关于操作 section 的更多方法参见：[UICollectionView+HoloCollectionView.h (section 部分)](https://github.com/HoloFoundation/HoloCollectionView/blob/ce4a62e040817e520e839583c97db012666d0ca4/HoloCollectionView/Classes/Holo/UICollectionView%2BHoloCollectionView.h#L24-L145)**


## 4、cell 的增删改

```objc
// 为 tag 为 nil 的 section 创建 item
[self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
    make.item(ExampleCollectionViewCell.class);
}];

// 为指定 tag 的 section 创建 item
[self.collectionView holo_makeItemsInSection:TAG block:^(HoloCollectionViewItemMaker * _Nonnull make) {
    make.item(ExampleCollectionViewCell.class);
}];

// 为 tag 为 nil 的 section，在指定位置插入 item
[self.collectionView holo_insertItemsAtIndex:0 block:^(HoloCollectionViewItemMaker * _Nonnull make) {
    make.item(ExampleCollectionViewCell.class);
}];

// 为指定 tag 的 section，在指定位置插入 item
[self.collectionView holo_insertItemsAtIndex:0 inSection:TAG block:^(HoloCollectionViewItemMaker * _Nonnull make) {
    make.item(ExampleCollectionViewCell.class);
}];

// 更新 item，根据 tag 值匹配 cell 更新给定的属性
[self.collectionView holo_updateItems:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
    make.tag(TAG).size(CGSizeMake(100, 200));
}];

// 重置 item，根据 tag 值匹配 cell，将原有属性清空，赋值新的属性
[self.collectionView holo_remakeItems:^(HoloCollectionViewUpdateItemMaker * _Nonnull make) {
    make.tag(TAG).model(NSDictionary.new).size(CGSizeMake(100, 200));
}];

// 根据 tag 值匹配 section，将其中的 item 清空
[self.collectionView holo_removeAllItemsInSections:@[TAG]];
// 根据 tag 值匹配 item 删除
[self.collectionView holo_removeItems:@[TAG]];


// reloadData
[self.collectionView reloadData];
```

`UICollectionView+HoloCollectionView.h` 提供了一系列的操作 `item` 的方法，包括添加、插入、更新、重置、删除等操作，**关于操作 item 的更多方法参见：[UICollectionView+HoloCollectionView.h (item 部分)](https://github.com/HoloFoundation/HoloCollectionView/blob/ce4a62e040817e520e839583c97db012666d0ca4/HoloCollectionView/Classes/Holo/UICollectionView%2BHoloCollectionView.h#L147-L329)**


## 5、全量用法：创建 section，设置 header、footer、item

参见：[HoloCollectionViewSectionMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Section/HoloCollectionViewSectionMaker.h) 及  [HoloCollectionSectionMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Section/HoloCollectionSectionMaker.h) 


```objc
[self.collectionView holo_makeSections:^(HoloCollectionViewSectionMaker * _Nonnull make) {
    // #1、给 section 标识 tag 返回 HoloCollectionSectionMaker 对象
    make.section(TAG)
    
    // #2、配置 section
    .inset(UIEdgeInsetsZero)
    .minimumLineSpacing(10)
    .minimumInteritemSpacing(10)
    // 返回 inset，实现该 block 的话，优先于 inset 属性
    .insetHandler(^UIEdgeInsets{
        return UIEdgeInsetsZero;
    })
    // 返回 minimumLineSpacing，实现该 block 的话，优先于 minimumLineSpacing 属性
    .minimumLineSpacingHandler(^CGFloat{
        return 10;
    })
    // 返回 minimumInteritemSpacing，实现该 block 的话，优先于 minimumInteritemSpacing 属性
    .minimumInteritemSpacingHandler(^CGFloat{
        return 10;
    })
    
    // #3、配置 header
    // header 类
    .header(ExampleHeaderView.class)
    // header 复用标识
    .headerReuseId(@"reuseIdentifier")
    // header model 数据
    .headerModel(NSObject.new)
    // header 大小
    .headerSize(CGSizeMake(100, 100))
    // 返回 header 复用标识，实现该 block 的话，优先于 headerReuseId 属性
    .headerReuseIdHandler(^NSString * _Nonnull(id  _Nullable model) {
        return (@"reuseIdentifier");
    })
    // 返回 header model，实现该 block 的话，优先于 headerModel 属性
    .headerModelHandler(^id _Nonnull{
        return NSObject.new;
    })
    // 返回 header 大小，实现该 block 的话，优先于 headerSize 属性
    .headerSizeHandler(^CGSize(id  _Nullable model) {
        return CGSizeMake(100, 100);
    })
    // header 即将出现
    .willDisplayHeaderHandler(^(UIView * _Nonnull header, id  _Nullable model) {
        NSLog(@"will display header ");
    })
    // header 已经出现
    .didEndDisplayingHeaderHandler(^(UIView * _Nonnull header, id  _Nullable model) {
        NSLog(@"did end display header ");
    })
    // 以下是 header 默认调用方法，建议 header 遵守 HoloCollectionViewHeaderProtocol，实现如下方法
    // header 赋值 model 调用的方法
    .headerConfigSEL(@selector(holo_configureHeaderWithModel:))
    // header 返回大小调用的方法，header 实现该方法的话，优先于 headerHeightHandler 属性及 headerHeight 属性
    .headerSizeSEL(@selector(holo_sizeForHeaderWithModel:))
    // header 即将出现调用的方法，header 实现该方法的话，优先于 willDisplayHeaderHandler 属性
    .willDisplayHeaderSEL(@selector(holo_willDisplayHeaderWithModel:))
    // header 已经出现调用的方法，header 实现该方法的话，优先于 didEndDisplayingHeaderHandler 属性
    .didEndDisplayingHeaderSEL(@selector(holo_didEndDisplayingHeaderWithModel:))
    
    // #4、配置 footer
    // footer 类
    .footer(ExampleFooterView.class)
    // footer 复用标识
    .footerReuseId(@"reuseIdentifier")
    // footer model 数据
    .footerModel(NSObject.new)
    // footer 大小
    .footerSize(CGSizeMake(100, 100))
    // 返回 footer 复用标识，实现该 block 的话，优先于 footerReuseId 属性
    .footerReuseIdHandler(^NSString * _Nonnull(id  _Nullable model) {
        return (@"reuseIdentifier");
    })
    // 返回 footer model，实现该 block 的话，优先于 footerModel 属性
    .footerModelHandler(^id _Nonnull{
        return NSObject.new;
    })
    // 返回 footer 大小，实现该 block 的话，优先于 footerSize 属性
    .footerSizeHandler(^CGSize(id  _Nullable model) {
        return CGSizeMake(100, 100);
    })
    // header 即将出现
    .willDisplayFooterHandler(^(UIView * _Nonnull footer, id  _Nullable model) {
        NSLog(@"will display footer ");
    })
    // footer 已经出现
    .didEndDisplayingFooterHandler(^(UIView * _Nonnull footer, id  _Nullable model) {
        NSLog(@"did end display footer ");
    })
    // 以下是 footer 默认调用方法，建议 footer 遵守 HoloCollectionViewFooterProtocol，实现如下方法
    // footer 赋值 model 调用的方法
    .footerConfigSEL(@selector(holo_configureFooterWithModel:))
    // footer 返回大小调用的方法，footer 实现该方法的话，优先于 footerSizeHandler 属性及 footerSize 属性
    .footerSizeSEL(@selector(holo_sizeForFooterWithModel:))
    // footer 即将出现调用的方法，footer 实现该方法的话，优先于 willDisplayFooterHandler 属性
    .willDisplayFooterSEL(@selector(holo_willDisplayFooterWithModel:))
    // footer 已经出现调用的方法，footer 实现该方法的话，优先于 didEndDisplayingFooterHandler 属性
    .didEndDisplayingFooterSEL(@selector(holo_didEndDisplayingFooterWithModel:))
    
    // #3、配置 item（下一节 makeItem 方法里细讲）
    .makeItems(^(HoloCollectionViewItemMaker * _Nonnull make) {
        make.item(ExampleCollectionViewCell.class);
    });
}];
```


## 6、全量用法：创建 item

参见：[HoloCollectionViewItemMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Item/HoloCollectionViewItemMaker.h) 及 [HoloCollectionItemMaker.h](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloMaker/Item/HoloCollectionItemMaker.h)


```objc
[self.collectionView holo_makeItems:^(HoloCollectionViewItemMaker * _Nonnull make) {
    // #1、给 item 配置 cell 类，返回 HoloCollectionItemMaker 对象
    make.item(ExampleCollectionViewCell.class)
    
    // #2、配置 cell
    // model 数据
    .model(NSObject.new)
    // 复用标识
    .reuseId(@"reuseIdentifier")
    // tag 标识，用于 update 等操作
    .tag(TAG)
    // 大小
    .size(CGSizeMake(100, 100))
    // 是否高亮
    .shouldHighlight(NO)
    // 是否可选中
    .shouldSelect(NO)
    // 是否可取消选中
    .shouldDeselect(NO)
    // 是否可移动
    .canMove(NO)
    // 返回 model，实现该 block 的话，优先于 model 属性
    .modelHandler(^id _Nonnull{
        return NSObject.new;
    })
    // 返回复用标识，实现该 block 的话，优先于 reuseId 属性
    .reuseIdHandler(^NSString * _Nonnull(id  _Nullable model) {
        return @"reuseIdentifier";
    })
    // 返回大小，实现该 block 的话，优先于 size 属性
    .sizeHandler(^CGSize(id  _Nullable model) {
        return CGSizeMake(100, 100);
    })
    // 返回是否高亮，实现该 block 的话，优先于 shouldHighlight 属性
    .shouldHighlightHandler(^BOOL(id  _Nullable model) {
        return NO;
    })
    // 返回是否可选中，实现该 block 的话，优先于 shouldSelect 属性
    .shouldSelectHandler(^BOOL(id  _Nullable model) {
        return NO;
    })
    // 返回是否可取消选中，实现该 block 的话，优先于 shouldDeselect 属性
    .shouldDeselectHandler(^BOOL(id  _Nullable model) {
        return NO;
    })
    // 返回是否可移动，实现该 block 的话，优先于 canMove 属性
    .canMoveHandler(^BOOL(id  _Nullable model) {
        return NO;
    })
    // cell 点击事件
    .didSelectHandler(^(id  _Nullable model) {
        
    })
    // cell 取消点击
    .didDeselectHandler(^(id  _Nullable model) {
        
    })
    // configSEL 执行之前被调用
    .beforeConfigureHandler(^(UICollectionViewCell * _Nonnull cell, id  _Nullable model) {
        
    })
    // configSEL 执行之后被调用
    .afterConfigureHandler(^(UICollectionViewCell * _Nonnull cell, id  _Nullable model) {
        
    })
    // cell 即将出现
    .willDisplayHandler(^(UICollectionViewCell * _Nonnull cell, id  _Nullable model) {
        
    })
    // cell 已经出现
    .didEndDisplayingHandler(^(UICollectionViewCell * _Nonnull cell, id  _Nullable model) {
        
    })
    // cell 高亮
    .didHighlightHandler(^(id  _Nullable model) {
        
    })
    // cell 取消高亮
    .didUnHighlightHandler(^(id  _Nullable model) {
        
    })
    // 返回 cell 目标移动位置
    .targetMoveHandler(^NSIndexPath * _Nonnull(NSIndexPath * _Nonnull atIndexPath, NSIndexPath * _Nonnull toIndexPath) {
        return NSIndexPath.new;
    })
    // cell 移动回调
    .moveHandler(^(NSIndexPath * _Nonnull atIndexPath, NSIndexPath * _Nonnull toIndexPath, void (^ _Nonnull completionHandler)(BOOL)) {
        
    })
    
    // 以下是 cell 默认调用方法，建议 cell 遵守 HoloCollectionViewCellProtocol，实现如下方法
    // 赋值 model 调用的方法
    .configSEL(@selector(holo_configureCellWithModel:))
    // 返回大小调用的方法，cell 实现该方法的话，优先于 sizeHandler 属性及 size 属性
    .sizeSEL(@selector(holo_sizeForCellWithModel:))
    // 返回是否可高亮调用的方法，cell 实现该方法的话，优先于 shouldHighlightHandler 属性及 shouldHighlight 属性
    .shouldHighlightSEL(@selector(holo_shouldHighlightForCellWithModel:))
    // 返回是否可选中用的方法，cell 实现该方法的话，优先于 shouldSelectHandler 属性及 shouldSelect 属性
    .shouldSelectSEL(@selector(holo_shouldSelectForCellWithModel:))
    // 返回是否可取消选中用的方法，cell 实现该方法的话，优先于 shouldDeselectHandler 属性及 shouldDeselect 属性
    .shouldDeselectSEL(@selector(holo_shouldDeselectForCellWithModel:))
    // 点击调用的方法，cell 实现该方法的话，优先于 didSelectHandler 属性
    .didSelectSEL(@selector(holo_didSelectCellWithModel:))
    // 取消点击调用的方法，cell 实现该方法的话，优先于 didDeselectHandler 属性
    .didDeselectSEL(@selector(holo_didDeselectCellWithModel:))
    // 即将出现调用的方法，cell 实现该方法的话，优先于 willDisplayHandler 属性
    .willDisplaySEL(@selector(holo_willDisplayCellWithModel:))
    // 已经出现调用的方法，cell 实现该方法的话，优先于 didEndDisplayingHandler 属性
    .didEndDisplayingSEL(@selector(holo_didEndDisplayingCellWithModel:))
    // 高亮调用的方法，cell 实现该方法的话，优先于 didHighlightHandler 属性
    .didHighlightSEL(@selector(holo_didHighlightCellWithModel:))
    // 取消高亮调用的方法，cell 实现该方法的话，优先于 didHighlightHandler 属性
    .didUnHighlightSEL(@selector(holo_didUnHighlightCellWithModel:));
}];
```


## 7、Retrieve Delegate

你可以随时夺回 `UICollectionView` 的代理，比如：

```objc
// 方式一
self.collectionView.holo_proxy.dataSource = self;
self.collectionView.holo_proxy.delegate = self;
self.collectionView.holo_proxy.scrollDelegate = self;

// 方式二
[self.collectionView holo_makeCollectionView:^(HoloCollectionViewViewMaker * _Nonnull make) {
    make.dataSource(self).delegate(self).scrollDelegate(self);
}];
```

一旦你设置了 `dataSource`、`delegate`、`scrollDelegate` 并实现了其中某个方法，`HoloCollectionView` 将优先使用你的方法及返回值。具体逻辑参见：[HoloCollectionViewProxy.m](https://github.com/HoloFoundation/HoloCollectionView/blob/master/HoloCollectionView/Classes/HoloProxy/HoloCollectionViewProxy.m)


## 8、注册 key-Class 映射

`HoloCollectionView` 支持提前为 header、footer、item 注册 `key-Class` 映射。用法如下：

```objc
// 提前注册
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
    .makeItemsMap(^(HoloCollectionViewItemMapMaker * _Nonnull make) {
        make.item(@"cell1").map(ExampleCollectionViewCell1.class);
        make.item(@"cell2").map(ExampleCollectionViewCell2.class);
        // ...
    });
}];


// 使用 key 值
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

若提前注册过  `key-Class` 映射，则 `headerS`、`footerS`、`itemS` 根据注册的映射关系取 `Class` 使用

若未注册过，则 `headerS`、`footerS`、`itemS` 直接将传入的字符串通过 `NSClassFromString(NSString * _Nonnull aClassName)` 方法转化为 `Class` 使用。

