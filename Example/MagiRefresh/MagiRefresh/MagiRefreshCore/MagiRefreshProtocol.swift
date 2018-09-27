//
//  MagiRefreshProtocol.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/3.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation
import UIKit

public enum MagiRefreshStatus: Int {
    case none
    case scrolling
    case ready
    case refreshing
    case willEndRefresh
}

/// 类专属协议 使用的时候 要用weak修饰
public protocol MagiRefreshControlProtocol: class {
    
    /// when the state of the refresh control changes, the method is called
    ///
    /// - Parameter status: MagiRefreshStatus(状态)
    func magiRefreshControlStateDidChange(_ status: MagiRefreshStatus)
    
    /// when the state of the refresh control changes, the method is called
    ///
    /// - Parameters:
    ///   - progress: the current position offset of the control as a percentage of the offset that triggered the refresh
    ///   - max: the offset that triggered the refresh
    func magiRefreshControlDidScrollWithProgress(progress: CGFloat, max: CGFloat)
}
