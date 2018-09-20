//
//  RefreshViewController.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/17.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

func Delay(_ seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

class RefreshMainListViewController: UIViewController {
    
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
        tableView.magiRefresh.bindStyleForFooterRefresh(
            themeColor: UIColor.blue,
            refreshStyle: MagiRefreshStyle.animatableArrow,
            completion: { [weak self] in
                Delay(1, completion: {
                    self?.tableView.magiRefresh.footer?.endRefreshing()
                })
                
        })
        tableView.magiRefresh.bindStyleForHeaderRefresh(
            completion: { [weak self] in
                Delay(1, completion: {
                    self?.tableView.magiRefresh.header?.endRefreshing()
                })
        })
        
        return tableView
    }()

    fileprivate static let Identifier = "CellID"
    fileprivate var textArray = ["native",
                                 "replicatorWoody",
                                 "replicatorAllen",
                                 "replicatorCircle",
                                 "replicatorDot",
                                 "replicatorArc",
                                 "replicatorTriangle",
                                 "animatableRing",
                                 "animatableArrow"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}


// MARK: - customize
extension RefreshMainListViewController {
    
    fileprivate func setupUI() {
        navigationItem.title = "Refresh"
        view.addSubview(tableView)
    }
    
    private enum Section: Int {
        
        case tableView
        case collectionView
        case customView
        
        var title: String {
            switch self {
            case .tableView:
                return "UITableView"
            case .collectionView:
                return "UICollectionView"
            case .customView:
                return "CustomView"
            }
        }
        
        static var count: Int  {
            return Section.customView.rawValue + 1
        }
    }
    
}

// MARK: - action
extension RefreshMainListViewController {
    
}

// MARK: - loadData
extension RefreshMainListViewController {
    
}


// MARK: - UITableViewDataSource
extension RefreshMainListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(
            withIdentifier: RefreshMainListViewController.Identifier)
        if cell == nil {
            cell = UITableViewCell(
                style: UITableViewCellStyle.subtitle,
                reuseIdentifier: RefreshMainListViewController.Identifier)
        }

        return cell!
    }
    
}

// MARK: - UITableViewDelegate
extension RefreshMainListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = Section(rawValue: section)?.title else { return nil }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 35))
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        label.textColor = UIColor.blue
        label.text = title
        
        return label
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let title = Section(rawValue: indexPath.section)?.title else { return }
        cell.separatorInset = UIEdgeInsets.zero
        let rows: CGFloat = CGFloat(tableView.numberOfRows(inSection: indexPath.section))
        cell.backgroundColor = UIColor.blue.withAlphaComponent((rows-CGFloat(indexPath.row)*0.5)/rows)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = textArray[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = RefreshTableViewController(MagiRefreshStyle(rawValue: indexPath.row)!)
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = RefreshCollectionViewController(MagiRefreshStyle(rawValue: indexPath.row)!)
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            break
        default:
            break
        }
    }
    
}
