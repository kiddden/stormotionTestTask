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
        super.loadView()
        feedWebView = WKWebView()
        feedWebView.navigationDelegate = self
        view = feedWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        configureNavBar()
        configureWebView()
        injectJSCode()
    }
    
    private func configureNavBar() {
        title = "Feed"
        
        // Making the nav bar not transparent
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func configureWebView() {
        feedWebView.scrollView.contentInsetAdjustmentBehavior = .never
        feedWebView.backgroundColor = .systemBackground
        
        guard let url = URL(string: BaseURLs.feedURL) else { return }
        feedWebView.load(URLRequest(url: url))
    }
    
    private func injectJSCode() {
        guard let filepath = Bundle.main.path(forResource: "script", ofType: "js"), let js = try? String(contentsOfFile: filepath) else { return }
        let userScript = WKUserScript.init(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        feedWebView.configuration.userContentController.addUserScript(userScript)
        feedWebView.configuration.userContentController.add(self, name: "jsMessenger")
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        var insets = view.safeAreaInsets
        insets.bottom = 0
        feedWebView.scrollView.contentInset = insets
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dismissLoadingView()
    }
}

extension FeedViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let postVC = PostViewController(articleID: message.body as! String)
        let navController = UINavigationController(rootViewController: postVC)
        present(navController, animated: true)
    }
}
