//
//  ViewController.swift
//  MagiRefresh
//
//  Created by anran on 2018/8/31.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   // nihao 
    @IBAction func refreshViewAction(_ sender: UIButton) {
        let vc = RefreshMainListViewController()
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

