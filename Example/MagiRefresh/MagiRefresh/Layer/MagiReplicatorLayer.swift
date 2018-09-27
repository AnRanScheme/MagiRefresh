//
//  MagiReplicatorLayer.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/19.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public enum MagiReplicatorLayerAnimationStyle: Int {
    case woody
    case allen
    case circle
    case dot
    case arc
    case triangle
}

public class MagiReplicatorLayer: CALayer {
    
    struct RuntimeKey {
        static let leftDot = UnsafeRawPointer.init(
            bitPattern: "leftDot".hashValue)
        
        static let rightDot = UnsafeRawPointer.init(
            bitPattern: "RightDot".hashValue)
    }
    
    public var leftCircle: CAShapeLayer {
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
                objc.strokeColor = themeColor.cgColor
                objc.backgroundColor = themeColor.cgColor
                objc_setAssociatedObject(
                    self,
                    RuntimeKey.leftDot!,
                    objc,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return objc
            }
        }
    }
    
    public var rightCircle: CAShapeLayer {
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
                objc.strokeColor = themeColor.cgColor
                objc.backgroundColor = themeColor.cgColor
                objc_setAssociatedObject(
                    self,
                    RuntimeKey.rightDot!,
                    objc,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return objc
            }
        }
    }
    
    public lazy var replicatorLayer: CAReplicatorLayer = {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.backgroundColor = UIColor.clear.cgColor
        replicatorLayer.shouldRasterize = true
        replicatorLayer.rasterizationScale = UIScreen.main.scale
        
        return replicatorLayer
    }()
    
    public lazy var indicatorShapeLayer: CAShapeLayer = {
        let indicatorShapeLayer = CAShapeLayer()
        indicatorShapeLayer.contentsScale = UIScreen.main.scale
        indicatorShapeLayer.lineCap = CAShapeLayerLineCap.round
        
        return indicatorShapeLayer
    }()
        
    
    public var themeColor: UIColor = MagiRefreshDefaults.shared.themeColor {
        didSet {
            indicatorShapeLayer.strokeColor = themeColor.cgColor
            indicatorShapeLayer.backgroundColor = themeColor.cgColor
        }
    }

    
    public var animationStyle: MagiReplicatorLayerAnimationStyle = .woody {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    override init() {
        super.init()
        addSublayer(replicatorLayer)
        replicatorLayer.addSublayer(indicatorShapeLayer)
        indicatorShapeLayer.strokeColor = themeColor.cgColor
        indicatorShapeLayer.backgroundColor = themeColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSublayers() {
        super.layoutSublayers()
        replicatorLayer.frame = bounds
        let padding: CGFloat = 10.0
        switch animationStyle {
        case .woody:
            let h: CGFloat = magi_height / 3.0
            let w: CGFloat = 3.0
            let x: CGFloat = magi_width / 2.0 - (2.5 * w + padding * 2)
            let y: CGFloat = magi_height/2.0-h/2.0
            indicatorShapeLayer.frame = CGRect(x: x, y: y, width: w, height: h)
            indicatorShapeLayer.cornerRadius = 1.0
            indicatorShapeLayer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
            
            replicatorLayer.instanceCount = 5
            replicatorLayer.instanceDelay = 0.3/5
            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(padding, 0.0, 0.0)
            replicatorLayer.instanceBlueOffset = -0.01
            replicatorLayer.instanceGreenOffset = -0.01
        case .allen:
            let h: CGFloat = magi_height / 3.0
            let w: CGFloat  = 3.0
            let x: CGFloat = magi_width / 2.0 - (2.5 * w + padding * 2)
            let y: CGFloat = magi_height/2.0-h/2.0
            indicatorShapeLayer.frame = CGRect(x: x, y: y, width: w, height: h)
            indicatorShapeLayer.cornerRadius = 1.0
            
            replicatorLayer.instanceCount = 5
            replicatorLayer.instanceDelay = 0.3/5
            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(padding, 0.0, 0.0)
            replicatorLayer.instanceBlueOffset = -0.01
            replicatorLayer.instanceGreenOffset = -0.01
        case .circle:
            indicatorShapeLayer.frame = CGRect(x:magi_width/2.0 - 2.0, y: 10, width: 4.0, height: 4.0)
            indicatorShapeLayer.cornerRadius = 2.0
            indicatorShapeLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
            
            replicatorLayer.instanceCount = 12
            replicatorLayer.instanceDelay = 0.8/12
            let angle: CGFloat = CGFloat.pi*2/CGFloat(replicatorLayer.instanceCount)
            replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 0.1)
            replicatorLayer.instanceBlueOffset = -0.01
            replicatorLayer.instanceGreenOffset = -0.01
        case .dot:
            let innerPadding: CGFloat = 30.0
            let h: CGFloat = 8.0
            let w: CGFloat = 8.0
            let x: CGFloat = magi_width / 2.0 - (1.5 * w + innerPadding * 1)
            let y: CGFloat = magi_height/2.0 - h/2.0
            indicatorShapeLayer.frame = CGRect(x: x, y: y, width: w, height: h)
            indicatorShapeLayer.cornerRadius = 4.0
            
            replicatorLayer.instanceCount = 3
            replicatorLayer.instanceDelay = 0.5/3
            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(innerPadding, 0.0, 0.0)
        case .arc:
            let h: CGFloat = magi_height - 10.0
            let w: CGFloat = h
            let x: CGFloat = magi_width/2.0 - 0.5 * w
            let y: CGFloat = magi_height/2.0 - h/2.0
            indicatorShapeLayer.frame = CGRect(x: x, y: y, width: w, height: h)
            indicatorShapeLayer.fillColor = UIColor.clear.cgColor
            indicatorShapeLayer.lineWidth = 3.0
            indicatorShapeLayer.backgroundColor = UIColor.clear.cgColor
            
            let arcPath = UIBezierPath(
                arcCenter: CGPoint(x: w/2.0, y: h/2.0),
                radius: h/2.0,
                startAngle: CGFloat.pi/2.3,
                endAngle: -CGFloat.pi/2.3,
                clockwise: false)

            indicatorShapeLayer.path = arcPath.cgPath
            indicatorShapeLayer.strokeEnd = 0.1
            replicatorLayer.instanceCount = 2
            replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 0.1)
        case .triangle:
            indicatorShapeLayer.frame = CGRect(x: replicatorLayer.magi_width/2.0, y:5.0, width: 8.0, height: 8.0)
            indicatorShapeLayer.cornerRadius = indicatorShapeLayer.magi_width/2.0
            let topPoint: CGPoint = indicatorShapeLayer.position
            let leftPoint: CGPoint = CGPoint(x:topPoint.x-15, y:topPoint.y+23)
            let rightPoint: CGPoint = CGPoint(x:topPoint.x+15, y:topPoint.y+23)
            
            leftCircle.removeFromSuperlayer()
            rightCircle.removeFromSuperlayer()

            leftCircle.magi_size = indicatorShapeLayer.magi_size
            leftCircle.position = leftPoint
            leftCircle.cornerRadius = indicatorShapeLayer.cornerRadius
            replicatorLayer.addSublayer(leftCircle)
            
            rightCircle.magi_size = indicatorShapeLayer.magi_size
            rightCircle.position = rightPoint
            rightCircle.cornerRadius = indicatorShapeLayer.cornerRadius
            replicatorLayer.addSublayer(rightCircle)
        }

    }
    
}

extension MagiReplicatorLayer {
    
    fileprivate func animationKeyPath(keyPath: String,
                                      from fromValue: CGFloat,
                                      to toValue: CGFloat,
                                      duration: CFTimeInterval,
                                      repeatTime: Float)->CABasicAnimation {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = repeatTime
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    fileprivate func keyFrameAnimation(with path: UIBezierPath,
                                       duration: TimeInterval)->CAKeyframeAnimation {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = path.cgPath
        animation.duration = duration
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    fileprivate func trianglePath(with startPoint:CGPoint, vertexs: [CGPoint])->UIBezierPath {
        let topPoint: CGPoint  = vertexs[0]
        let leftPoint: CGPoint  = vertexs[1]
        let rightPoint: CGPoint  = vertexs[2]
        
        let path = UIBezierPath()
        if startPoint.equalTo(topPoint) {
            path.move(to: startPoint)
            path.addLine(to: rightPoint)
            path.addLine(to: leftPoint)
            
        }
        else if startPoint.equalTo(leftPoint) {
            path.move(to: startPoint)
            path.addLine(to: topPoint)
            path.addLine(to: rightPoint)
        }
        else {
            path.move(to: startPoint)
            path.addLine(to: leftPoint)
            path.addLine(to: topPoint)
        }
        path.close()
        
        return path
    }
    
    
}

extension MagiReplicatorLayer: MagiAnimatableProtocol {
    
    public func startAnimating() {
        indicatorShapeLayer.removeAllAnimations()
        switch animationStyle {
        case .woody:
            let basicAnimation = animationKeyPath(keyPath: "transform.scale.y",
                                                  from: 1.5,
                                                  to: 0.0,
                                                  duration: 0.3,
                                                  repeatTime: Float.infinity)
            basicAnimation.autoreverses = true
            indicatorShapeLayer.add(basicAnimation, forKey: basicAnimation.keyPath)
        case .allen:
            let basicAnimation = animationKeyPath(keyPath: "position.y",
                                                  from: indicatorShapeLayer.position.y+10,
                                                  to: indicatorShapeLayer.position.y-10,
                                                  duration: 0.3,
                                                  repeatTime: Float.infinity)
            basicAnimation.autoreverses = true
            indicatorShapeLayer.add(basicAnimation, forKey: basicAnimation.keyPath)
        case .circle:
            let basicAnimation = animationKeyPath(keyPath: "transform.scale",
                                                  from: 1.0,
                                                  to: 0.2,
                                                  duration: 0.8,
                                                  repeatTime: Float.infinity)
            
            indicatorShapeLayer.add(basicAnimation, forKey: basicAnimation.keyPath)
        case .dot:
            let basicAnimation = animationKeyPath(keyPath: "transform.scale",
                                                  from: 0.3,
                                                  to: 2.5,
                                                  duration: 0.5,
                                                  repeatTime: Float.infinity)
            basicAnimation.autoreverses = true

            let opc = animationKeyPath(keyPath: "opacity",
                                       from: 0.1,
                                       to: 1.0,
                                       duration: 0.5,
                                       repeatTime: Float.infinity)
            opc.autoreverses = true
            let group = CAAnimationGroup()
            group.animations = [basicAnimation,opc]
            group.autoreverses = true
            group.repeatCount = Float.infinity
            group.duration = 0.5
            indicatorShapeLayer.add(basicAnimation, forKey: basicAnimation.keyPath)
        case .arc:
            let basicAnimation = animationKeyPath(keyPath: "transform.rotation.z",
                                                  from: CGFloat.pi*2,
                                                  to: 0,
                                                  duration:0.8,
                                                  repeatTime: Float.infinity)
            indicatorShapeLayer.add(basicAnimation, forKey: basicAnimation.keyPath)
        case .triangle:
            let topPoint: CGPoint = indicatorShapeLayer.position
            let leftPoint: CGPoint = leftCircle.position
            let rightPoint: CGPoint = rightCircle.position
            
            let vertexs = [topPoint,
                           leftPoint,
                           rightPoint]
            
            let key0 = keyFrameAnimation(with: trianglePath(with: topPoint, vertexs: vertexs),
                                         duration: 1.5)
            
            indicatorShapeLayer.add(key0, forKey: key0.keyPath)
            
            let key1 = keyFrameAnimation(with: trianglePath(with: leftPoint, vertexs: vertexs),
                                         duration: 1.5)
            
            leftCircle.add(key1, forKey: key1.keyPath)
            
            let key2 = keyFrameAnimation(with: trianglePath(with: rightPoint, vertexs: vertexs),
                                         duration: 1.5)
            
            rightCircle.add(key2, forKey: key2.keyPath)
        }
    }
    
    public func stopAnimating() {
        indicatorShapeLayer.removeAllAnimations()
        switch animationStyle {
        case .woody:
            fallthrough
        case .allen:
            fallthrough
        case .circle:
            fallthrough
        case .dot:
            break
        case .arc:
            indicatorShapeLayer.strokeEnd = 0.1
        case .triangle:
            leftCircle.removeAllAnimations()
            rightCircle.removeAllAnimations()
        }
    }

}
