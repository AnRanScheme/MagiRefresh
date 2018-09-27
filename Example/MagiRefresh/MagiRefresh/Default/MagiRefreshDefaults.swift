//
//  MagiRefreshDefaults.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/4.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public enum MagiRefreshStyle: Int {
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

public class MagiRefreshDefaults {
    
    public var headerDefaultStyle: MagiRefreshStyle = .animatableArrow
    public var footerDefaultStyle: MagiRefreshStyle = .native
    public var themeColor: UIColor = UIColor.blue
    public var backgroundColor: UIColor = UIColor.white
    public var headPullingText: String = "继续下拉"
    public var footPullingText: String = "继续上拉"
    public var readyText: String = "松开刷新"
    public var refreshingText: String = "正在加载"
    
    public static let shared = MagiRefreshDefaults()
    
}
