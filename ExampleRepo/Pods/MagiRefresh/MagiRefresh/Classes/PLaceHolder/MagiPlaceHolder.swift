//
//  MagiPlaceHolderView.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/8/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

// 每个子控件之间的间距
let kSubViewMargin: CGFloat = 20.0
// 描述字体
let kTitleLabFont = UIFont.systemFont(ofSize: 16)
// 详细描述字体
let kDetailLabFont = UIFont.systemFont(ofSize: 14)
// 按钮字体大小
let kActionBtnFont = UIFont.systemFont(ofSize: 14)
// 按钮高度
let kActionBtnHeight: CGFloat = 40.0
// 按钮宽度
let kActionBtnWidth: CGFloat  = 100.0
// 水平方向内边距
let kActionBtnHorizontalMargin = 30.0
// 黑色
let kBlackColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
// 灰色
let kGrayColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)

public class MagiPlaceHolder: MagiBasePlaceHolder {

    // MARK: - 控件
    /// 图片
    fileprivate lazy var promptImageView: UIImageView = {
        let promptImageView = UIImageView()
        promptImageView.contentMode = .scaleAspectFit
        return promptImageView
    }()
    /// 标题
    fileprivate lazy var titleLabel: UILabel = {
        let titleL = UILabel()
        titleL.textAlignment = .center
        return titleL
    }()
    /// 详情
    fileprivate lazy var detailLabel: UILabel = {
        let detailL = UILabel()
        detailL.textAlignment = .center
        detailL.numberOfLines = 2
        return detailL
    }()
    /// 按钮
    fileprivate  lazy var actionButton: UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        return btn
    }()
    
    // MARK: - 属性
    fileprivate var contentMaxWidth: CGFloat = 0   // 最大宽度
    fileprivate var contentWidth: CGFloat = 0      // 内容物宽度
    fileprivate var contentHeight: CGFloat = 0     // 内容物高度
    fileprivate var subViweMargin: CGFloat = 0     // 间距
    /// 控件间的间距 default is 20.f
    public var subViewMargin: CGFloat = 20 {
        didSet {
            setupSubviews()
        }
    }
    /// 内容物-垂直方向偏移 (此属性与contentViewY 互斥，只有一个会有效)
    public var contentViewOffset: CGFloat = 0 {
        didSet {
            contentView.magi_centerY += contentViewOffset
        }
    }
    /// 内容物-Y坐标 (此属性与contentViewOffset 互斥，只有一个会有效)
    public var contentViewY: CGFloat = 0 {
        didSet {
            contentView.magi_top = contentViewY
        }
    }
    /// 图片可设置固定大小 (default=图片实际大小)
    public var imageSize: CGSize = CGSize.zero {
        didSet {
            setupSubviews()
        }
    }
    /// 标题字体, 大小default is 16.f
    public var titleLabFont: UIFont = kTitleLabFont {
        didSet {
            setupSubviews()
        }
    }
    /// 标题文字颜色
    public var titleLabTextColor: UIColor = kBlackColor {
        didSet {
            titleLabel.textColor = titleLabTextColor
        }
    }
    
    /// 详细描述字体，大小default is 14.f
    public var detailLabFont: UIFont = kDetailLabFont {
        didSet {
            detailLabel.font = detailLabFont
            setupSubviews()
        }
    }
    /// 详细描述文字颜色
    public var detailLabTextColor: UIColor = kGrayColor {
        didSet {
            detailLabel.textColor = detailLabTextColor
        }
    }
    /// 详细描述最大行数， default is 2
    public var detailLabMaxLines: NSInteger = 2 {
        didSet {
            setupSubviews()
        }
    }
    /// 按钮字体, 大小default is 14.f
    public var actionBtnFont: UIFont = kActionBtnFont {
        didSet {
            actionButton.titleLabel?.font = actionBtnFont
            setupSubviews()
        }
    }
    
    /// 按钮的高度, default is 40.f
    public var actionBtnHeight: CGFloat = CGFloat(kActionBtnHeight) {
        didSet {
            setupSubviews()
        }
    }
    /// 按钮的宽度, default is 100.f
    public var actionBtnWidth: CGFloat = CGFloat(kActionBtnWidth) {
        didSet {
            setupSubviews()
        }
    }
    /// 水平方向内边距, default is 30.f
    public var actionBtnHorizontalMargin: CGFloat = CGFloat(kActionBtnHorizontalMargin) {
        didSet {
            setupSubviews()
        }
    }
    /// 按钮的圆角大小, default is 5.f
    public var actionBtnCornerRadius: CGFloat = 5.0 {
        didSet {
            actionButton.layer.cornerRadius = actionBtnCornerRadius
        }
    }
    /// 按钮边框border的宽度, default is 0
    public var actionBtnBorderWidth: CGFloat = 0.0 {
        didSet {
            actionButton.layer.borderWidth = actionBtnBorderWidth
        }
    }
    /// 按钮边框颜色
    public var actionBtnBorderColor: UIColor = .clear {
        didSet {
            actionButton.layer.borderColor = actionBtnBorderColor.cgColor
        }
    }
    /// 按钮文字颜色
    public var actionBtnTitleColor: UIColor = kBlackColor {
        didSet {
            actionButton.setTitleColor(actionBtnTitleColor, for: .normal)
        }
    }
    
    /// 按钮背景颜色
    public var actionBtnBackGroundColor: UIColor = .clear {
        didSet {
            actionButton.backgroundColor = actionBtnBackGroundColor
        }
    }
    
    // MARK: - 系统方法
    override func prepare() {
        super.prepare()
        // 默认值，用来判断是否设置过content的Y值
        magi_centerY = 1000
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        // 最大宽度（ScrollView 的宽 - 30）
        contentMaxWidth = magi_width - CGFloat(kActionBtnHorizontalMargin)
        contentWidth = 0
        contentHeight = 0
        subViweMargin = self.subViewMargin
        if customView == nil {
            /// 占位图
            if let imgStr = self.imageName  {
                let image = UIImage(named: imgStr)
                if image != nil {
                    setupPromptImageView(img: image!)
                }
                else {
                    promptImageView.removeFromSuperview()
                    if contentHeight == 0 {
                        contentHeight = center.y
                    }
                }
            }
            /// 标题
            if let titleString = self.title,
                titleString.count > 0 {
                setupTitleLabel(titleStr: titleString)
            }
            else {
                titleLabel.removeFromSuperview()
                if contentHeight == 0 {
                    contentHeight = center.y
                }
            }
            /// 详细描述
            if let detailString = self.detailTitle,
                detailString.count > 0 {
                setupDetailLabel(detailStr: detailString)
            }
            else {
                detailLabel.removeFromSuperview()
                if contentHeight == 0 {
                    contentHeight = center.y
                }
            }
            /// 按钮
            if let btnTitleString = self.refreshBtnTitle,
                btnTitleString.count > 0 {
                if target != nil {
                    setupActionBtn(
                        btnTitle: btnTitleString,
                        target: target,
                        action: selector,
                        btnClickBlock: nil)
                }
                else if (refreshClosure != nil) {
                    setupActionBtn(
                        btnTitle: btnTitleString,
                        target: nil,
                        action: nil,
                        btnClickBlock: refreshClosure)
                }
                else {
                    actionButton.removeFromSuperview()
                }
            }
            else {
                actionButton.removeFromSuperview()
            }
        }
        
        setSubViewFrame()
    }
    
    func setSubViewFrame() {
        /// 设置contentView
        self.contentView.frame = bounds
        
        if customView != nil {
            customView?.frame = bounds
            contentView.addSubview(customView!)
        }
        else {
            if promptImageView.image != nil {
                contentView.addSubview(promptImageView)
            }
            contentView.addSubview(titleLabel)
            contentView.addSubview(detailLabel)
            contentView.addSubview(actionButton)
        }
        
        /// 有无偏移
        if contentViewOffset > 0 {
            contentView.magi_centerY += contentViewOffset
        }
        
        /// 有无设置Y坐标
        if contentViewY < 1000 {
            contentView.magi_top = contentViewY
        }
    }
    
}

// MARK: - Setup View
extension MagiPlaceHolder {
    /// ImageView
    fileprivate func setupPromptImageView(img: UIImage) {
        self.promptImageView.image = img
        
        var imgViewWidth = img.size.width
        var imgViewHeight = img.size.height
        if imageSize.width > 0 && imageSize.height > 0{
            if imgViewWidth > imgViewHeight {
                imgViewHeight = (imgViewHeight/imgViewWidth)*imageSize.width
                imgViewWidth = imageSize.width
            }
                
            else {
                imgViewWidth = (imgViewWidth / imgViewHeight)*imageSize.height
                imgViewHeight = imageSize.height
            }
        }
        
        promptImageView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: imgViewWidth,
                                       height: imgViewHeight)
        promptImageView.center = CGPoint(x: magi_centerX,
                                         y: magi_centerY-imgViewHeight*0.5)
        contentWidth = promptImageView.magi_width
        contentHeight = promptImageView.magi_maxY
        
    }
    
    // titleLabel
    fileprivate func setupTitleLabel(titleStr: String) {
        let fontSize: CGFloat = titleLabFont.pointSize
        let width: CGFloat = getTextWidth(
            text: titleStr,
            size: CGSize(width: contentMaxWidth,
                         height: fontSize),
            font: self.titleLabFont).width
        titleLabel.frame = CGRect(x: 0,
                                  y: contentHeight+subViweMargin,
                                  width: width,
                                  height: fontSize)
        titleLabel.center = CGPoint(x: magi_centerX,
                                    y: titleLabel.magi_centerY)
        titleLabel.font = titleLabFont
        titleLabel.textColor = titleLabTextColor
        titleLabel.text = self.title
        contentWidth = (Float(width) > Float(contentWidth)) ? width : contentWidth
        contentHeight = titleLabel.magi_maxY
    }
    
    // DetailLabel
    fileprivate func setupDetailLabel(detailStr: String) {
        
        let size: CGSize = getTextWidth(
            text: detailStr,
            size: CGSize(width: contentMaxWidth,
                         height: 900),
            font: detailLabFont)
        var width = size.width
        if width < (contentMaxWidth) {
            width = (contentMaxWidth)
        }
        detailLabel.frame = CGRect(x: (contentMaxWidth)/2.0,
                                   y: contentHeight+subViweMargin,
                                   width: width,
                                   height: size.height+5)
        detailLabel.center = CGPoint(x: magi_centerX,
                                     y: detailLabel.magi_centerY)
        
        detailLabel.font = self.titleLabFont
        detailLabel.text = self.detailTitle
        detailLabel.textColor = detailLabTextColor
        contentWidth = (Float(width) > Float(contentWidth)) ? width : contentWidth
        contentHeight = detailLabel.magi_maxY
        
    }
    
    /// button
    fileprivate func setupActionBtn(btnTitle: String,
                        target:AnyObject?,
                        action: Selector?,
                        btnClickBlock: MagiTapClosure?) {
        
        let fontSize: CGFloat = actionBtnFont.pointSize
        var btnWidth: CGFloat = getTextWidth(
            text: btnTitle,
            size: CGSize(width: contentMaxWidth,
                         height: fontSize),
            font: actionBtnFont).width + actionBtnHorizontalMargin*2
        let btnHeight = actionBtnHeight
        if btnWidth < actionBtnWidth {
            btnWidth = actionBtnWidth
        }
        actionButton.frame = CGRect(x: 0,
                                    y: contentHeight+subViewMargin,
                                    width: btnWidth,
                                    height: btnHeight)
        actionButton.center = CGPoint(x: magi_centerX,
                                      y: actionButton.magi_centerY)
        
        actionButton.setTitle(btnTitle, for: .normal)
        actionButton.setTitleColor(actionBtnTitleColor, for: .normal)
        actionButton.titleLabel?.font = actionBtnFont
        actionButton.backgroundColor = actionBtnBackGroundColor
        
        actionButton.layer.borderWidth = actionBtnBorderWidth
        actionButton.layer.borderColor = actionBtnBorderColor.cgColor
        actionButton.layer.cornerRadius = actionBtnCornerRadius
        
        if action != nil {
            actionButton.addTarget(target!,
                                   action: action!,
                                   for: .touchUpInside)
            actionButton.addTarget(self,
                                   action: #selector(actionBtnClick(_:)),
                                   for: .touchUpInside)
            
        }
        else {
            actionButton.addTarget(self,
                                   action: #selector(actionBtnClick(_:)),
                                   for: .touchUpInside)
            
        }
    }
    
    fileprivate func getTextWidth(text: String, size: CGSize, font: UIFont) -> CGSize {
        let textSize: CGSize = ((text as NSString).boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [kCTFontAttributeName as NSAttributedString.Key: font],
            context: nil)).size
        
        return textSize
    }
    
    @objc
    fileprivate func actionBtnClick(_ sender: UIButton) {
        refreshClosure?()
    }
    
    
}
