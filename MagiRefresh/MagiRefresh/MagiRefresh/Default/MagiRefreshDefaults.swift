//
//  MagiRefreshDefaults.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/4.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

enum MagiRefreshStyle: Int {
    case native = 0
    case replicatorWoody
    case replicatorAllen
    case replicatorCircle
    case replicatorDot
    case replicatorArc
    case replicatorTriangle
    case animatableRing
    case animatableArrow
}

class MagiRefreshDefaults {
    
    var headerDefaultStyle: MagiRefreshStyle = .animatableArrow
    var footerDefaultStyle: MagiRefreshStyle = .native
    var themeColor: UIColor = UIColor.blue
    var backgroundColor: UIColor = UIColor.white
    var headPullingText: String = "继续下拉"
    var footPullingText: String = "继续上拉"
    var readyText: String = "松开刷新"
    var refreshingText: String = "正在加载"
    
    static let shard = MagiRefreshDefaults()
    
}
