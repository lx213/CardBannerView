//
//  CardBannerView.swift
//  test
//
//  Created by 廖轩 on 2017/12/16.
//  Copyright © 2017年 廖轩. All rights reserved.
//

import UIKit

@objc public protocol CardBannerDelegate{
    /// 卡片点击事件
    @objc optional func CardClick(index: Int)
    /// 卡片初始化
    func CellForItem(cell: UICollectionViewCell, index: Int) -> UICollectionViewCell
}

open class CardBannerView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var datas = [Any]()
    let cellIde = "cell"
    var itemW:CGFloat!
    var itemH:CGFloat!
    var leftPadding:CGFloat = 0
    /// 是否循环
    var isCycles = false
    /// 间距
    var LineSpacing: CGFloat!
    /// 触控view
    var touchView = UIView()
    /// 中央card的index
    var centerIndex = 0
    /// 远数据集的数量
    var dataCount = 0
    var collect:UICollectionView!
    /// 自动轮播计时
    var timeCount = 0
    var timer:Timer?
    /// 自动轮播时间，默认为2秒
    public var scrollTime = 2
    /// 是否开启自动轮播
    public var isAutoScroll = false {
        didSet{
            if isAutoScroll {
                timeCount = 0
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scrollCard), userInfo: nil, repeats: true)
            }else{
                timer?.invalidate()
            }
        }
    }
    weak var delegate: CardBannerDelegate?
    
    public init(datas: [Any], itemW: CGFloat, itemH: CGFloat, LineSpacing: CGFloat, cellClass: AnyClass?, delegate: CardBannerDelegate ,iscycles: Bool ,istransform: Bool){
        
        self.delegate = delegate
        self.itemH = itemH
        self.itemW = itemW
        self.LineSpacing = LineSpacing
        self.isCycles = iscycles
        
        if isCycles {
            /// 扩展数据集至3倍
            for _ in 0..<3 {
                self.datas += datas
            }
            centerIndex = datas.count
        }else{
            self.datas = datas
            centerIndex = 0
        }
        dataCount = datas.count
        super.init(frame: CGRect.zero)
        collect = UICollectionView(frame: self.frame, collectionViewLayout: CardLayout(itemW: itemW, itemH: itemH, LineSpacing: LineSpacing,istransform: istransform, iscycles:iscycles))
        collect.backgroundColor = UIColor.clear
        collect.register(cellClass, forCellWithReuseIdentifier: cellIde)
        collect.dataSource = self
        collect.delegate = self
        collect.showsHorizontalScrollIndicator = false
        collect.showsVerticalScrollIndicator = false
        collect.decelerationRate = 0.1
        self.addSubview(collect)
        
        touchView.frame = self.frame
        self.addSubview(touchView)
        let rswipe = UISwipeGestureRecognizer(target: self, action: #selector(rightswipe(_:)))
        rswipe.direction = .right
        let lswipe = UISwipeGestureRecognizer(target: self, action: #selector(leftswipe(_:)))
        lswipe.direction = .left
        let click = UITapGestureRecognizer(target: self, action: #selector(clickAction(_:)))
        touchView.isUserInteractionEnabled = isCycles
        touchView.addGestureRecognizer(lswipe)
        touchView.addGestureRecognizer(rswipe)
        touchView.addGestureRecognizer(click)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.CardClick!(index: indexPath.row)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if delegate != nil {
            let cell = delegate!.CellForItem(cell: collectionView.dequeueReusableCell(withReuseIdentifier: cellIde, for: indexPath), index: getRealIndex(index: indexPath.row))
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    @objc func scrollCard(){
        timeCount += 1
        if timeCount == scrollTime {
            leftswipe(UISwipeGestureRecognizer())
        }
    }
    
    override open func layoutSubviews() {
        collect.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        if isCycles {
            /// 移动至中央的那一组数据
            collect.setContentOffset(CGPoint(x: (itemW + LineSpacing) * CGFloat(centerIndex),y: 0), animated: false)
        }else {
            leftPadding = (collect.frame.size.width - itemW) / 2 - LineSpacing
        }
        touchView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    public func setDatas(datas:[Any]) {
        if isCycles {
            /// 扩展数据集至3倍
            for _ in 0..<3 {
                self.datas += datas
            }
            centerIndex = datas.count
        }else{
            self.datas = datas
            centerIndex = 0
        }
        dataCount = datas.count
        collect.reloadData()
    }
    
    /// 点击卡片
    @objc func clickAction(_ rec:UITapGestureRecognizer){
        print(rec.location(in: self))
        let offx = rec.location(in: self).x
        if isCycles {
            if offx < self.frame.size.width / 2 - itemW / 2 {
                rightswipe(UISwipeGestureRecognizer())
            }else if offx > self.frame.size.width / 2 + itemW / 2 {
                leftswipe(UISwipeGestureRecognizer())
            }else{
                delegate?.CardClick!(index: getRealIndex(index: centerIndex))
            }
        }
        
    }
    
    /// 右滑
    @objc func rightswipe(_ rec:UISwipeGestureRecognizer){
        //        print("右滑\(centerIndex)")
        timeCount = 0
        if isCycles {
            if centerIndex == dataCount {
                centerIndex = dataCount * 2
                collect.setContentOffset(CGPoint(x: (itemW + LineSpacing) * CGFloat(centerIndex),y: collect.contentOffset.y), animated: false)
            }
            centerIndex -= 1
            collect.setContentOffset(CGPoint(x: (itemW + LineSpacing) * CGFloat(centerIndex),y: collect.contentOffset.y), animated: true)
        }else{
            if centerIndex == 0 {
                return
            }else if centerIndex == 1 {
                centerIndex -= 1
                collect.setContentOffset(CGPoint(x: 0, y: collect.contentOffset.y), animated: true)
            }else{
                centerIndex -= 1
                collect.setContentOffset(CGPoint(x: ((itemW + LineSpacing) * CGFloat(centerIndex)) - leftPadding ,y: collect.contentOffset.y), animated: true)
            }
        }
        
    }
    
    /// 左滑
    @objc func leftswipe(_ rec:UISwipeGestureRecognizer){
        //        print("左滑\(centerIndex)")
        timeCount = 0
        if isCycles {
            if centerIndex == dataCount * 2 {
                centerIndex = dataCount
                collect.setContentOffset(CGPoint(x: (itemW + LineSpacing) * CGFloat(centerIndex),y: collect.contentOffset.y), animated: false)
            }
            centerIndex += 1
            collect.setContentOffset(CGPoint(x: (itemW + LineSpacing) * CGFloat(centerIndex),y: collect.contentOffset.y), animated: true)
        }else{
            if centerIndex == dataCount - 1 {
                return
            }else if centerIndex == dataCount - 2 {
                centerIndex += 1
                collect.setContentOffset(CGPoint(x: ((itemW + LineSpacing) * CGFloat(dataCount)) - collect.frame.size.width, y: collect.contentOffset.y), animated: true)
            }else{
                centerIndex += 1
                collect.setContentOffset(CGPoint(x: ((itemW + LineSpacing) * CGFloat(centerIndex)) - leftPadding ,y: collect.contentOffset.y), animated: true)
            }
        }
        
    }
    
    /// 获取真实数据集中的index
    func getRealIndex(index: Int) -> Int {
        if dataCount == 0 {
            return 0
        }
        return index % dataCount
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CardLayout: UICollectionViewFlowLayout {
    var itemW: CGFloat = UIScreen.main.bounds.size.width * 0.8
    var itemH: CGFloat = UIScreen.main.bounds.size.width * 0.8 * 9 / 16
    var lineSpacing: CGFloat = 10
    var isTransform = false
    /// 是否循环
    var isCycles = false
    
    lazy var inset:CGFloat = {
        return (self.collectionView?.bounds.width ?? 0) * 0.5 - self.itemSize.width * 0.5
    }()
    
    init(itemW: CGFloat, itemH: CGFloat, LineSpacing: CGFloat, istransform: Bool,iscycles: Bool) {
        super.init()
        self.lineSpacing = LineSpacing
        self.itemW = itemW
        self.itemH = itemH
        self.isTransform = istransform
        self.isCycles = iscycles
        
        //元素大小
        self.itemSize = CGSize(width: itemW, height: itemH)
        //滚动方向
        self.scrollDirection = .horizontal
        //间距
        self.minimumLineSpacing = LineSpacing
    }
    
    override func prepare() {
        //设置边距，让第一张和最后一张图片出现在最中央
        if isCycles {
            self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
        }else{
            self.sectionInset = UIEdgeInsetsMake(0, lineSpacing, 0, lineSpacing)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// itemview的缩放控制
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElements(in: rect)
        if !isTransform {
            return array
        }
        
        let visiableRect = CGRect(x: self.collectionView!.contentOffset.x, y: self.collectionView!.contentOffset.y, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
        
        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.frame.size.width * 0.5
        for attri in array! {
            if !visiableRect.intersects(attri.frame) { continue }
            let k0 = (abs(attri.center.x - centerX) - itemW * 0.5)
            var k1 = k0 / (itemW * 0.5)
            if k1 > 1 {
                k1 = 1
            }else if k1 < 0 {
                k1 = 0
            }
            let scale = 1 - k1 * 0.1
            /// 根据itemview离中线的距离比例缩放itemview
            attri.transform = CGAffineTransform(scaleX: scale,y: scale)
        }
        return array
    }
    
    /**
     用来设置停止滚动那一刻的位置
     
     forProposedContentOffset：原本collectionview停止滚动那一刻的位置
     withScrollingVelocity：滚动速度
     
     return  最终停留的位置
     */
    //    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    //
    //        //为了让停止滑动时，时刻有一张图片位于屏幕中央
    //        let lastRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
    //        //获得view中央的x值
    //        let centerX = proposedContentOffset.x + self.collectionView!.frame.width * 0.5
    //        //这个范围内的所有属性
    //        let array = self.layoutAttributesForElements(in: lastRect)
    //
    //        //需要移动的距离
    //        var adjustOffsetX = CGFloat(MAXFLOAT)
    //        for attri in array! {
    //            if abs(attri.center.x - centerX) < abs(adjustOffsetX) {
    //                adjustOffsetX = attri.center.x - centerX
    //            }
    //        }
    //        return CGPoint(x: proposedContentOffset.x + adjustOffsetX, y: proposedContentOffset.y)
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


