
//
//  MagiRefreshHeaderConrol.swift
//  MagiRefresh
//
//  Created by anran on 2018/9/3.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

public class MagiRefreshHeaderConrol: MagiRefreshBaseConrol {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        magi_top = -magi_height
    }
    
    override public func setScrollViewToRefreshLocation() {
        super.setScrollViewToRefreshLocation()
        DispatchQueue.main.async {
            if let realContentInset = self.scrollView?.realContentInset {
                self.presetContentInsets = realContentInset
            }
            UIView.setAnimate(animations: {
               self.setAnimated()
            }) { (isFinished) in
              self.setCompletion()
            }
        }
    }
    
    override public func setScrollViewToOriginalLocation() {
        super.setScrollViewToOriginalLocation()
        UIView.setAnimate(animations: {
            self.isAnimating = true
            self.scrollView?.insetTop = self.presetContentInsets.top
        }) { (isFinished) in
            self.isAnimating = false
            self.isTriggeredRefreshByUser = false
            self.refreshStatus = .none
        }
    }
    
    override public func privateContentOffsetOfScrollViewDidChange(_ contentOffset: CGPoint) {
        super.privateContentOffsetOfScrollViewDidChange(contentOffset)
        
        let maxY = MagiRefreshHeaderConrol.MaxYForTriggeringRefresh(self)
        let minY = MagiRefreshHeaderConrol.MinYForNone(self)
        let originY = contentOffset.y
        
        if refreshStatus == .refreshing {
            /////////////////////////////////////////////////////
            //fix hover problem of sectionHeader
            /////////////////////////////////////////////////////
            if originY < 0 && (-originY >= presetContentInsets.top) {
                let threshold: CGFloat = presetContentInsets.top + magi_height
                if (-originY > threshold) {
                   scrollView?.insetTop = threshold
                }
                else{
                    scrollView?.insetTop = -originY
                }
            }
            else{
                if scrollView?.insetTop ?? 0.0 != presetContentInsets.top {
                    scrollView?.insetTop = presetContentInsets.top
                }
            }
        }
        else{
            if isTriggeredRefreshByUser { return }
            
            presetContentInsets = scrollView?.realContentInset ?? UIEdgeInsets.zero
            
            if refreshStatus == .scrolling {
                let progress: CGFloat = (abs(originY) - presetContentInsets.top)/magi_height
                if progress <= stretchOffsetYAxisThreshold {
                    self.progress = progress
                }
            }
            
            if !(scrollView?.isDragging ?? false) && refreshStatus == .ready {
                isTriggeredRefreshByUser = false
                refreshStatus = .refreshing
                setScrollViewToRefreshLocation()
            }
            else if originY >= minY && !isAnimating{
                refreshStatus = .none
            }
            else if (scrollView?.isDragging ?? false)  && originY <= minY
                && originY >= maxY && refreshStatus != .scrolling {
                refreshStatus = .scrolling
            }
            else if (scrollView?.isDragging ?? false)  && originY < maxY && !isAnimating
                && refreshStatus != .ready && !isShouldNoLongerRefresh{
                refreshStatus = .ready
            }
        }
    }
}

extension MagiRefreshHeaderConrol {
    
    static func RefreshingPoint(_ conrol :MagiRefreshBaseConrol)->CGPoint {
        let x = conrol.scrollView?.magi_left ?? 0
        let y = -conrol.presetContentInsets.top-conrol.magi_height
        
        return CGPoint(x: x, y: y)
    }
    
    static func MaxYForTriggeringRefresh(_ conrol :MagiRefreshBaseConrol)->CGFloat {
        let y = -conrol.presetContentInsets.top+conrol.stretchOffsetYAxisThreshold*conrol.magi_top
        
        return y
    }
    
    static func MinYForNone(_ conrol :MagiRefreshBaseConrol)->CGFloat {
        
        return -conrol.presetContentInsets.top
    }
    
    fileprivate func setAnimated() {
        if isTriggeredRefreshByUser {
            refreshStatus = .scrolling
            /*
             ///////////////////////////////////////////////////////////////////////////////////////////
             In general, we use UITableView, especially UITableView need to use the drop-down refresh,
             we rarely set SectionHeader. Unfortunately, if you use SectionHeader and integrate with
             UIRefreshControl or other third-party libraries, the refresh effect will be very ugly.
             
             This code has two effects:
             1.  when using SectionHeader refresh effect is still very natural.
             2.  when your scrollView using preloading technology, only in the right place,
             such as pull down a pixel you can see the refresh control case, will show the
             refresh effect. If the pull-down distance exceeds the height of the refresh control,
             then the refresh control has long been unable to appear on the screen,
             indicating that the top of the contentOffset office there is a long distance,
             this time, even if you call the beginRefreshing method, ScrollView position and effect
             are Will not be affected, so the deal is very friendly in the data preloading technology.
             ///////////////////////////////////////////////////////////////////////////////////////////
             */
            let min = -presetContentInsets.top
            let max = -(presetContentInsets.top-magi_height)
            if (scrollView?.offsetY ?? 0.0) >= min && (scrollView?.offsetY ?? 0.0) <= max {
                scrollView?.setContentOffset(MagiRefreshHeaderConrol.RefreshingPoint(self),
                                             animated: false)
                magiRefreshControlDidScrollWithProgress(progress: 0.5, max: stretchOffsetYAxisThreshold)
                scrollView?.insetTop = magi_height + presetContentInsets.top
            }
        }else{
            scrollView?.insetTop = magi_height + presetContentInsets.top
        }
    }
    
    fileprivate func setCompletion() {
        if isTriggeredRefreshByUser {
            refreshStatus = .ready
            refreshStatus = .refreshing
            magiRefreshControlDidScrollWithProgress(progress: 1.0,
                                      max: stretchOffsetYAxisThreshold)
        }
        refreshClosure?()
    }
 
}
