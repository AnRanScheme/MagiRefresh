//
//  PlaceHolder.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/7/30.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit


public class MagiBasePlaceHolder: UIView {
    
    public typealias MagiTapClosure = ()->()
    var tapBlankViewClosure: MagiTapClosure?
    var refreshClosure: MagiTapClosure?
    var contentView: UIView = UIView()
    /// 注意使用 target 这种方式要使用weak否则会循环引用
    weak var target: AnyObject?
    var selector: Selector?
    var customView: UIView?
    var isAutoShowPlaceHolder: Bool = true
    // 图片名字
    var imageName: String? {
        didSet {
            setupSubviews()
        }
    }
    // 标题
    var title: String? {
        didSet {
            setupSubviews()
        }
    }
    // 详情
    var detailTitle: String?
    {
        didSet {
            setupSubviews()
        }
    }
    // 按钮标题
    var refreshBtnTitle: String?
    {
        didSet {
            setupSubviews()
        }
    }
    
    // MARK: - 初始化方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = UIColor.white
    }
    
    /// 由子类实现
    func setupSubviews() {
        print("由子类实现")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let view = self.superview else { return }
        if view.isKind(
            of: UIScrollView.self) {
            self.frame = CGRect(x: 0,
                                y: 0,
                                width: view.magi_width,
                                height: view.magi_height)
            
        }
        setupSubviews()
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //不是UIScrollView，不做操作
        if !(newSuperview is UIScrollView) {
            return
        }
        if let newView = newSuperview {
            self.magi_width = newView.magi_width
            self.magi_height = newView.magi_height
        }
    }
    
    
}

extension MagiBasePlaceHolder {

    fileprivate func creatPlaceHolder(
        imageName: String,
        title: String,
        detailTitle: String,
        refreshBtnTitle: String,
        target: AnyObject,
        action: Selector) {
        self.imageName = imageName
        self.title = title
        self.detailTitle = detailTitle
        self.refreshBtnTitle = refreshBtnTitle
        self.target = target
        self.selector = action
        contentView = UIView(frame: CGRect.zero)
        addSubview(contentView)
        let tap = UITapGestureRecognizer(
            target: self,
            action:#selector(tapContentView(_:)))
        contentView.addGestureRecognizer(tap)
    }
    
    fileprivate func creatPlaceHolder(
        imageName: String,
        title: String,
        detailTitle: String,
        refreshBtnTitle: String?,
        refreshClosure: @escaping MagiTapClosure) {
        self.imageName = imageName
        self.title = title
        self.detailTitle = detailTitle
        self.refreshBtnTitle = refreshBtnTitle
        self.refreshClosure = refreshClosure
        addSubview(contentView)
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(tapContentView(_:)))
        contentView.addGestureRecognizer(tap)
    }
    
    fileprivate func creatPlaceHolder(
        imageName: String,
        title: String,
        detailTitle: String) {
        self.imageName = imageName
        self.title = title
        self.detailTitle = detailTitle
        
        addSubview(contentView)
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(tapContentView(_:)))
        contentView.addGestureRecognizer(tap)
    }
    
    fileprivate func createCustomPlaceHolder(_ customView: UIView) {
        addSubview(contentView)
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(tapContentView(_:)))
        contentView.addGestureRecognizer(tap)
        self.customView = customView
    }
    
    @objc
    fileprivate func tapContentView(_ sender: UITapGestureRecognizer) {
        tapBlankViewClosure?()
    }
    
}

// MARK: - 类方法
extension MagiBasePlaceHolder {
    
    // target/action 响应
    public class func createPlaceHolderWithAction(
        imageName: String,
        title: String,
        detailTitle: String,
        refreshBtnTitle: String,
        target: AnyObject,
        action: Selector) -> MagiPlaceHolder {
        
        let placeHolder: MagiPlaceHolder = MagiPlaceHolder(
            frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        placeHolder.creatPlaceHolder(
            imageName: imageName,
            title: title,
            detailTitle: detailTitle,
            refreshBtnTitle: refreshBtnTitle,
            target: target,
            action: action)
        
        return placeHolder
    }
    
    // Closure 回调方法
    public class func createPlaceHolderWithClosure(
        imageName: String,
        title: String,
        detailTitle: String,
        refreshBtnTitle: String,
        refreshClosure: @escaping MagiTapClosure) -> MagiPlaceHolder {
        
        let placeHolder: MagiPlaceHolder = MagiPlaceHolder(
            frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        placeHolder.creatPlaceHolder(
            imageName: imageName,
            title: title,
            detailTitle: detailTitle,
            refreshBtnTitle: refreshBtnTitle,
            refreshClosure: refreshClosure)
        
        return placeHolder
    }
    
    /// 自定义显示界面
    public class func createCustomPlaceHolder(_ customView: UIView) -> MagiPlaceHolder {
        let placeHolder: MagiPlaceHolder = MagiPlaceHolder(
            frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        placeHolder.createCustomPlaceHolder(customView)
        
        return placeHolder
    }
    
    func refreshView(_ completion: MagiTapClosure?) {
        self.refreshClosure = completion
    }

    func tapBlankView(_ completion: MagiTapClosure?) {
        self.tapBlankViewClosure = completion
    }
    
}

