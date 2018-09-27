//
//  MagiRingIndicatorFooter.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/19.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public class MagiRingIndicatorFooter: MagiRefreshFooterConrol {

    fileprivate lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(
            style: .gray)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    fileprivate lazy var arcLayer: MagiArcLayer = {
        let arcLayer = MagiArcLayer()
        
        return arcLayer
    }()
    
    override public func setupProperties() {
        super.setupProperties()
        layer.addSublayer(arcLayer)
        addSubview(indicator)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        arcLayer.frame = CGRect(x: 0,
                                y: 0,
                                width: magi_width,
                                height: magi_height)
        indicator.center = CGPoint(x: magi_width/2.0,
                                   y: magi_height/2.0)
    }
    
    override public func magiDidScrollWithProgress(progress: CGFloat, max: CGFloat) {
        var progress1 = progress
        if (progress1 >= 0.3) {
            progress1 = (progress1-0.3)/(max - 0.3)
        }
        arcLayer.setProgress(progress1)
    }
    
    override public func magiRefreshStateDidChange(_ status: MagiRefreshStatus) {
        super.magiRefreshStateDidChange(status)
        switch status {
        case .none:
            break
        case .scrolling:
            break
        case .ready:
            arcLayer.opacity = 1.0
        case .refreshing:
            arcLayer.startAnimating()
            arcLayer.isHidden = true
            indicator.startAnimating()
        case .willEndRefresh:
            arcLayer.stopAnimating()
            arcLayer.isHidden = false
            indicator.stopAnimating()
        }
    }

}
