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
    public var magi_left: CGFloat {
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
    public var magi_top: CGFloat {
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
    public var magi_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = magi_right - frame.size.width
            self.frame = frame
        }
    }
    
    //frame.origin.y + frame.size.height
    public var magi_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = magi_bottom - frame.origin.y
            self.frame = frame
        }
    }
    
    //frame.size.width
    public var magi_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = magi_width
            self.frame = frame
        }
    }
    
    //frame.size.height
    public var magi_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = magi_height
            self.frame = frame
        }
    }
    
    //center.x
    public var magi_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint.init(x: magi_centerX, y: self.center.y)
        }
    }
    
    //center.y
    public var magi_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint.init(x: self.center.x, y: magi_centerY)
        }
    }
    
    //frame.origin
    public var magi_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = magi_origin
            self.frame = frame
        }
    }
    
    //frame.size
    public var magi_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = magi_size
            self.frame = frame
        }
    }
    
    //maxX
    public var magi_maxX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    //maxY
    public var magi_maxY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    
}
