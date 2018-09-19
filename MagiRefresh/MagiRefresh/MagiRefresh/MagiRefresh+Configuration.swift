//
//  MagiRefresh+Configuration.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/4.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit


// MARK: - MagiRefresh+Configuration
extension MagiRefresh {
    
    func bindStyleForHeaderRefresh(themeColor: UIColor = MagiRefreshDefaults.shard.themeColor,
                                   refreshStyle: MagiRefreshStyle = MagiRefreshDefaults.shard.headerDefaultStyle,
                                   completion: @escaping MagiRefreshClosure) {
        var header: MagiRefreshHeaderConrol?
        switch refreshStyle {
        case .native:
            header = MagiNativeHeader()
        case .animatableArrow:
            header = MagiArrowHeader()
        case .animatableRing:
            break
        case .replicatorAllen:
            break
        case .replicatorArc:
            break
        case .replicatorCircle:
            break
        case .replicatorDot:
            break
        case .replicatorTriangle:
            break
        case .replicatorWoody:
            break
        }
        header?.refreshClosure = completion
        header?.themeColor = themeColor
        if let head = header {
            self.header = head
        }
        
    }
    
    func bindStyleForFooterRefresh(themeColor: UIColor = MagiRefreshDefaults.shard.themeColor,
                                   refreshStyle: MagiRefreshStyle = MagiRefreshDefaults.shard.footerDefaultStyle,
                                   completion: @escaping MagiRefreshClosure) {

        var footer: MagiRefreshFooterConrol?
        switch refreshStyle {
        case .native:
            footer = MagiNativeFooter()
        case .animatableArrow:
            footer = MagiArrowFooter()
        case .animatableRing:
            break
        case .replicatorAllen:
            break
        case .replicatorArc:
            break
        case .replicatorCircle:
            break
        case .replicatorDot:
            break
        case .replicatorTriangle:
            break
        case .replicatorWoody:
            break
        }
        footer?.refreshClosure = completion
        footer?.themeColor = themeColor
        if let foot = footer {
            self.footer = foot
        }
        
    }
    
}



