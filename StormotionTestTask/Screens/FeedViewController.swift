//
//  FeedViewController.swift
//  StormotionTestTask
//
//  Created by Eugene Ned on 24.01.2023.
//

import UIKit
import WebKit

class FeedViewController: UIViewController, WKNavigationDelegate {
    
    private var feedWebView: WKWebView!
    
    override func loadView() {
        feedWebView = WKWebView()
        feedWebView.navigationDelegate = self
        view = feedWebView
        feedWebView.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeWebView()
        configureWebView()
        
    }
    
    private func initializeWebView() {
        guard let filepath = Bundle.main.path(forResource: "script", ofType: "js"), let js = try? String(contentsOfFile: filepath) else { return }
        let userScript = WKUserScript.init(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        feedWebView.configuration.userContentController.addUserScript(userScript)
        feedWebView.configuration.userContentController.add(self, name: "jsMessenger")
    }
    
    private func configureWebView() {
        title = "Feed"
        guard let url = BaseURLs.feedURL else { return }
        feedWebView.load(URLRequest(url: url))
        feedWebView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        var insets = view.safeAreaInsets
        insets.bottom = 0
        feedWebView.scrollView.contentInset = insets
    }
}

extension FeedViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
}
