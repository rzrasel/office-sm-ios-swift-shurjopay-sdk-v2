//
//  ShurjopaySdkPlugin.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-16
//

import Foundation

class ShurjopaySdkPlugin {
    //
    typealias onSuccess = (ErrorSuccess) -> Void
    typealias onFailed = (ErrorSuccess) -> Void
    typealias onProgressView = (Bool) -> Void
    var onSuccess: onSuccess?
    var onFailed: onFailed?
    var onProgressView: onProgressView?
    //
    //public init() {}
    init(onSuccess: @escaping onSuccess,
         onProgressView: @escaping onProgressView,
         onFailed: @escaping onFailed) {
        self.onSuccess      = onSuccess
        self.onProgressView = onProgressView
        self.onFailed       = onFailed
    }
    func onSDKPlugin(sdkType: String, requestData: RequestData) {
        guard onCheckInternet() == true else {
            return
        }
        //self.onProgressView?(true)
        //self.onProgressView?(false)
        getToken(sdkType: sdkType, requestData: requestData)
    }
    //@available(iOS 13.0.0, *)
    func getToken(sdkType: String, requestData: RequestData) {
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
        print("DEBUG_LOG_PRINT: Request_Method: \(HTTPMethod.POST.rawValue) Parameters: \(parameters)")
        let postString = "username=\(requestData.username ?? "")&password=\(requestData.password ?? "")"
        let httpBody = postString.data(using: .utf8)
        //request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = httpBody
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
        let str = String(decoding: request.httpBody!, as: UTF8.self)
        print("DEBUG_LOG_PRINT: REQUEST_DATA: \(str)")
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
            let spCode: Int? = jsonData?["sp_code"] as? Int
            guard spCode == 200 else {
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
// Internet check
extension ShurjopaySdkPlugin {
    func onCheckInternet() -> Bool {
        guard NetConnection.isConnected() == true else {
            self.onFailed?(ErrorSuccess(
                message: "Net connection failed",
                esType: ErrorSuccess.ESType.INTERNET_ERROR
            ))
            //print("Net connection failed")
            return false
        }
        self.onSuccess?(ErrorSuccess(
            message: "Net connected",
            esType: ErrorSuccess.ESType.INTERNET_SUCCESS
        ))
        return true
    }
}
