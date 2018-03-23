//
//  ViewController2.swift
//  CardBannerView
//
//  Created by 廖轩 on 2018/3/23.
//  Copyright © 2018年 廖轩. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    var cbv: CardBannerView!
    var sw = UIScreen.main.bounds.size.width
    var imgnames = ["1","2","3","4","5","6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mpx = sw / 750
        self.view.backgroundColor = UIColor.orange
        cbv = CardBannerView(datas: [Any](), itemW: mpx * 316, itemH: mpx * 290, LineSpacing: mpx * 28, cellClass: CardCell.self, delegate: self, iscycles: false, istransform: false)
        cbv.frame = CGRect(x: 0, y: 100, width: sw, height: sw * 398 / 750)
        self.view.addSubview(cbv)
        cbv.setDatas(datas: imgnames)
        
        let backbtn = UIButton(frame: CGRect(x: 50, y: 400, width: 100, height: 100))
        backbtn.setTitle("返回", for: .normal)
        view.addSubview(backbtn)
        backbtn.setTitleColor(UIColor.blue, for: .normal)
        backbtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController2:CardBannerDelegate {
    func CellForItem(cell: UICollectionViewCell, index: Int) -> UICollectionViewCell {
        let cl = cell as! CardCell
        cl.img.image = UIImage(named: imgnames[index])
        return cl
    }
    
    func CardClick(index: Int) {
        print(index)
    }
}
