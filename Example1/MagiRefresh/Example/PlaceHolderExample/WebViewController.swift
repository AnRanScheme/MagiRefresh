
//
//  WebViewController.swift
//  magiLoadingPlaceHolder
//
//  Created by 安然 on 2018/8/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import WebKit

// 适配iPhone X
let kNavBarHeight = 44
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
// TabBarHeight
let kTabBarHeight = kStatusBarHeight > 20 ? 83 : 49
// NavBarHeight
let kTopHeight =  Float(kNavBarHeight) + Float(kStatusBarHeight)

class WebViewController: UIViewController {
    
    fileprivate lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }()
    
    fileprivate lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.frame = CGRect(x: 0,
                                    y:CGFloat(kTopHeight) ,
                                    width: self.view.bounds.width,
                                    height: 5.0)
        progressView.isHidden = true
        progressView.trackTintColor = UIColor.clear
        progressView.progressTintColor = UIColor.blue
        
        return progressView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(progressView)
        loadingURL(urltring: "http://www.baidu.com/")
        //监听进度
        webView.addObserver(self,
                            forKeyPath: "estimatedProgress",
                            options: NSKeyValueObservingOptions.new,
                            context: nil)
        setupCustomPlaceHolderView()
    }
    
    // MARK: ----  observeValue ---
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if object as! NSObject == self.webView {
                print(webView.estimatedProgress)
                if webView.estimatedProgress > 0.2 {
                    progressView.setProgress(Float(webView.estimatedProgress), animated: true)
                }
            }
            if webView.estimatedProgress >= 1.0 {
                progressView.setProgress(0.99999, animated: true)
                UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.autoreverse, animations: {
                    self.progressView.isHidden = true
                    self.progressView.setProgress(0.0, animated: false)
                }, completion: nil)
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        print(self.debugDescription+"------销毁了")
    }
    
    //自定义空数据界面显示
    fileprivate func setupCustomPlaceHolderView() {
        
        let placeHolder = MagiPlaceHolder.createPlaceHolderWithClosure(
            imageName: "network_error",
            title: "网络不好，点击重新加载",
            detailTitle: "请检查网络连接或稍后再试",
            refreshBtnTitle: "重新加载",
            refreshClosure: { [weak self] in
                print("点击刷新")
                self?.loadingURL(urltring: "http://www.baidu.com/")
        })
        placeHolder.contentViewY = -100
        placeHolder.actionBtnBackGroundColor = .lightGray
        webView.scrollView.magiRefresh.placeHolder = placeHolder
        webView.scrollView.magiRefresh.placeHolder?.tapBlankViewClosure = { [weak self] in
            guard let `self` = self else {return}
            self.loadingURL(urltring: "http://news.baidu.com/")
        }
        
    }
    
    func loadingURL(urltring: String) {
        let urlstr = URL(string: urltring)
        webView.load(URLRequest(url: urlstr!))
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.setProgress(0.2, animated: true)
        print("_____开始加载_____")
    }
    
    //完成加载
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("_____完成加载_____")
        webView.scrollView.magiRefresh.hidePlaceHolder()
    }
    
    //加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("_____加载失败_____")
        webView.scrollView.magiRefresh.showPlaceHolder()
        progressView.isHidden = true
    }
    
}

