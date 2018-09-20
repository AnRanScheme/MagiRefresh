//
//  RefreshTableViewController.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/17.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class RefreshTableViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds,
                                    style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.rowHeight = 55.0
        tableView.sectionHeaderHeight = 35.0
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        
        var count = 2
        tableView.magiRefresh.bindStyleForHeaderRefresh(
            themeColor: UIColor.blue,
            refreshStyle: self.style,
            completion: { [weak self] in
                Delay(1, completion: {
                    
                    DispatchQueue.main.async {
                        if count > 0 {
                            self?.dataArray = ["","","","","","",""]
                            count -= 1
                            self?.tableView.magiRefresh.header?.endRefreshingWithAlertText(
                                "Did load successfully", completion: nil)
                            self?.tableView.reloadData()
                        }
                        else {
                            self?.dataArray = ["","","","","","",""]
                            self?.tableView.magiRefresh.header?.endRefreshingWithAlertText(
                                "刷新成功", completion: nil)
                            self?.tableView.reloadData()
                        }
                        
                    }
                })
                
        })
        
        tableView.magiRefresh.bindStyleForFooterRefresh(
            themeColor: UIColor.blue,
            refreshStyle: self.style,
            completion: { [weak self] in
                Delay(1, completion: {
                    DispatchQueue.main.async {
                        self?.dataArray += ["","","","","","",""]
                        self?.tableView.magiRefresh.footer?.endRefreshingWithAlertText(
                            "Did load successfully",
                            completion: {
                                self?.tableView.reloadData()
                        })
                    }
                })
                
        })
        tableView.magiRefresh.footer?.isAutoRefreshOnFoot = true
        
        return tableView
    }()
    
    fileprivate static let Identifier = "CellID"
    fileprivate var style: MagiRefreshStyle
    fileprivate var dataArray = ["","","","","","",""]
    
    init(_ style: MagiRefreshStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        print(self.debugDescription+"------销毁了")
    }
    
}

// MARK: - customize
extension RefreshTableViewController {
    
    fileprivate func setupUI() {
        navigationItem.title = "UITableView"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(), for: .default)
        
        let refresh = UIBarButtonItem(
            title: "刷新",
            style: .plain,
            target: self,
            action: #selector(refreshAction(_:)))
        navigationItem.rightBarButtonItem = refresh
        
        view.addSubview(tableView)
    }
    
}

// MARK: - action
extension RefreshTableViewController {
    
    @objc
    fileprivate func refreshAction(_ sender: UIBarButtonItem) {
        tableView.magiRefresh.header?.beginRefreshing()
    }
    
}

// MARK: - loadData
extension RefreshTableViewController {
    
}


// MARK: - UITableViewDataSource
extension RefreshTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(
            withIdentifier: RefreshTableViewController.Identifier)
        if cell == nil {
            cell = UITableViewCell(
                style: UITableViewCellStyle.subtitle,
                reuseIdentifier: RefreshTableViewController.Identifier)
        }
        
        return cell!
    }
    
}

// MARK: - UITableViewDelegate
extension RefreshTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 35))
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        label.textColor = UIColor.blue
        label.text = "title"
        
        return label
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.8)
        cell.selectionStyle = .none
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = "section:\(indexPath.section)---row:\(indexPath.row)"
    }
    
}

// MARK: - public
extension RefreshTableViewController {

}
