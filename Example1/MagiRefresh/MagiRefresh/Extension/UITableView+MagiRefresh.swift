//
//  UITableView+Magi.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/8/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

extension UITableView: MagiInitAware {
    
    static func awake() {
        UITableView.classInit()
    }
    
    static func classInit() {
        swizzleMethod
    }
    
    private static let swizzleMethod: Void = {
        /// insertSections
        let originalSelector = #selector(insertSections(_:with:))
        let swizzledSelector = #selector(magi_insertSections(_:with:))
        MagiRunTime.exchangeMethod(selector: originalSelector, replace: swizzledSelector, class: UITableView.self)
        
        /// deleteSections
        let originalSelector1 = #selector(deleteSections(_:with:))
        let swizzledSelector1 = #selector(magi_deleteSections(_:with:))
        MagiRunTime.exchangeMethod(selector: originalSelector1, replace: swizzledSelector1, class: UITableView.self)
        
        /// insertRows
        let originalSelector2 = #selector(insertRows(at:with:))
        let swizzledSelector2 = #selector(magi_insertRowsAtIndexPaths(at:with:))
        MagiRunTime.exchangeMethod(selector: originalSelector2, replace: swizzledSelector2, class: UITableView.self)
        
        /// deleteRows
        let originalSelector3 = #selector(deleteRows(at:with:))
        let swizzledSelector3 = #selector(magi_deleteRowsAtIndexPaths(at:with:))
        MagiRunTime.exchangeMethod(selector: originalSelector3, replace: swizzledSelector3, class: UITableView.self)
        
        /// reloadData
        let originalSelector4 = #selector(reloadData)
        let swizzledSelector4 = #selector(magi_reloadData)
        MagiRunTime.exchangeMethod(selector: originalSelector4, replace: swizzledSelector4, class: UITableView.self)
        
    }()
    
    
    /// section
    @objc
    fileprivate func magi_insertSections(_ sections: NSIndexSet, with animation: UITableView.RowAnimation) {
        magi_insertSections(sections, with: animation)
            magiRefresh.getDataAndSet()
    }
    
    @objc
    fileprivate func magi_deleteSections(_ sections: NSIndexSet, with animation: UITableView.RowAnimation) {
        magi_deleteSections(sections, with: animation)
        magiRefresh.getDataAndSet()
    }
    
    /// row
    @objc
    fileprivate func magi_insertRowsAtIndexPaths(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        magi_insertRowsAtIndexPaths(at: indexPaths, with: animation)
        magiRefresh.getDataAndSet()
    }
    
    @objc
    fileprivate func magi_deleteRowsAtIndexPaths(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        magi_deleteRowsAtIndexPaths(at: indexPaths, with: animation)
        magiRefresh.getDataAndSet()
    }
    
    /// reloadData
    @objc
    fileprivate func magi_reloadData() {
        self.magi_reloadData()
        magiRefresh.getDataAndSet()
    }
    
}
