//
//  MagiAlertLabel.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/3.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public class MagiAlertLabel: UILabel, CAAnimationDelegate {
    
    // MARK: - 控件
    fileprivate lazy var new: CAGradientLayer = {
        let new = CAGradientLayer()
        new.locations = [0.2,0.5,0.8]
        new.startPoint = CGPoint(x: 0.0, y: 0.5)
        new.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return new
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        new.frame = CGRect(x: 0, y: 0, width: 0, height: magi_height)
        new.position = CGPoint(x: magi_width/2.0, y: magi_height/2.0)
    }
    
    
    fileprivate func setupUI() {
        layer.masksToBounds = true
        layer.addSublayer(new)
    }
    
    public func startAnimating() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        new.colors = [textColor.withAlphaComponent(0.2).cgColor,
                      textColor.withAlphaComponent(0.1).cgColor,
                      textColor.withAlphaComponent(0.2).cgColor]
        
        let animation = CABasicAnimation(keyPath: "bounds.size.width")
        animation.fromValue = 0
        animation.toValue = magi_width
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        
        new.add(animation,
                forKey: animation.keyPath)
    }
    
    public func stopAnimating() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.0
        }
        new.removeAllAnimations()
    }

}
