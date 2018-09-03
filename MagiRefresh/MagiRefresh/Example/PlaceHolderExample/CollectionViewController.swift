//
//  CollectionViewController.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/8/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    var rows = 0
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        rows += 1
        collectionView?.reloadData()
    }
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        if rows > 0 {
            rows -= 1
            collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print(self.debugDescription+"------销毁了")
    }
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        collectionView?.backgroundColor = UIColor.gray
        collectionView?.collectionViewLayout = layout
        collectionView?.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: reuseIdentifier)
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupNoDataTip()
    }
    
    
    func setupNoDataTip() {
        rows = 3
        collectionView?.reloadData()
        // 创建方式一：Block回调
        /*
        let placeHolder = MagiPlaceHolderView.placeHolderActionViewWithImage(
            imageStr: "mall_myoffer_nodata",
            titleStr: "暂无数据，点击重新加载",
            detailStr: "",
            btnTitleStr: "点击刷新") {
                print("点击刷新")
                weakSelf?.reloadDataWithCount(count: 4)
        }*/
        
        
        // 创建方式二：target/action
        let placeHolder = MagiPlaceHolder.createPlaceHolderWithAction(
            imageName: "mall_myoffer_nodata",
            title: "暂无数据，点击重新加载",
            detailTitle: "zaishi shizheyangzideiahdiusahjdkasjdks",
            refreshBtnTitle: "点击刷新",
            target: self,
            action: #selector(reloadBtnAction))

        placeHolder.titleLabTextColor = UIColor.red
        placeHolder.actionBtnFont = UIFont.systemFont(ofSize: 19)
        placeHolder.contentViewOffset = 50
        placeHolder.actionBtnBackGroundColor = .white
        placeHolder.actionBtnBorderWidth = 0.7
        placeHolder.actionBtnBorderColor = UIColor.gray
        placeHolder.actionBtnCornerRadius = 10
        placeHolder.tapBlankViewClosure = {
            print("点击空白")
        }
        collectionView?.magiRefresh.placeHolder = placeHolder
    }
    
    func reloadDataWithCount(count: Int) {
        rows = count
        collectionView?.reloadData()
    }
    
    @objc func reloadBtnAction() {
        print("点击刷新")
        rows = 5
        collectionView?.reloadData()
    }

}

// MARK: UICollectionViewDataSource
extension CollectionViewController {

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return rows
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let imgV = UIImageView.init(frame: cell.bounds)
        imgV.image = UIImage.init(named: "qq_login")
        cell.addSubview(imgV)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rows -= 1
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
    
}
