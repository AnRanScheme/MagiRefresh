//
//  MagiRefreshFooterConrol.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/3.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public class MagiRefreshFooterConrol: MagiRefreshBaseConrol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        magi_top = scrollView?.contentHeight ?? 0
    }
    
    override public func setScrollViewToRefreshLocation() {
        super.setScrollViewToRefreshLocation()
        DispatchQueue.main.async {
            if let realContentInset = self.scrollView?.realContentInset {
                self.presetContentInsets = realContentInset
            }
            UIView.setAnimate(animations: {
                 self.setAnimated()
            }, completion: { (isFinished) in
                 self.setCompletion()
            })
        }
    }
    
    override public func setScrollViewToOriginalLocation() {
        super.setScrollViewToOriginalLocation()
        UIView.setAnimate(animations: {
            self.isAnimating = true
            self.scrollView?.insetBottom = self.presetContentInsets.bottom
        }, completion: { (isFinished) in
            self.isAnimating = false
            self.isTriggeredRefreshByUser = false
            self.refreshStatus = .none
        })
    }
    
    override public func privateContentOffsetOfScrollViewDidChange(_ contentOffset: CGPoint) {
        super.privateContentOffsetOfScrollViewDidChange(contentOffset)
        
        if refreshStatus != .refreshing {
            if isTriggeredRefreshByUser {return}
            presetContentInsets = scrollView?.realContentInset ?? UIEdgeInsets.zero
            
            var originY: CGFloat = 0.0
            var maxY: CGFloat = 0.0
            var minY: CGFloat = 0.0
            var contentOffsetYInBottom: CGFloat = 0.0
            
            if (scrollView?.contentHeight ?? 0.0) + presetContentInsets.top <= (scrollView?.magi_height ?? 0.0) {
                maxY = stretchOffsetYAxisThreshold*magi_height
                minY = 0
                originY = contentOffset.y+presetContentInsets.top
                
                if refreshStatus == .scrolling {
                    let progress = abs(originY) / magi_height
                    if progress <= stretchOffsetYAxisThreshold {
                        self.progress = progress
                    }
                }
            } else {
                maxY = MagiRefreshFooterConrol.OffsetOfTriggeringFootRefreshControlToRefresh(self)
                minY = MagiRefreshFooterConrol.OffsetOfFootRefreshControlToRestore(self)
                originY = contentOffset.y
                contentOffsetYInBottom = (scrollView?.contentHeight ?? 0.0) - (scrollView?.magi_height ?? 0.0)
                /////////////////////////
                ///uncontinuous callback
                /////////////////////////
                let uncontinuousOpt: CGFloat = 50.0
                if originY < minY - uncontinuousOpt {return}
                
                if refreshStatus == .scrolling {
                    let progress = abs((originY - contentOffsetYInBottom - presetContentInsets.bottom))/magi_height
                    if progress <= stretchOffsetYAxisThreshold {
                        self.progress = progress
                    }
                }
                
                if isAutoRefreshOnFoot {
                    if (scrollView?.isDragging ?? false) &&
                        originY > MagiRefreshFooterConrol.OffsetOfTriggeringFootRefreshControlToAutoRefresh(self) &&
                        !isAnimating &&
                        refreshStatus == .none &&
                        !isShouldNoLongerRefresh {
                        beginRefreshing()
                    }
                    return
                }
            }
            
            if !(scrollView?.isDragging ?? false)
                && refreshStatus == .ready {
                isTriggeredRefreshByUser = false
                refreshStatus = .refreshing
                setScrollViewToRefreshLocation()
            }
            else if originY <= minY && !isAnimating {
                refreshStatus = .none
            }
            else if (scrollView?.isDragging ?? false)
                && originY >= minY
                && originY <= maxY
                && refreshStatus != .scrolling {
                refreshStatus = .scrolling
            }
            else if (scrollView?.isDragging ?? false)
                && originY > maxY
                && !isAnimating
                && refreshStatus != .ready
                && !isShouldNoLongerRefresh {
                refreshStatus = .ready
            }
        }
    }
}

extension MagiRefreshFooterConrol {
    
    /// 静态发发内部是获取不到self的对象的
    static func RefreshingPoint(_ control: MagiRefreshFooterConrol)->CGPoint {
        guard let sc = control.scrollView else { return CGPoint.zero }
        return CGPoint(x: sc.magi_left,
                       y: MagiRefreshFooterConrol.OffsetOfTriggeringFootRefreshControlToRefresh(control))
    }
    
    static func OffsetOfTriggeringFootRefreshControlToRefresh(_ control: MagiRefreshBaseConrol)->CGFloat {
        guard let sc = control.scrollView else { return 0 }
        let y = sc.contentHeight - sc.magi_height
            + control.stretchOffsetYAxisThreshold*control.magi_height
            + control.presetContentInsets.bottom
        return y
    }
    
    static func OffsetOfTriggeringFootRefreshControlToAutoRefresh(_ control: MagiRefreshBaseConrol)->CGFloat {
        guard let sc = control.scrollView else { return 0 }
        let y = sc.contentHeight - sc.magi_height + control.presetContentInsets.bottom
        return y
    }
    
    static func OffsetOfFootRefreshControlToRestore(_ control: MagiRefreshBaseConrol)->CGFloat {
        guard let sc = control.scrollView else { return 0 }
        let y = sc.contentHeight - sc.magi_height + control.presetContentInsets.bottom
        return y
    }
    
    fileprivate func setAnimated() {
        if isTriggeredRefreshByUser {
            refreshStatus = .scrolling
            if (scrollView?.contentHeight ?? 0.0) > (scrollView?.magi_height ?? 0.0) &&
                (scrollView?.offsetY ?? 0.0) >= MagiRefreshFooterConrol.OffsetOfTriggeringFootRefreshControlToRefresh(self) {
                scrollView?.setContentOffset(MagiRefreshFooterConrol.RefreshingPoint(self),
                                             animated: true)
                magiDidScrollWithProgress(progress: 0.5,
                                          max: stretchOffsetYAxisThreshold)
            }
        }
        scrollView?.insetBottom = presetContentInsets.bottom+magi_height
    }
    
    fileprivate func setCompletion() {
        if isTriggeredRefreshByUser {
            refreshStatus = .ready
            refreshStatus = .refreshing
            magiDidScrollWithProgress(progress: 1.0,
                                      max: stretchOffsetYAxisThreshold)
        }
        refreshClosure?()
    }

    
}
