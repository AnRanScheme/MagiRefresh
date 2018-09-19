//
//  MagiArrowHeader.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/5.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class MagiArrowHeader: MagiRefreshHeaderConrol {
    
    var pullingText: String = MagiRefreshDefaults.shard.headPullingText
    var readyText: String = MagiRefreshDefaults.shard.readyText
    var refreshingText: String = MagiRefreshDefaults.shard.refreshingText
    
    fileprivate lazy var arrowImgV: UIImageView = {
        let arrowImgV = UIImageView()
        let path = Bundle.main.path(forResource: "Image", ofType: "bundle", inDirectory: nil) ?? ""
        let urlString = (path as NSString).appendingPathComponent("arrow.png")
        let image = UIImage(contentsOfFile: urlString)
        arrowImgV.image = image
        arrowImgV.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        return arrowImgV
    }()
    
    fileprivate lazy var promptlabel: UILabel = {
        let promptlabel = UILabel()
        promptlabel.textAlignment = .center
        promptlabel.textColor = UIColor.lightGray
        promptlabel.sizeToFit()
        if #available(iOS 8.2, *) {
            promptlabel.font = UIFont.systemFont(ofSize: 11,
                                                 weight: UIFont.Weight.thin)
        }
            
        else {
            promptlabel.font = UIFont.systemFont(ofSize: 11)
        }

        return promptlabel
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(
            activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    override func setupProperties() {
        super.setupProperties()
        addSubview(arrowImgV)
        addSubview(promptlabel)
        addSubview(indicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        promptlabel.sizeToFit()
        promptlabel.center = CGPoint(x: magi_width/2, y: magi_height/2)
        arrowImgV.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        arrowImgV.magi_right = promptlabel.magi_left-20.0
        print("promptlabel.magi_left-20.0===\(promptlabel.magi_left-20.0)")
        print("arrowImgV.magi_right===\(arrowImgV.magi_right)")
        arrowImgV.magi_centerY = promptlabel.magi_centerY
        print("promptlabelFrame----\(promptlabel.frame)")
        print("arrowImgVFrame----\(arrowImgV.frame)")
        indicator.center = arrowImgV.center
    }
    
    override func magiDidScrollWithProgress(progress: CGFloat, max: CGFloat) {
        super.magiDidScrollWithProgress(progress: progress, max: max)
    }
    
    override func magiRefreshStateDidChange(_ status: MagiRefreshStatus) {
        super.magiRefreshStateDidChange(status)
        switch status {
        case .none:
            arrowImgV.isHidden = false
             indicator.stopAnimating()
            UIView.animate(withDuration: 0.3) {
                self.arrowImgV.transform = CGAffineTransform.identity
            }
        case .scrolling:
            promptlabel.text = pullingText
            promptlabel.sizeToFit()
            UIView.animate(withDuration: 0.3) {
                self.arrowImgV.transform = CGAffineTransform.identity
            }
        case .ready:
            indicator.stopAnimating()
            promptlabel.text = readyText
            UIView.animate(withDuration: 0.3) {
                self.arrowImgV.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        case .refreshing:
            promptlabel.text = refreshingText
            arrowImgV.isHidden = true
            indicator.startAnimating()
        case .willEndRefresh:
            indicator.stopAnimating()
        }
    }
     
}
