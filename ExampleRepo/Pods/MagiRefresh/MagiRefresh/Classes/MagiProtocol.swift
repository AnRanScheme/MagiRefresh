//
//  MagiProtocol.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/8/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

// MARK: - MagiInitAware 定义协议，使得程序在初始化的时候，将遵循该协议的类做了方法交换
protocol MagiInitAware: class {
    static func awake()
}

class NotInitMagi {
    
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? MagiInitAware.Type)?.awake()
        }
        types.deallocate()
    }
    
}

extension UIApplication {
    
    private static let runOnce: Void = {
        NotInitMagi.harmlessFunction()
    }()
    
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
    
}
