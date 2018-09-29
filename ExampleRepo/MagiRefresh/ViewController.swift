//
//  ViewController.swift
//  MagiRefresh
//
//  Created by AnRanScheme on 09/27/2018.
//  Copyright (c) 2018 AnRanScheme. All rights reserved.
//

import UIKit
import MagiRefresh

func Delay(_ seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds,
                                    style: .plain)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: ViewController.identifier)
     
        let header = MagiReplicatorHeader()
        header.themeColor = UIColor.red
        tableView.magiRefresh.header = header
        header.magiRefreshingClosure({
            print("刷新")
            Delay(3, completion: {
                tableView.magiRefresh.header?.endRefreshingWithAlertText("哈哈哈哈哈", completion: nil)
            })
        })
        let footer = MagiArrowFooter()
        tableView.magiRefresh.footer = footer
        footer.magiRefreshingClosure({
            print("刷新")
            Delay(3, completion: {
                tableView.magiRefresh.footer?.endRefreshing()
            })
        })
        
        return tableView
    }()

    fileprivate static let identifier = "CellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.addSubview(tableView)
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ViewController.identifier,
            for: indexPath)
        cell.textLabel?.text = "title--------\(indexPath.row)"
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

