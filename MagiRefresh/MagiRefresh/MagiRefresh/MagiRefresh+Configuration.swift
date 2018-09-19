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
    
    func bindStyleForHeaderRefresh(themeColor: UIColor = MagiRefreshDefaults.shared.themeColor,
                                   refreshStyle: MagiRefreshStyle = MagiRefreshDefaults.shared.headerDefaultStyle,
                                   completion: @escaping MagiRefreshClosure) {
        var header: MagiRefreshHeaderConrol?
        switch refreshStyle {
        case .native:
            header = MagiNativeHeader()
        case .replicatorWoody:
            fallthrough
        case .replicatorAllen:
            fallthrough
        case .replicatorCircle:
            fallthrough
        case .replicatorDot:
            fallthrough
        case .replicatorArc:
            fallthrough
        case .replicatorTriangle:
            header = MagiReplicatorHeader()
            if let head = header as? MagiReplicatorHeader {
                head.animationStyle = MagiReplicatorLayerAnimationStyle(
                    rawValue: refreshStyle.rawValue - 1) ?? .woody
            }
        case .animatableRing:
            header = MagiRingIndicatorHeader()
        case .animatableArrow:
            header = MagiArrowHeader()
        }
        header?.refreshClosure = completion
        header?.themeColor = themeColor
        if let head = header {
            self.header = head
        }
        
    }
    
    func bindStyleForFooterRefresh(themeColor: UIColor = MagiRefreshDefaults.shared.themeColor,
                                   refreshStyle: MagiRefreshStyle = MagiRefreshDefaults.shared.footerDefaultStyle,
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



