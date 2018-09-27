//
//  RefreshCollectionViewController.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/20.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class RefreshCollectionViewController: UIViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 1.0
        flow.minimumInteritemSpacing = 1.0
        flow.itemSize = CGSize(width: (view.bounds.size.width - 3.0)/4,
                               height: (view.bounds.size.width - 3.0)/4 * 1.3)
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: flow)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: RefreshCollectionViewController.Identifier)
        var count = 3
        collectionView.magiRefresh.bindStyleForHeaderRefresh(
            themeColor: UIColor.blue,
            refreshStyle: style,
            completion: { [weak self] in
                guard let `self` = self else { return }
                Delay(1, completion: {
                    DispatchQueue.main.async {
                        if count > 0 {
                            self.dataArray = ["","","","","","",""]
                            count -= 1
                            collectionView.magiRefresh.header?.endRefreshingWithAlertText(
                                "Did load successfully", completion: nil)
                            collectionView.reloadData()
                        }
                        else {
                            self.dataArray = ["","","","","","",""]
                            collectionView.magiRefresh.header?.endRefreshingWithAlertText(
                                "刷新成功", completion: nil)
                            collectionView.reloadData()
                        }
                        
                    }
                })
        })

        collectionView.magiRefresh.bindStyleForFooterRefresh(
            themeColor: UIColor.red,
            refreshStyle: style,
            completion: { [weak self] in
                guard let `self` = self else { return }
                Delay(1, completion: {
                    DispatchQueue.main.async {
                        if count > 0 {
                            self.dataArray += ["","","","","","",""]
                            count -= 1
                            collectionView.magiRefresh.footer?.endRefreshingWithAlertText(
                                "Did load successfully", completion: nil)
                            collectionView.reloadData()
                        }
                        else {
                            self.dataArray = ["","","","","","",""]
                            collectionView.magiRefresh.footer?.endRefreshingWithAlertText(
                                "刷新成功", completion: nil)
                            collectionView.reloadData()
                        }
                        
                    }
                })
        })

        collectionView.magiRefresh.header?.backgroundColor = UIColor.lightGray
        
        return collectionView
    }()
    
    fileprivate static let Identifier = "CellID"
    fileprivate var style: MagiRefreshStyle
    fileprivate var dataArray = ["","","","","","",""]
    
    init(_ style: MagiRefreshStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print(self.debugDescription+"------销毁了")
    }
    
}

// MARK: - customize
extension RefreshCollectionViewController {
    
    fileprivate func setupUI() {
        navigationItem.title = "UICollectionView"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(), for: .default)
        
        let refresh = UIBarButtonItem(
            title: "刷新",
            style: .plain,
            target: self,
            action: #selector(refreshAction(_:)))
        navigationItem.rightBarButtonItem = refresh
        view.addSubview(collectionView)
    }
    
}

// MARK: - action
extension RefreshCollectionViewController {
    
    @objc
    fileprivate func refreshAction(_ sender: UIBarButtonItem) {
        collectionView.magiRefresh.header?.beginRefreshing()
    }
    
}

// MARK: - UICollectionViewDelegate
extension RefreshCollectionViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension RefreshCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RefreshCollectionViewController.Identifier,
            for: indexPath)
        let items: CGFloat = CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
        cell.contentView.backgroundColor = UIColor.blue.withAlphaComponent((items-CGFloat(indexPath.row)*0.5)/items)
        
        return cell
    }
    
}
