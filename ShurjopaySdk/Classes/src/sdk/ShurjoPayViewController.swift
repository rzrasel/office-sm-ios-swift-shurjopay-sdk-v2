//
//  WebViewContainer.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-18
//

import Foundation
import UIKit
import WebKit

class ShurjoPayViewController: UIViewController, WKNavigationDelegate {
    let webView = WKWebView()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //let viewController = WebViewContainer()
        onCreateView()
        //onLoad(location: "https://www.earthhero.org")
    }
    func onLoadData(tokenData: TokenData, responseData: ResponseData) {
        onLoad(location: responseData.checkoutUrl!)
    }
    private func onCreateView() {
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(webView)
        webView.navigationDelegate = self
    }
    private func onLoad(location: String) {
        let url = URL(string: location)!
        webView.load(URLRequest(url: url))
    }
}
