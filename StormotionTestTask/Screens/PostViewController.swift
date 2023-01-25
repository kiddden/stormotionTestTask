//
//  PostViewController.swift
//  StormotionTestTask
//
//  Created by Eugene Ned on 24.01.2023.
//

import UIKit
import WebKit

class PostViewController: UIViewController, WKNavigationDelegate {
    
    private var postWebView: WKWebView!
    private var articleID: String!
    
    override func loadView() {
        super.loadView()
        postWebView = WKWebView()
        postWebView.navigationDelegate = self
        view = postWebView
    }
    
    init(articleID: String) {
        super.init(nibName: nil, bundle: nil)
        self.articleID = articleID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        configureNavBar()
        configureWebView()
    }
    
    func configureNavBar() {
        title = "Post"
        
        // Making the nav bar not transparent
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
      
        //Adding nav buttons
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = backButton
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentShareSheet))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func configureWebView() {
        postWebView.scrollView.contentInsetAdjustmentBehavior = .never
        postWebView.backgroundColor = .systemBackground
        postWebView.allowsBackForwardNavigationGestures = true
        postWebView.allowsLinkPreview = true
        
        guard let url = URL(string: BaseURLs.postURL + articleID) else { return }
        postWebView.load(URLRequest(url: url))
    }
    
    @objc private func presentShareSheet() {
        guard let url = URL(string: BaseURLs.postURL + articleID) else { return }
        let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dismissLoadingView()
    }
}
