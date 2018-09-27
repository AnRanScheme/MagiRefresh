//
//  UIView+Position.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/7/30.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    //frame.origin.x
    var magi_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    //frame.origin.y
    var magi_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    //frame.origin.x + frame.size.width
    var magi_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }
    
    //frame.origin.y + frame.size.height
    var magi_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.origin.y
            self.frame = frame
        }
    }
    
    //frame.size.width
    var magi_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    //frame.size.height
    var magi_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    //center.x
    var magi_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue,
                                  y: self.center.y)
        }
    }
    
    //center.y
    var magi_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x,
                                  y: newValue)
        }
    }
    
    //frame.origin
    var magi_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    //frame.size
    var magi_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    //maxX
    var magi_maxX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    //maxY
    var magi_maxY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    public class func setAnimate(animations: @escaping (()->Void),
                          completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       options: .curveLinear,
                       animations: animations,
                       completion: completion)
    }
    
}
