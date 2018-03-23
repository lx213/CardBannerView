//
//  CardCell.swift
//  CardBannerView
//
//  Created by 廖轩 on 2018/3/21.
//  Copyright © 2018年 廖轩. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    var img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(img)
        img.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        img.image = UIImage(named: "1")
        
        self.layer.shadowColor = UIColor.blue.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
