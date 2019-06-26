//
//  webViewViewController.swift
//  pamfti
//
//  Created by David A on 11/24/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import WebKit
class webViewViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var myProgressView: UIProgressView!
    var theBool:Bool!
    var myTimer:Timer!
    
    
    var passedURL:String = ""
    var passedTopic:String = ""
    var passedWebsiteTopic:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
let urll = URL(string: passedURL)
        let request = URLRequest(url: urll!)
        webView.load(request)
        // Do any additional setup after loading the view.
        funcToCallWhenStartLoadingYourWebview()
        
        self.title = passedWebsiteTopic
       // self.navigationController?.navigationBar.topItem?.title = passedTopic

        webView.navigationDelegate = self

    }
    /*
    @objc func timerCallback() {
        if self.theBool {
            if self.myProgressView.progress >= 1 {
                self.myProgressView.isHidden = true
                self.myTimer.invalidate()
            } else {
                self.myProgressView.progress += 0.1
            }
        } else {
            self.myProgressView.progress += 0.05
            if self.myProgressView.progress >= 0.95 {
                self.myProgressView.progress = 0.95
            }
        }
    }
    
    func funcToCallWhenStartLoadingYourWebview() {
        self.myProgressView.progress = 0.0
        self.theBool = false
        self.myTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    func funcToCallCalledWhenUIWebViewFinishesLoading() {
        self.theBool = true
    }
    */
    
    
    @objc func timerCallback() {
        
        
        self.myProgressView.progress = Float(webView.estimatedProgress)

     
    }
    
 
    
    func funcToCallWhenStartLoadingYourWebview() {
        self.myProgressView.progress = 0.0
        self.theBool = false
        self.myTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    func funcToCallCalledWhenUIWebViewFinishesLoading() {
        self.theBool = true
    }
    
    
    func myProgressView(_: WKWebView, didFinish _: WKNavigation!) {
     self.myProgressView.isHidden = true
    }
    
}
extension webViewViewController: WKNavigationDelegate {
  /*  func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        UIView.transition(with: progressView,
                          duration: 0.33,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.progressView.isHidden = false
        },
                          completion: nil)
    }
    
    */
    
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
      myProgressView.isHidden = true
       // self.title = "done"

    }
}
