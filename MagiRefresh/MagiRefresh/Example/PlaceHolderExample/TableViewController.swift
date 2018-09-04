//
//  TableViewController.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/8/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var items = [String]()
    var sections = 1
    var isSelected = false
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        items.append("添加一行数据")
        tableView.reloadData()
    }
    @IBAction func deleteAction(_ sender: Any) {
        if items.count > 0 {
            items.removeLast()
            tableView.reloadData()
        }
    }
    @IBAction func changeAction(_ sender: UIBarButtonItem) {
        changeBarAction(sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        print(self.debugDescription+"------销毁了")
    }
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        tableView.separatorStyle = .none
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "reuseIdentifier")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
            
        else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.magiRefresh.bindStyleForFooterRefresh(
            themeColor: UIColor.cyan,
            refreshStyle: MagiRefreshStyle.native) { [weak self] in
                self?.tableView.magiRefresh.footer?.endRefreshingWithAlertText("安然", completion: nil)
                print("bindStyleForFooterRefresh")
        }
        tableView.magiRefresh.bindStyleForHeaderRefresh(
            themeColor: UIColor.cyan,
            refreshStyle: MagiRefreshStyle.native) { [weak self] in
                 self?.tableView.magiRefresh.header?.endRefreshingWithAlertText("安然", completion: nil)
                self?.tableView.reloadData()
                print("bindStyleForHeaderRefresh")
        }
        setupCustomPlaceHolderView()
    }
    
    //自定义空数据界面显示
    fileprivate func setupCustomPlaceHolderView() {
        let emptyView = Bundle.main.loadNibNamed(
            "MyEmptyView", owner: self, options: nil)?.last as! MyEmptyView
        emptyView.reloadBtn.addTarget(
            self,
            action: #selector(reloadBtnAction(_:)),
            for: .touchUpInside)
        emptyView.frame = view.bounds
        //空数据界面显示
        let placeHolder = MagiPlaceHolder.createCustomPlaceHolder(emptyView)
        tableView.magiRefresh.placeHolder = placeHolder
        tableView.magiRefresh.placeHolder?.tapBlankViewClosure = {
            print("点击界面空白区域")
        }
        tableView.magiRefresh.showPlaceHolder()
    }
    
    @objc fileprivate func reloadBtnAction(_ sender: UIButton) {
        print("点击刷新按钮")
    }
    
    @objc fileprivate func changeBarAction(_ sender: UIBarButtonItem) {
        if isSelected {
            isSelected = false
            setupCustomPlaceHolderView()
        }
        
        else {
            isSelected = true
            //空数据界面显示
            let placeHolder = MagiPlaceHolder.createPlaceHolderWithClosure(
                imageName: "search_noData",
                title: "暂无数据",
                detailTitle: "",
                refreshBtnTitle: "") {
                    print("点击刷新按钮")
            }
            placeHolder.contentViewOffset = -100
            placeHolder.titleLabFont = UIFont.systemFont(ofSize: 18)
            placeHolder.titleLabTextColor = UIColor.purple
            tableView.magiRefresh.placeHolder = placeHolder
            tableView.magiRefresh.placeHolder?.tapBlankViewClosure = {
                print("点击界面空白区域")
            }
            
            tableView.magiRefresh.showPlaceHolder()
        }
    }
    
}

// MARK: - Table view data source
extension TableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = items[indexPath.item]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.removeLast()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        switch item {
        case "点击重新加载":
            items.removeAll()
            tableView.reloadData()
        case "点击添加行":
            tableView.beginUpdates()
            items.append("new row")
            tableView.insertRows(at: [IndexPath(row: tableView.numberOfRows(inSection: indexPath.section), section: indexPath.section)], with: .automatic)
            tableView.endUpdates()
        case "点击删除行":
            tableView.beginUpdates()
            items.removeLast()
            let index = IndexPath(row: tableView.numberOfRows(inSection: indexPath.section) - 1, section: indexPath.section)
            tableView.deleteRows(at: [index], with: .automatic)
            tableView.endUpdates()
        default: break
        }
    }
    
    
}
