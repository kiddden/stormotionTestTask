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
        postWebView = WKWebView()
        postWebView.navigationDelegate = self
        view = postWebView
        postWebView.scrollView.contentInsetAdjustmentBehavior = .never
        postWebView.backgroundColor = .systemBackground
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
        configureVC()
        configureWebView()
    }
    
    func configureVC() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentShareSheet))
        navigationItem.rightBarButtonItem = shareButton
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureWebView() {
        title = "Post"
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
