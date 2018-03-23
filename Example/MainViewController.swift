//
//  MainViewController.swift
//  CardBannerView
//
//  Created by 廖轩 on 2018/3/23.
//  Copyright © 2018年 廖轩. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loopAction(_ sender: Any) {
        let vc = ViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func noloopAction(_ sender: Any) {
        let vc = ViewController2()
        self.present(vc, animated: true, completion: nil)
    }
}
