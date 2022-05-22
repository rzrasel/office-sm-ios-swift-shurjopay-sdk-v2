//
//  WebViewContainer.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-18
//

import Foundation
import UIKit
import WebKit

class ShurjoPayViewController: UIViewController {
    typealias onSuccess         = (_ transactionData: TransactionData?, ErrorSuccess) -> Void
    typealias onFailed          = (ErrorSuccess) -> Void
    typealias onProgressView    = (Bool) -> Void
    var onSuccess:      onSuccess?
    var onFailed:       onFailed?
    var onProgressView: onProgressView?
    private let webView         = WKWebView()
    private var tokenData:      TokenData?
    private var checkoutData:   CheckoutData?
    private var sdkType:        String?
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        onCreateView()
    }
    func setListener(onSuccess: @escaping onSuccess,
                     onProgressView: @escaping onProgressView,
                     onFailed: @escaping onFailed) {
        self.onSuccess      = onSuccess
        self.onProgressView = onProgressView
        self.onFailed       = onFailed
    }
    func onLoadData(sdkType: String, tokenData: TokenData, checkoutData: CheckoutData) {
        self.sdkType        = sdkType
        self.tokenData      = tokenData
        self.checkoutData   = checkoutData
        onLoad(location: checkoutData.checkoutUrl!)
    }
    private func onCreateView() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
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
extension ShurjoPayViewController: WKNavigationDelegate, UIWebViewDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("Finished navigating to url \(String(describing: webView.url))")
        /*if ((webView.url?.absoluteString.contains("facebook.com")) != nil) {
            // do something here
        }*/
        /*guard let url = webView.url?.path else {
            return
        }*/
        let url = webView.url?.path
        if url!.containsIgnoringCase(find: "cancel_url") {
            self.onFailed?(ErrorSuccess(
                message:    "Cancel by user",
                esType:     ErrorSuccess.ESType.HTTP_CANCEL
            ))
            self.dismiss(animated: true, completion: nil)
            return
        }
        if url!.containsIgnoringCase(find: "return_url") || url!.containsIgnoringCase(find: "order_id") {
            verifyPayment(sdkType: sdkType!)
        }
    }
}
extension ShurjoPayViewController {
    func verifyPayment(sdkType: String) {
        self.dismiss(animated: true, completion: nil)
        let verifyUrl = ApiClient.getApiClient(sdkType: sdkType).verify()
        //let verifyUrl = "https://rzrasel.000webhostapp.com/plugins.php"
        //let verifyUrl = "http://192.168.10.61/plugins.php"
        print("DEBUG_LOG_PRINT: VERIFY_URL: \(verifyUrl)")
        let parameters: [String: Any] = [
            "order_id": "\(checkoutData?.spOrderId! ?? "")"
        ]
        let header = (tokenData?.tokenType)! + " " + (tokenData?.token)!
        Utils.onHttpRequest(httpMethod: HttpMethod.POST, location: verifyUrl, parameters: parameters, header: header, isEncoded: true) {
            (data: Data?, error: Error?) in
            guard error == nil else {
                self.onFailed?(ErrorSuccess(
                    message:    error!.localizedDescription,
                    esType:     ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            /*let str = String(decoding: data!, as: UTF8.self)
            print("DEBUG_LOG_PRINT: DATA_RESPONS \(str)")*/
            var transactionDataList: [TransactionData] = []
            do {
                let decoder = JSONDecoder()
                transactionDataList = try decoder.decode([TransactionData].self, from: data!)
                //print("DEBUG_LOG_PRINT: TransactionData: \(transactionDataList)")
            }
            catch {
                //print (error)
                self.onFailed?(ErrorSuccess(
                    message:    error.localizedDescription,
                    esType:     ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            if(transactionDataList.count < 1) {
                self.onFailed?(ErrorSuccess(
                    message:    "Transaction data not found",
                    esType:     ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            let transactionData: TransactionData = transactionDataList[transactionDataList.count - 1]
            if(transactionData.spCode == 1000) {
                self.onSuccess?(transactionData, ErrorSuccess(
                    message:    "Transaction success",
                    esType:     ErrorSuccess.ESType.HTTP_SUCCESS
                ))
                return
            } else {
                self.onFailed?(ErrorSuccess(
                    message:    "Transaction failed sp code",
                    esType:     ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
        }
    }
}
