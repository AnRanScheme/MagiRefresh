//
//  RunTime.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/7/30.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

struct MagiRunTime {
    
    /// 交换方法
    /// - Parameters:
    ///   - selector: 被交换的方法
    ///   - replace: 用于交换的方法
    ///   - classType: 所属类型
    static func exchangeMethod(selector: Selector,
                               replace: Selector,
                               class classType: AnyClass) {
        let select1 = selector
        let select2 = replace
        let select1Method = class_getInstanceMethod(classType, select1)
        let select2Method = class_getInstanceMethod(classType, select2)
        guard let selectMetho1 = select1Method,
            let selectMethod2 = select2Method else {
                return
        }
        let didAddMethod  = class_addMethod(classType,
                                            select1,
                                            method_getImplementation(selectMethod2),
                                            method_getTypeEncoding(selectMethod2))
        if didAddMethod {
            class_replaceMethod(classType,
                                select2,
                                method_getImplementation(selectMetho1),
                                method_getTypeEncoding(selectMetho1))
        } else {
            method_exchangeImplementations(selectMetho1, selectMethod2)
        }
    }
    
    /// 获取方法列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 方法列表
    static func methods(from classType: AnyClass) -> [Method] {
        var methodNum: UInt32 = 0
        var list = [Method]()
        let methods = class_copyMethodList(classType, &methodNum)
        for index in 0..<numericCast(methodNum) {
            if let met = methods?[index] {
                list.append(met)
            }
        }
        free(methods)
        return list
    }
    
    /// 获取属性列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 属性列表
    
    static func properties(from classType: AnyClass) -> [objc_property_t] {
        var propNum: UInt32 = 0
        let properties = class_copyPropertyList(classType, &propNum)
        var list = [objc_property_t]()
        for index in 0..<Int(propNum) {
            if let prop = properties?[index]{
                list.append(prop)
            }
        }
        free(properties)
        return list
    }
    
    
    /// 成员变量列表
    ///
    /// - Parameter classType: 类型
    /// - Returns: 成员变量
    static func ivars(from classType: AnyClass) -> [Ivar] {
        var ivarNum: UInt32 = 0
        let ivars = class_copyIvarList(classType, &ivarNum)
        var list = [Ivar]()
        for index in 0..<numericCast(ivarNum) {
            if let ivar: objc_property_t = ivars?[index] {
                list.append(ivar)
            }
        }
        free(ivars)
        return list
    }
    
}
