//
//  ShurjopaySdkPlugin.swift
//  ShurjopaySdk
//
//  Created by MacBook Pro on 16/5/22.
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
    init(onSuccess: @escaping onSuccess, onFailed: @escaping onFailed) {
        self.onSuccess = onSuccess
        self.onFailed = onFailed
    }
    func onSDKPlugin(onProgressView: @escaping onProgressView) {
        self.onProgressView = onProgressView
        guard onCheckInternet() == true else {
            return
        }
        self.onProgressView?(true)
        self.onProgressView?(false)
    }
    @available(iOS 13.0.0, *)
    func getToken() async throws {
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
