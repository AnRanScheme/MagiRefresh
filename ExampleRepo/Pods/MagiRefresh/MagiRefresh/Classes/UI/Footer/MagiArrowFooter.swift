//
//  MagiArrowFooter.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/5.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation

import UIKit

public class MagiArrowFooter: MagiRefreshFooterConrol {
    
    public var pullingText: String = MagiRefreshDefaults.shared.footPullingText
    public var readyText: String = MagiRefreshDefaults.shared.readyText
    public var refreshingText: String = MagiRefreshDefaults.shared.refreshingText
    
    fileprivate lazy var arrowImgV: UIImageView = {
        let arrowImgV = UIImageView()
        let curBundle = Bundle(for: MagiArrowFooter.classForCoder())
        var curBundleDirectory = ""
        if let curBundleName = curBundle.infoDictionary?["CFBundleName"] as? String {
            curBundleDirectory = curBundleName+".bundle"
        }
        let path = curBundle.path(forResource: "Image", ofType: "bundle", inDirectory: curBundleDirectory) ?? ""
        let urlString = (path as NSString).appendingPathComponent("arrow.png")
        let image = UIImage(contentsOfFile: urlString)
        arrowImgV.image = image
        arrowImgV.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        return arrowImgV
    }()
    
    fileprivate lazy var promptlabel: UILabel = {
        let promptlabel = UILabel()
        promptlabel.textAlignment = .center
        promptlabel.textColor = UIColor.gray
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
            style: .gray)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    override public func setupProperties() {
        super.setupProperties()
        addSubview(arrowImgV)
        addSubview(promptlabel)
        addSubview(indicator)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        promptlabel.sizeToFit()
        promptlabel.center = CGPoint(x: magi_width/2, y: magi_height/2)
        arrowImgV.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        arrowImgV.magi_right = promptlabel.magi_left-20.0
        arrowImgV.magi_centerY = promptlabel.magi_centerY
        
        indicator.center = arrowImgV.center
    }
    
    override public func magiDidScrollWithProgress(progress: CGFloat, max: CGFloat) {
        super.magiDidScrollWithProgress(progress: progress, max: max)
    }
    
    override public func magiRefreshStateDidChange(_ status: MagiRefreshStatus) {
        super.magiRefreshStateDidChange(status)
        switch status {
        case .none:
            arrowImgV.isHidden = false
            indicator.stopAnimating()
            UIView.animate(withDuration: 0.3) {
                self.arrowImgV.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        case .scrolling:
            promptlabel.text = pullingText
            promptlabel.sizeToFit()
            UIView.animate(withDuration: 0.3) {
                self.arrowImgV.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        case .ready:
            indicator.stopAnimating()
            promptlabel.text = readyText
            UIView.animate(withDuration: 0.3) {
                self.arrowImgV.transform = CGAffineTransform(rotationAngle: 2*CGFloat.pi)
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


