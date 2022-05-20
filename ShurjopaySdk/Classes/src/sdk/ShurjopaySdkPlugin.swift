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
        //self.onProgressView?(true)
        //self.onProgressView?(false)
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
            Utils.onPrintResponseData(responseData: data!)
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
            print("DEBUG_LOG_PRINT: executeUrl: \(String(describing: tokenData.executeUrl))")
            self.getExecuteUrl(tokenData: tokenData)
        }
    }
    private func getExecuteUrl(tokenData: TokenData) {
        let checkoutUrl = ApiClient.getApiClient(sdkType: sdkType!).checkout()
        print("DEBUG_LOG_PRINT: HTTP_METHOD: \(HttpMethod.POST.rawValue) SDK_TYPE: \(String(describing: sdkType)) CHECKOUT_URL: \(checkoutUrl)")
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
            Utils.onPrintResponseData(responseData: data!)
            var checkoutData: CheckoutData?
            do {
                let decoder = JSONDecoder()
                checkoutData = try decoder.decode(CheckoutData.self, from: data!)
                print("DEBUG_LOG_PRINT: CHECKOUT_DATA: \(String(describing: checkoutData))")
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
        /*progressBar = ProProgressBar(label: "Loading...")
        progressBar?.show(viewController: viewController!)*/
    }
    func hideProgressView() {
        DispatchQueue.main.async {
            self.progressBar?.hide(viewController: self.viewController!)
            //self.progressBar?.removeFromSuperview()
        }
        //progressBar?.hide(viewController: viewController!)
        //progressBar?.removeFromSuperview()
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
extension ShurjopaySdkPlugin {
    //@available(iOS 13.0.0, *)
    func getTokenOld01(sdkType: String, requestData: RequestData) {
        let tokenUrl = ApiClient.getApiClient(sdkType: sdkType).getToken()
        //let tokenUrl = "https://rzrasel.000webhostapp.com/plugins.php"
        print("DEBUG_LOG_PRINT: SDK_TYPE: \(sdkType)")
        print("DEBUG_LOG_PRINT: TOKEN_URL: \(tokenUrl)")
        let username = requestData.username!
        let password = requestData.password!
        let url = URL(string: tokenUrl)!
        var request = URLRequest(url: url)
        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]
        //let parameterData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
        //let parameterData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        /*guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            self.onFailed?(ErrorSuccess(
                message: "Json serialization error",
                esType: ErrorSuccess.ESType.HTTP_ERROR
            ))
            return
        }*/
        print("DEBUG_LOG_PRINT: Request_Method: \(HttpMethod.POST.rawValue) Parameters: \(parameters)")
        /*let postString = "username=\(requestData.username ?? "")&password=\(requestData.password ?? "")"
        let httpBody = postString.data(using: .utf8)*/
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = HttpMethod.POST.rawValue
        request.httpBody = parameters.percentEncoded()
        //request.httpBody = httpBody
        /*let str = String(decoding: httpBody!, as: UTF8.self)
        print("DEBUG_LOG_PRINT: STRING_AGAIN \(str)")*/
        //request.httpBody = parameters.percentEncoded()
        /*do {
            // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("DEBUG_LOG_PRINT: GET_TOKEN_ERROR: \(error.localizedDescription)")
            self.onFailed?(ErrorSuccess(
                message: error.localizedDescription,
                esType: ErrorSuccess.ESType.HTTP_ERROR
            ))
            return
        }*/
        /*let str = String(decoding: request.httpBody!, as: UTF8.self)
        print("DEBUG_LOG_PRINT: REQUEST_DATA \(String(describing: str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)))")*/
        /*let str = String(decoding: request.httpBody!, as: UTF8.self)
        print("DEBUG_LOG_PRINT: REQUEST_DATA: \(str)")*/
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DEBUG_LOG_PRINT: POST_REQUEST_ERROR: \(error.localizedDescription)")
                self.onFailed?(ErrorSuccess(
                    message: error.localizedDescription,
                    esType: ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }

            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("DEBUG_LOG_PRINT: Invalid Response received from the server")
                self.onFailed?(ErrorSuccess(
                    message: "Invalid Response received from the server",
                    esType: ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            guard let responseData = data else {
                print("DEBUG_LOG_PRINT: nil Data received from the server")
                self.onFailed?(ErrorSuccess(
                    message: "nil Data received from the server",
                    esType: ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            Utils.onPrintResponseData(responseData: responseData)
            let jsonData = Utils.getJsonData(responseData: responseData)
            let spCode = jsonData?["sp_code"]
            guard spCode as! String == "200" else {
                self.onFailed?(ErrorSuccess(
                    message: jsonData?["message"] as! String,
                    esType: ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
        }
        task.resume()
    }
    func getTokenOld02(sdkType: String, requestData: RequestData) {
        let tokenUrl = ApiClient.getApiClient(sdkType: sdkType).getToken()
        print("DEBUG_LOG_PRINT: HTTP_METHOD: \(HttpMethod.POST.rawValue) SDK_TYPE: \(sdkType) TOKEN_URL: \(tokenUrl)")
        let url = URL(string: tokenUrl)!
        var request = URLRequest(url: url)
        let parameters: [String: Any] = [
            "username": requestData.username!,
            "password": requestData.password!
        ]
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = HttpMethod.POST.rawValue
        request.httpBody = parameters.percentEncoded()
        //
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DEBUG_LOG_PRINT: POST_REQUEST_ERROR: \(error.localizedDescription)")
                self.onFailed?(ErrorSuccess(
                    message: error.localizedDescription,
                    esType: ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }

            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("DEBUG_LOG_PRINT: Invalid Response received from the server")
                self.onFailed?(ErrorSuccess(
                    message: "Invalid Response received from the server",
                    esType: ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            guard let responseData = data else {
                print("DEBUG_LOG_PRINT: nil Data received from the server")
                self.onFailed?(ErrorSuccess(
                    message: "nil Data received from the server",
                    esType: ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
            Utils.onPrintResponseData(responseData: responseData)
            let jsonData = Utils.getJsonData(responseData: responseData)
            let spCode = jsonData?["sp_code"]
            guard spCode as! String == "200" else {
                self.onFailed?(ErrorSuccess(
                    message: jsonData?["message"] as! String,
                    esType: ErrorSuccess.ESType.HTTP_ERROR
                ))
                return
            }
        }
        task.resume()
    }
}
extension ShurjopaySdkPlugin {
    func onHttpRequestOld01(httpMethod: HttpMethod,
                       location: String,
                       parameters: [String: Any],
                       completionHandler: @escaping (_ data: Data?, _ error: NSError?) -> Void) {
        print("DEBUG_LOG_PRINT: Parameters: \(parameters)")
        let url = URL(string: location)!
        var request = URLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = httpMethod.rawValue
        request.httpBody = parameters.percentEncoded()
        //
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                //print("DEBUG_LOG_PRINT: POST_REQUEST_ERROR: \(error.localizedDescription)")
                completionHandler(data, error as NSError?)
                return
            }

            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                //print("DEBUG_LOG_PRINT: Invalid Response received from the server")
                let httpResponse = response as? HTTPURLResponse
                let nsError = NSError(domain: "Invalid Response received from the server", code: httpResponse!.statusCode, userInfo: nil)
                completionHandler(data, nsError)
                return
            }
            guard let responseData = data else {
                //print("DEBUG_LOG_PRINT: nil Data received from the server")
                let httpResponse = response as? HTTPURLResponse
                let nsError = NSError(domain: "nil Data received from the server", code: httpResponse!.statusCode, userInfo: nil)
                completionHandler(data, nsError)
                return
            }
            completionHandler(responseData, error as NSError?)
        }
        task.resume()
    }
}
