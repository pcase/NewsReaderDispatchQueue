//
//  NewsReaderDetailViewController.swift
//  NewsReaderDispatchQueue
//
//  Created by Patty Case on 5/7/20.
//  Copyright © 2020 Azure Horse Creations. All rights reserved.
//

import UIKit
import WebKit

class NewsReaderDetailViewController: UIViewController, WKUIDelegate {

    
    var webView: WKWebView!
    var url:String = ""
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        
        let webViewUrl = URL(string:url)
        let request = URLRequest(url: webViewUrl!)
        webView.load(request)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
