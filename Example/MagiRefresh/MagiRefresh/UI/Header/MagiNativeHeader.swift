//
//  MagiNativeHeader.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/4.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public class MagiNativeHeader: MagiRefreshHeaderConrol {
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(
            style: .gray)
        indicator.hidesWhenStopped = false

        return indicator
    }()
    
    override public func setupProperties() {
        super.setupProperties()
        
        addSubview(indicator)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: magi_width/2.0,
                                   y: magi_height/2.0);
    }
    
    override public func magiDidScrollWithProgress(progress: CGFloat, max: CGFloat) {
       
    }
    
    override public func magiRefreshStateDidChange(_ status: MagiRefreshStatus) {
        super.magiRefreshStateDidChange(status)
        switch status {
        case .none:
            break
        case .scrolling:
            break
        case .ready:
            break
        case .refreshing:
            indicator.startAnimating()
        case .willEndRefresh:
            indicator.stopAnimating()
        }
    }
    
}
