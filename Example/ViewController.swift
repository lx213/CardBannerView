//
//  ViewController.swift
//  CardBannerView
//
//  Created by 廖轩 on 2018/3/21.
//  Copyright © 2018年 廖轩. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cbv: CardBannerView!
    var sw = UIScreen.main.bounds.size.width
    var imgnames = ["1","2","3","4","5","6"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cbv = CardBannerView(datas: [Any](), itemW: sw * 62 / 75, itemH: sw * 33 / 75, LineSpacing: sw * 8 / 750, cellClass: CardCell.self, delegate: self, iscycles: true, istransform: true)
        cbv.frame = CGRect(x: 0, y: 0, width: sw, height: sw * 398 / 750)
        self.view.addSubview(cbv)
        cbv.setDatas(datas: imgnames)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:CardBannerDelegate {
    func CellForItem(cell: UICollectionViewCell, index: Int) -> UICollectionViewCell {
        let cl = cell as! CardCell
        cl.img.image = UIImage(named: imgnames[index])
        return cl
    }
    
    func CardClick(index: Int) {
        print(index)
    }
}

