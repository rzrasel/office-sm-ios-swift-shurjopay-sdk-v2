//
//  ShurjopaySdkPlugin.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-16
//

import Foundation
import UIKit

class ShurjopaySdkPlugin {
    //
    typealias onSuccess         = (_ transactionData: TransactionData?, ErrorSuccess) -> Void
    typealias onFailed          = (ErrorSuccess) -> Void
    typealias onProgressView    = (Bool) -> Void
    var onSuccess:      onSuccess?
    var onFailed:       onFailed?
    var onProgressView: onProgressView?
    var uiProperty:     UIProperty?
    var viewController: UIViewController?
    var progressBar:    ProProgressBar?
    var requestData:    RequestData?
    var sdkType:        String?
    //
    //public init() {}
    init(onSuccess: @escaping onSuccess,
         onProgressView: @escaping onProgressView,
         onFailed: @escaping onFailed) {
        self.onSuccess      = onSuccess
        self.onProgressView = onProgressView
        self.onFailed       = onFailed
    }
    func onSDKPlugin(uiProperty: UIProperty, sdkType: String, requestData: RequestData) {
        showProgressView()
        guard onCheckInternet() == true else {
            return
        }
        self.uiProperty     = uiProperty
        self.viewController = uiProperty.viewController
        self.sdkType        = sdkType
        self.requestData    = requestData
        getToken()
    }
    private func getToken() {
        let tokenUrl = ApiClient.getApiClient(sdkType: sdkType!).getToken()
        print("DEBUG_LOG_PRINT: HTTP_METHOD: \(HttpMethod.POST.rawValue) SDK_TYPE: \(String(describing: sdkType)) TOKEN_URL: \(tokenUrl)")
        let parameters: [String: Any] = [
            "username": requestData?.username ?? "",
            "password": requestData?.password ?? ""
        ]
        Utils.onHttpRequest(httpMethod: HttpMethod.POST, location: tokenUrl, parameters: parameters, header: nil, isEncoded: true) { [self]
            (data: Data?, error: Error?) in
            guard error == nil else {
                self.onFailed?(ErrorSuccess(
                    message:    error!.localizedDescription,
                    esType:     ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            //Utils.onPrintResponseData(responseData: data!)
            let jsonData    = Utils.getJsonData(responseData: data!)
            let spCode      = jsonData?["sp_code"]
            guard spCode as! String == "200" else {
                self.onFailed?(ErrorSuccess(
                    message:    jsonData?["message"] as! String,
                    esType:     ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            var tokenData   = TokenData()
            tokenData.username      = requestData?.username
            tokenData.password      = requestData?.password
            tokenData.token         = jsonData!["token"] as? String
            tokenData.storeId       = jsonData!["store_id"] as? Int
            tokenData.executeUrl    = jsonData!["execute_url"] as? String
            tokenData.tokenType     = jsonData!["token_type"] as? String
            tokenData.spCode        = jsonData!["sp_code"] as? Int
            tokenData.massage       = jsonData!["massage"] as? String
            tokenData.expiresIn     = jsonData!["expires_in"] as? Int
            //print("DEBUG_LOG_PRINT: executeUrl: \(String(describing: tokenData.executeUrl))")
            self.getExecuteUrl(tokenData: tokenData)
        }
    }
    private func getExecuteUrl(tokenData: TokenData) {
        let checkoutUrl = ApiClient.getApiClient(sdkType: sdkType!).checkout()
        //print("DEBUG_LOG_PRINT: HTTP_METHOD: \(HttpMethod.POST.rawValue) SDK_TYPE: \(String(describing: sdkType)) CHECKOUT_URL: \(checkoutUrl)")
        let parameters: [String: Any] = [
            "token":                tokenData.token!,
            "store_id":             tokenData.storeId!,
            "prefix":               requestData!.prefix!,
            "currency":             requestData!.currency!,
            "amount":               requestData!.amount!,
            "order_id":             requestData!.orderId!,
            "discsount_amount":     requestData!.discountAmount!,
            "disc_percent":         requestData!.discPercent!,
            "client_ip":            requestData!.clientIp!,
            "customer_name":        requestData!.customerName!,
            "customer_phone":       requestData!.customerPhone!,
            "customer_email":       requestData!.customerEmail!,
            "customer_address":     requestData!.customerAddress!,
            "customer_city":        requestData!.customerCity!,
            "customer_state":       requestData!.customerState!,
            "customer_postcode":    requestData!.customerPostcode!,
            "customer_country":     requestData!.customerCountry!,
            "return_url":           requestData!.returnUrl!,
            "cancel_url":           requestData!.cancelUrl!,
            "value1":               requestData!.value1!,
            "value2":               requestData!.value2!,
            "value3":               requestData!.value3!,
            "value4":               requestData!.value4!,
        ]
        //print("DEBUG_LOG_PRINT: \(parameters)")
        Utils.onHttpRequest(httpMethod: HttpMethod.POST, location: checkoutUrl, parameters: parameters, header: nil, isEncoded: true) { [self]
            (data: Data?, error: Error?) in
            guard error == nil else {
                self.onFailed?(ErrorSuccess(
                    message:    error!.localizedDescription,
                    esType:     ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            //Utils.onPrintResponseData(responseData: data!)
            var checkoutData: CheckoutData?
            do {
                let decoder = JSONDecoder()
                checkoutData = try decoder.decode(CheckoutData.self, from: data!)
                //print("DEBUG_LOG_PRINT: CHECKOUT_DATA: \(String(describing: checkoutData))")
            } catch {
                //print(error.localizedDescription)
                self.onFailed?(ErrorSuccess(
                    message:    error.localizedDescription,
                    esType:     ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            hideProgressView()
            self.showWebView(tokenData: tokenData, checkoutData: checkoutData!)
        }
    }
    private func showWebView(tokenData: TokenData, checkoutData: CheckoutData) {
        DispatchQueue.main.async { [self] in
            let storyboard = UIStoryboard(name: uiProperty!.storyboardName, bundle: nil)
            let sPayViewController = storyboard.instantiateViewController(withIdentifier: uiProperty!.identifier) as! ShurjoPayViewController
            sPayViewController.modalPresentationStyle = .fullScreen
            sPayViewController.setListener(onSuccess: self.onSuccess!,
                                           onProgressView: self.onProgressView!,
                                           onFailed: self.onFailed!)
            sPayViewController.onLoadData(sdkType: sdkType!, tokenData: tokenData, checkoutData: checkoutData)
            self.viewController!.present(sPayViewController, animated: true, completion: nil)
        }
    }
    func showProgressView() {
        DispatchQueue.main.async {
            self.progressBar = ProProgressBar(label: "Loading...")
            self.progressBar?.show(viewController: self.viewController!)
        }
    }
    func hideProgressView() {
        DispatchQueue.main.async {
            self.progressBar?.hide(viewController: self.viewController!)
        }
    }
}
//
// Internet check
extension ShurjopaySdkPlugin {
    func onCheckInternet() -> Bool {
        guard NetConnection.isConnected() == true else {
            self.onFailed?(ErrorSuccess(
                message:    "Net connection failed",
                esType:     ErrorSuccess.ESType.INTERNET_ERROR
            ))
            //print("Net connection failed")
            return false
        }
        self.onSuccess?(nil, ErrorSuccess(
            message:    "Net connected",
            esType:     ErrorSuccess.ESType.INTERNET_SUCCESS
        ))
        return true
    }
}
