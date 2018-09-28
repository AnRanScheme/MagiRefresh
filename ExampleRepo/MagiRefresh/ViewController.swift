//
//  ViewController.swift
//  MagiRefresh
//
//  Created by AnRanScheme on 09/27/2018.
//  Copyright (c) 2018 AnRanScheme. All rights reserved.
//

import UIKit
import MagiRefresh

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds,
                                    style: UITableViewStyle.plain)
        tableView.magi_maxX
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
  
        
    }

}

