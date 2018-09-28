//
//  MagiRefreshBaseConrol.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/3.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public typealias MagiRefreshClosure = ()->()
let kMagiRefreshHeight: CGFloat = 45.0
let kMagiStretchOffsetYAxisThreshold: CGFloat = 1
let kMagiContentOffset = "contentOffset"
let kMagiContentSize = "contentSize"

public class MagiRefreshBaseConrol: UIView {
    
    /// The UIScrollView to which the control is added, developers may not set
    fileprivate(set) var scrollView: UIScrollView?
    /// Whether it is refreshing
    fileprivate(set) var isRefresh: Bool {
        set {
            
        }
        get {
            return refreshStatus == .refreshing
        }
    }
    /// Judge whether the animation is executed when the refresh is over
    public var isAnimating: Bool = false
    /// Control refresh status, developers may not set
    public var refreshStatus: MagiRefreshStatus = .none {
        willSet {
            if refreshStatus == newValue { return }
            switch newValue {
            case .none:
                UIView.setAnimate(animations: {
                    self.alpha = 0.0
                }, completion: nil)
            case .scrolling:
                /// when system adjust contentOffset atuomatically,
                /// will trigger refresh control's state changed.
                if !isTriggeredRefreshByUser && !(scrollView?.isTracking ?? false) {
                    return
                }
                UIView.setAnimate(animations: {
                    self.alpha = 1.0
                }, completion: nil)
            case .ready:
                /// because of scrollView contentOffset is not continuous change.
                /// need to manually adjust progress
                if progress < stretchOffsetYAxisThreshold {
                    magiRefreshControlDidScrollWithProgress(progress: stretchOffsetYAxisThreshold,
                                                            max: stretchOffsetYAxisThreshold)
                }
                UIView.setAnimate(animations: {
                    self.alpha = 1.0
                }, completion: nil)
            case .refreshing:
                break
            case .willEndRefresh:
                UIView.setAnimate(animations: {
                    self.alpha = 1.0
                }, completion: nil)
            }
            magiRefreshControlStateDidChange(newValue)
        }
    }
    /// When the system automatically or manually adjust contentInset,
    /// this value will be saved
    public var presetContentInsets: UIEdgeInsets = UIEdgeInsets.zero
    /// This value is set to TRUE if the beginRefresh method is called automatically
    /// developers may not set
    public var isTriggeredRefreshByUser: Bool = false
    /// the current position offset of the control as a percentage
    /// of the offset that triggered the refresh
    public var progress: CGFloat = 0.0 {
        willSet {
            if progress == newValue { return }
            magiRefreshControlDidScrollWithProgress(progress: newValue,
                                                    max: kMagiStretchOffsetYAxisThreshold)
        }
    }
    ///  Closure will be called when refreshing
    public var refreshClosure: MagiRefreshClosure?
    ///  selector will be called when refreshing aim target
    public weak var target: AnyObject?
    ///  selector will be called when refreshing
    public var selector: Selector?
    /// The threshold for trigger refresh default 1.0 must be set to not less than 1.0,
    /// default value is 1.3, developers can set the value
    public var stretchOffsetYAxisThreshold: CGFloat = 1.3 {
        willSet {
            if !(stretchOffsetYAxisThreshold != newValue && newValue > 1.0) {
                return
            }
        }
    }
    /// fill colors for points, lines, and faces that appear in this control.
    public var themeColor: UIColor = UIColor.blue {
        didSet {
            alertLabel.textColor = themeColor
        }
    }
    /// The background color of the layer that executes the animation
    public var animatedBackgroundColor: UIColor = UIColor.white
    /// if called method "endRefreshingAndNoLongerRefreshingWithAlertText:" to end refresh,
    /// shouldNoLongerRefresh will set TRUE.
    public var isShouldNoLongerRefresh: Bool = false
    
    /**
     scrollview trigger refresh automatically that don't need to scroll to bottom.
     default is YES;
     
     ATTENTION:!!!
     
     if (no data) {
     tableView.magiRefresh.footer.endRefreshingAndNoLongerRefreshingWithAlertText("no more")
     } else {
     tableView.magiRefresh.footer.endRefreshingWithAlertText("Did load successfully",completion:nil)
     }
     */
    public var isAutoRefreshOnFoot: Bool = true
    
    fileprivate var isObservering: Bool = false
    
    public lazy var alertLabel: MagiAlertLabel = {
        let alertLabel = MagiAlertLabel()
        alertLabel.textAlignment = .center
        alertLabel.font =  UIFont(name: "Helvetica", size: 15)
        alertLabel.textColor = themeColor
        alertLabel.alpha = 0.0
        alertLabel.backgroundColor = UIColor.white
        
        return alertLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let height = magi_height < 45.0
            ? kMagiRefreshHeight
            : magi_height
        frame = CGRect(x: 0, y: 0,
                       width: scrollView?.magi_width ?? 0.0,
                       height: height)
        alertLabel.frame = self.bounds
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        // super.willMove(toSuperview: newSuperview)
        let options = NSKeyValueObservingOptions.new.union(NSKeyValueObservingOptions.old)
        if let superview = superview,
            newSuperview == nil {
            if isObservering {
                superview.removeObserver(self, forKeyPath: kMagiContentOffset)
                superview.removeObserver(self, forKeyPath: kMagiContentSize)
                isObservering = false
            }
        }
        
        else if superview == nil, newSuperview != nil {
            if let scrollView = newSuperview as? UIScrollView {
                if !isObservering {
                    self.scrollView = scrollView
                    /// sometimes, this method called before `layoutSubviews`,
                    /// such as UICollectionViewController
                    layoutIfNeeded()
                    presetContentInsets = scrollView.realContentInset
                    scrollView.addObserver(self,
                                            forKeyPath: kMagiContentOffset,
                                            options: options,
                                            context: nil)
                    scrollView.addObserver(self,
                                            forKeyPath: kMagiContentSize,
                                            options: options,
                                            context: nil)
                    isObservering = true
                }
            }
        }

    }
    
    
    override public func observeValue(forKeyPath keyPath: String?,
                      of object: Any?,
                      change: [NSKeyValueChangeKey : Any]?,
                      context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case kMagiContentOffset:
            ///  If you disable the control's refresh feature, set the control to hidden
            if isHidden || isShouldNoLongerRefresh {
                return
            }
            /// If you quickly scroll scrollview in an instant, contentoffset changes are not continuous
            if let point = change?[NSKeyValueChangeKey.newKey] as? CGPoint {
                privateContentOffsetOfScrollViewDidChange(point)
            }
            
        case kMagiContentSize:
            layoutSubviews()
        default:
            break
        }
    }

    // MARK: - Function
    
    ///  Set the color of the prompt text after the refresh is completed.
    ///
    /// - Parameter alertTextColor: alertTextColor color
    public func setAlertTextColor(_ alertTextColor: UIColor) {
        alertLabel.textColor = alertTextColor
    }
    // MARK: - (需要被子类重写) Subclasses override this method
    public func setupProperties() {
        backgroundColor = UIColor.clear
        alpha = 0.0
        addSubview(alertLabel)
        isAutoRefreshOnFoot = false
        refreshStatus = .none
        stretchOffsetYAxisThreshold = kMagiStretchOffsetYAxisThreshold
        isShouldNoLongerRefresh = false
        isRefresh = false
        if frame.equalTo(CGRect.zero) {
            frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        }
    }
    // MARK: - (需要被子类重写) Subclasses override this method
    public func privateContentOffsetOfScrollViewDidChange(_ contentOffset: CGPoint) {
        
    }
    // MARK: - (需要被子类重写) Subclasses override this method
    public func setScrollViewToRefreshLocation() {
        isAnimating = true
    }
    // MARK: - (需要被子类重写) Subclasses override this method
    public func setScrollViewToOriginalLocation() {
        
    }
    
    // MARK: - Public Function
    // MARK: - (需要被子类重写) Subclasses override this method
    public func beginRefreshing() {
        if refreshStatus != .none || isHidden || isTriggeredRefreshByUser {
            return
        }
        if isShouldNoLongerRefresh {
            alertLabel.isHidden = true
        }
        isShouldNoLongerRefresh = false
        isTriggeredRefreshByUser = true
        setScrollViewToRefreshLocation()
    }
    // MARK: - (需要被子类重写) Subclasses override this method
    public func endRefreshing() {
        endRefreshingWithAlertText("", completion: nil)
    }
    // MARK: - (需要被子类重写) Subclasses override this method
    /// When this method is called to end the refresh, there will be a 1.5 second
    /// animated display of "text". Please note that the length of text, please
    /// try to be brief, otherwise it will be cut off.
    ///
    /// - Parameters:
    ///   - text: text default is "", and no animation.
    ///   - completion: completion when text is hidden, this block will be called.
    public func endRefreshingWithAlertText(_ text: String = "", completion: (()->())?) {
        if (!isRefresh && !isAnimating) || isHidden {
            return
        }
        if text != "" {
            bringSubviewToFront(alertLabel)
            alertLabel.text = text
            alertLabel.startAnimating()
            
            let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * 1.5 )) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime) {
                self.alertLabel.stopAnimating()
                self._endRefresh()
                completion?()
            }
            
        }
        else {
            _endRefresh()
        }
        
    }
    // MARK: - (需要被子类重写) Subclasses override this method
    /// Using this method means you clearly understand that refreshing
    /// is meaningless and refreshing will be disabled.
    ///
    /// - Parameter text: text If the user continues to drag, it will display the “text”, and will not trigger refresh.
    public func endRefreshingAndNoLongerRefreshingWithAlertText(_ text: String) {
        if (!isRefresh && !isAnimating) || isHidden {
            return
        }
        if isShouldNoLongerRefresh {
            return
        }
        isShouldNoLongerRefresh = true
        if alertLabel.alpha == 0.0 {
            UIView.animate(withDuration: 0.3) {
                self.alertLabel.alpha = 1.0
            }
        }
        bringSubviewToFront(alertLabel)
        alertLabel.text = text
        if text != "" {
            let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * 1.5 )) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime) {
                self._endRefresh()
            }
        }
        else {
            _endRefresh()
        }
    }
    
    /// After you call ‘endRefreshingAndNoLongerRefreshingWithAlertText’,
    /// you need to resume refresh available
    public func resumeRefreshAvailable() {
        isShouldNoLongerRefresh = false
        alertLabel.alpha = 0.0
    }
    
    fileprivate func _endRefresh() {
        refreshStatus = .scrolling
        magiRefreshControlStateDidChange(.willEndRefresh)
        setScrollViewToOriginalLocation()
    }
    
    public func magiRefreshStateDidChange(_ status: MagiRefreshStatus) {
        
    }
    
    public func magiDidScrollWithProgress(progress: CGFloat, max: CGFloat) {
        
    }
    
    public func magiRefreshingTarget(_ target: AnyObject, action: Selector) {
        self.target = target
        self.selector = action
    }
    
    public func magiRefreshingClosure(_ completion: @escaping MagiRefreshClosure) {
        self.refreshClosure = completion
    }
  
}

// MARK: - MagiRefreshControlProtocol
extension MagiRefreshBaseConrol: MagiRefreshControlProtocol {
    
    public func magiRefreshControlStateDidChange(_ status: MagiRefreshStatus) {
        magiRefreshStateDidChange(status)
    }
    
    public func magiRefreshControlDidScrollWithProgress(progress: CGFloat, max: CGFloat) {
        magiDidScrollWithProgress(progress: progress, max: max)
    }
    
}
