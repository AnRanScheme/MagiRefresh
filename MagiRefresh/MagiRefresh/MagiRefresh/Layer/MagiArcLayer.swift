//
//  MagiArcLayer.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/19.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class MagiArcLayer: CALayer {
    
    fileprivate lazy var ringBackgroundLayer: CAShapeLayer = {
        let ringBackgroundLayer = CAShapeLayer()
        ringBackgroundLayer.lineWidth = 3
        ringBackgroundLayer.lineCap = kCALineCapRound
        ringBackgroundLayer.backgroundColor = UIColor.clear.cgColor
        ringBackgroundLayer.fillColor = UIColor.clear.cgColor
        ringBackgroundLayer.strokeColor = ringBackgroundColor.cgColor
        
        return ringBackgroundLayer
    }()
    
    fileprivate lazy var ringShapeLayer: CAShapeLayer = {
        let ringShapeLayer = CAShapeLayer()
        ringShapeLayer.lineWidth = 3
        ringShapeLayer.lineCap = kCALineCapRound
        ringShapeLayer.backgroundColor = UIColor.clear.cgColor
        ringShapeLayer.fillColor = UIColor.clear.cgColor
        ringShapeLayer.strokeColor = ringFillColor.cgColor
        ringShapeLayer.strokeEnd = 0
        
        return ringShapeLayer
    }()
    
    fileprivate var bezierPath: UIBezierPath = UIBezierPath()
    
    public var ringBackgroundColor: UIColor = UIColor(red: 180, green: 180, blue: 180, alpha: 1) {
        didSet {
            ringBackgroundLayer.strokeColor = ringBackgroundColor.cgColor
        }
    }
    
    public var ringFillColor: UIColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1) {
        didSet {
           ringShapeLayer.strokeColor = ringFillColor.cgColor
        }
    }
    
    override init() {
        super.init()
        addSublayer(ringBackgroundLayer)
        ringBackgroundLayer.addSublayer(ringShapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        ringBackgroundLayer.frame = CGRect(x: 0,
                                           y: 0,
                                           width: 30,
                                           height: 30)
        ringBackgroundLayer.position = CGPoint(x: bounds.midX,
                                               y: bounds.midY)
        ringShapeLayer.frame = ringBackgroundLayer.bounds
        ringShapeLayer.position = CGPoint(x: ringBackgroundLayer.bounds.midX,
                                          y: ringBackgroundLayer.bounds.midY)
        
        bezierPath = UIBezierPath(roundedRect: ringShapeLayer.bounds,
                                  cornerRadius: ringShapeLayer.magi_width/2 )
        
        ringBackgroundLayer.path = bezierPath.cgPath
        ringShapeLayer.path = bezierPath.cgPath
    }
    
}

// MARK: - public
extension MagiArcLayer {
    
    public func setProgress(_ progress: CGFloat) {
        ringShapeLayer.strokeEnd = progress
    }
    
}

extension MagiArcLayer: MagiAnimatableProtocol {
    
    func startAnimating() {
        
    }
    
    func stopAnimating() {
        ringShapeLayer.strokeEnd = 0.0
        ringShapeLayer.removeAllAnimations()
    }
    
}
