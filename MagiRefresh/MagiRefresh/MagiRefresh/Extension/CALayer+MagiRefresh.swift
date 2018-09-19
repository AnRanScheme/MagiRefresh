//
//  CALayer+Magi.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然  on 2018/8/10.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

extension CALayer {

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
            frame.origin.x = newValue - frame.size.width
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
            frame.origin.y = newValue - frame.origin.y
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
            frame.size.width = newValue
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
            frame.size.height = newValue
            self.frame = frame
        }
    }

    //center.x
    public var magi_positionX: CGFloat {
        get {
            return self.position.x
        }
        set {
            self.position = CGPoint(x: newValue, y: self.position.y)
        }
    }

    //center.y
    public var magi_positionY: CGFloat {
        get {
            return self.position.y
        }
        set {
            self.position = CGPoint(x: self.position.x, y: newValue)
        }
    }

    //frame.origin
    public var magi_origin: CGPoint {
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
    public var magi_size: CGSize {
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
