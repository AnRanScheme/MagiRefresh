//
//  MagiRefreshProtocol.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/3.
//  Copyright © 2018年 anran. All rights reserved.
//


/**
 #ifndef Kafka_REQUIRES_SUPER
 # if __has_attribute(objc_requires_super)
 #  define Kafka_REQUIRES_SUPER __attribute__((objc_requires_super))
 # else
 #  define Kafka_REQUIRES_SUPER
 # endif
 #endif
 */

import Foundation
import UIKit

enum MagiRefreshPosition: Int {
    case header
    case footer
}

enum MagiRefreshStatus: Int {
    case none
    case scrolling
    case ready
    case refreshing
    case willEndRefresh
}

/// 类专属协议 使用的时候 要用weak修饰
protocol MagiRefreshControlProtocol: class {
    
    /// when the state of the refresh control changes, the method is called
    ///
    /// - Parameter status: MagiRefreshStatus(状态)
    func magiRefreshStateDidChange(_ status: MagiRefreshStatus)
    
    /// when the state of the refresh control changes, the method is called
    ///
    /// - Parameters:
    ///   - progress: the current position offset of the control as a percentage of the offset that triggered the refresh
    ///   - max: the offset that triggered the refresh
    func magiDidScrollWithProgress(progress: CGFloat, max: CGFloat)
}
