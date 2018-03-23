# CardBannerView
卡片式滑动横幅，因公司项目需要，自己写的一个小控件，由swift4编写，可以实现自动循环滚动和水平非循环的滚动，可以自定义cell样式，顺便学习下发布GitHub和cocoapods


<p align="left">
<a href="https://travis-ci.org/xmartlabs/XLActionController"><img src="https://travis-ci.org/xmartlabs/XLActionController.svg?branch=master" alt="Build status" /></a>
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat" alt="Swift 4 compatible" /></a>
<a href="https://cocoapods.org/pods/CardBannerView"><img src="https://img.shields.io/cocoapods/v/CardBannerView.svg" alt="CocoaPods compatible" /></a>
  <img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" />
</p>

# 效果图

<img src="screenshot/1.GIF" width="300"/>

## 集成
**使用cocoapods
```
pod 'CardBannerView'
```

**直接集成

将CardBannerView目录下的CardBannerView.swift文件集成进项目里


## 使用

* 实例化
```swift
//datas:数据集
//itemW:cell宽度
//itemH:cell高度
//linespacing:水平间隔
//cellClass:cell
//iscycles:是否循环
//istransform:是否缩放（两边cell缩小）
cbv = CardBannerView(datas: [Any](), itemW: sw * 62 / 75, itemH: sw * 33 / 75, LineSpacing: sw * 8 / 750, cellClass: CardCell.self, delegate: self, iscycles: true, istransform: true)
cbv.frame = CGRect(x: 0, y: 100, width: sw, height: sw * 398 / 750)
self.view.addSubview(cbv)
//设置自动滚动时长（单位秒）
cbv.scrollTime = 3
//设置数据集并刷新数据
cbv.setDatas(datas: imgnames)
//开启自动滚动
cbv.isAutoScroll = true
```

* 实现协议
```swift
    //自定义cell样式
    func CellForItem(cell: UICollectionViewCell, index: Int) -> UICollectionViewCell {
        let cl = cell as! CardCell
        cl.img.image = UIImage(named: imgnames[index])
        return cl
    }
    //cell点击事件
    func CardClick(index: Int) {
        print(index)
    }
```

