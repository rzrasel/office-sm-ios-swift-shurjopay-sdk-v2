//
//  Utils.swift
//  ShurjopaySdk
//
//  Created by MacBook Pro on 16/5/22.
//

import Foundation

class Utils {
    public class func showProgressBar(viewController: UIViewController) {
        let progressView = ProProgressBar(label: "Loading...")
        viewController.view.addSubview(progressView)
    }
}
public enum HttpMethod: String {
    case POST   = "POST"
    case GET    = "GET"
}
extension Utils {
    static func getJsonData(responseData: Data) -> [String: Any]? {
        let jsonResponse: [String: Any]? = nil
        do {
            // create json object from data or use JSONDecoder to convert to Model stuct
            if let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                // handle json response
                return jsonData
            } else {
                print("DEBUG_LOG_PRINT: Data maybe corrupted or in wrong format")
                //throw URLError(.badServerResponse)
            }
        } catch let error {
            print("DEBUG_LOG_PRINT: \(error.localizedDescription)")
        }
        return jsonResponse
    }
    class func onPrintResponseData(responseData: Data) {
        do {
            // create json object from data or use JSONDecoder to convert to Model stuct
            if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                print("DEBUG_LOG_PRINT: JSON_RESPONSE: \(jsonResponse)")
                // handle json response
            } else {
                print("DEBUG_LOG_PRINT: JSON_RESPONSE: Data maybe corrupted or in wrong format")
                //throw URLError(.badServerResponse)
            }
        } catch let error {
            print("DEBUG_LOG_PRINT: JSON_RESPONSE: \(error.localizedDescription)")
        }
    }
}
extension Dictionary {
    public func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    public static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
