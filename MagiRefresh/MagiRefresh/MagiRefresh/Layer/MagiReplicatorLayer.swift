//
//  MagiReplicatorLayer.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/19.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

enum MagiReplicatorLayerAnimationStyle {
    case woody
    case allen
    case circle
    case dot
    case arc
    case triangle
}

class MagiReplicatorLayer: CALayer {
    
    struct RuntimeKey {
        static let leftDot = UnsafeRawPointer.init(
            bitPattern: "leftDot".hashValue)
        
        static let rightDot = UnsafeRawPointer.init(
            bitPattern: "RightDot".hashValue)
    }
    
    var leftCircle: CAShapeLayer {
        set {
            objc_setAssociatedObject(
                self,
                RuntimeKey.leftDot!,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let objc = objc_getAssociatedObject(
                self,
                RuntimeKey.leftDot!)
                as? CAShapeLayer {
                return objc
            }
            else {
                let objc = CAShapeLayer()
                objc.backgroundColor = indicatorShapeLayer.backgroundColor
                objc_setAssociatedObject(
                    self,
                    RuntimeKey.leftDot!,
                    objc,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return objc
            }
        }
    }
    
    var rightCircle: CAShapeLayer {
        set {
            objc_setAssociatedObject(
                self,
                RuntimeKey.rightDot!,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let objc = objc_getAssociatedObject(
                self,
                RuntimeKey.rightDot!)
                as? CAShapeLayer {
                return objc
            }
            else {
                let objc = CAShapeLayer()
                objc.backgroundColor = indicatorShapeLayer.backgroundColor
                objc_setAssociatedObject(
                    self,
                    RuntimeKey.rightDot!,
                    objc,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return objc
            }
        }
    }
    
    lazy var replicatorLayer: CAReplicatorLayer = {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.backgroundColor = UIColor.clear.cgColor
        replicatorLayer.shouldRasterize = true
        replicatorLayer.rasterizationScale = UIScreen.main.scale
        
        return replicatorLayer
    }()
    
    lazy var indicatorShapeLayer: CAShapeLayer = {
        let indicatorShapeLayer = CAShapeLayer()
        indicatorShapeLayer.contentsScale = UIScreen.main.scale
        indicatorShapeLayer.lineCap = kCALineCapRound
        
        return indicatorShapeLayer
    }()
        
    
    var themeColor: UIColor = MagiRefreshDefaults.shared.themeColor {
        didSet {
            indicatorShapeLayer.strokeColor = themeColor.cgColor
        }
    }
    
    var themeBackgroundColor: UIColor = MagiRefreshDefaults.shared.backgroundColor {
        didSet {
            indicatorShapeLayer.backgroundColor = themeBackgroundColor.cgColor
        }
    }
        
    var animationStyle: MagiReplicatorLayerAnimationStyle = .woody {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init() {
        super.init()
        addSublayer(replicatorLayer)
        replicatorLayer.addSublayer(indicatorShapeLayer)
        indicatorShapeLayer.strokeColor = themeColor.cgColor
        indicatorShapeLayer.backgroundColor = themeBackgroundColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
    }
    
}

extension MagiReplicatorLayer: MagiAnimatableProtocol {
    
    func startAnimating() {
        
    }
    
    func stopAnimating() {
        
    }

}
