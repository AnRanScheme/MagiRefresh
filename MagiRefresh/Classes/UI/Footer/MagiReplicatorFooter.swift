//
//  MagiReplicatorFooter.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/19.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public class MagiReplicatorFooter: MagiRefreshFooterConrol {

    fileprivate lazy var replicatorLayer: MagiReplicatorLayer = {
        let replicatorLayer = MagiReplicatorLayer()
        
        return replicatorLayer
    }()
    
    public var animationStyle: MagiReplicatorLayerAnimationStyle = .woody {
        didSet{
            replicatorLayer.animationStyle = animationStyle
        }
    }
    
    override public var themeColor: UIColor {
        didSet{
            replicatorLayer.themeColor = themeColor
        }
    }
    
    override public func setupProperties() {
        super.setupProperties()
        layer.addSublayer(replicatorLayer)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        replicatorLayer.frame = CGRect(x: 0,
                                       y: 0,
                                       width: magi_width,
                                       height: magi_height)
    }
    
    override public func magiDidScrollWithProgress(progress: CGFloat, max: CGFloat) {
        switch animationStyle {
        case .woody:
            break
        case .allen:
            break
        case .circle:
            break
        case .dot:
            break
        case .arc:
            var progress1 = progress
            if (progress1 >= 0.7) {
                progress1 = (progress1-0.7)/(max - 0.7)
                replicatorLayer.indicatorShapeLayer.strokeEnd = progress1
            }
        case .triangle:
            break
        }
    }
    
    override public func magiRefreshStateDidChange(_ status: MagiRefreshStatus) {
        super.magiRefreshStateDidChange(status)
        switch status {
        case .none:
            fallthrough
        case .scrolling:
            fallthrough
        case .ready:
            replicatorLayer.opacity = 1.0
        case .refreshing:
            replicatorLayer.startAnimating()
        case .willEndRefresh:
            replicatorLayer.stopAnimating()
        }
    }

}
