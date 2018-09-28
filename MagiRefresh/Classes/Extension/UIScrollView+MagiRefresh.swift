
//
//  UIScrollView+PlaceHolder.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/7/30.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    struct RuntimeKey {
        static let magiRefresh = UnsafeRawPointer.init(
            bitPattern: "magiRefresh".hashValue)
    }
    
    public var magiRefresh: MagiRefresh {
        set {
            objc_setAssociatedObject(
                self,
                RuntimeKey.magiRefresh!,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if magiRefresh.scrollView == nil {
                magiRefresh.scrollView = self
            }
        }
        get {
            if let objc = objc_getAssociatedObject(
                self,
                RuntimeKey.magiRefresh!)
                as? MagiRefresh {
                return objc
            }
            else {
                let objc = MagiRefresh()
                objc_setAssociatedObject(
                    self,
                    RuntimeKey.magiRefresh!,
                    objc,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                if objc.scrollView == nil {
                    objc.scrollView = self
                }
                return objc
            }
        }
    }
    
}


extension UIScrollView {

    var offsetX: CGFloat {
        get {
            return self.contentOffset.x
        }
        set {
            var contentOffset = self.contentOffset
            contentOffset.x = newValue
            self.contentOffset = contentOffset
        }
    }

    var offsetY: CGFloat {
        get {
            return self.contentOffset.y
        }
        set {
            var contentOffset = self.contentOffset
            contentOffset.y = newValue
            self.contentOffset = contentOffset
        }
    }

    var insetTop: CGFloat {
        get {
            return self.realContentInset.top
        }
        set{
            var inset = self.contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
    }

    var insetBottom: CGFloat {
        get {
            return self.realContentInset.bottom
        }
        set{
            var inset = self.contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = inset
        }
    }

    var contentHeight: CGFloat {
        return self.contentSize.height
    }

    var realContentInset: UIEdgeInsets {
        if #available(iOS 11.0, *){
            return self.adjustedContentInset
        } else {
            return self.contentInset
        }
    }

}
