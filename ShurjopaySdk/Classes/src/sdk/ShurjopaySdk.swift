//
//  ShurjopaySdk.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-11
//

import Foundation

public class ShurjopaySdk {
    var shurjopaySdkPlugin: ShurjopaySdkPlugin?
    //var onFailed: ((String) -> Void)?
    public typealias onSuccess = (ErrorSuccess) -> Void
    public typealias onFailed = (ErrorSuccess) -> Void
    //typealias onProgressView = (Bool) -> Void
    var onSuccess: onSuccess?
    var onFailed: onFailed?
    //var onProgressView: onProgressView?
    var viewController: UIViewController?
    var progressBar: ProProgressBar?
    //
    //public init() {}
    public init(onSuccess: @escaping onSuccess, onFailed: @escaping onFailed) {
        self.onSuccess = onSuccess
        self.onFailed = onFailed
    }
    //
    public func makePayment(viewController: UIViewController, sdkType: String, requestData: RequestData) {
        self.viewController = viewController
        shurjopaySdkPlugin = ShurjopaySdkPlugin(onSuccess: self.onSuccess!, onFailed: self.onFailed!)
        shurjopaySdkPlugin?.onSDKPlugin(onProgressView: self.onProgressView)
        showProgressView()
    }
    func onProgressView(isShow: Bool) {
        if(isShow) {
            showProgressView()
        } else {
            hideProgressView()
        }
    }
    func showProgressView() {
        progressBar = ProProgressBar(label: "Loading...")
        progressBar?.show(viewController: viewController!)
    }
    func hideProgressView() {
        progressBar?.hide(viewController: viewController!)
        //progressBar?.removeFromSuperview()
    }
    /*public func makePaymentOld02(viewController: UIViewController, sdkType: String, requestData: RequestData) {
        guard NetConnection.isConnected() == true else {
            self.onFailed?(ErrorSuccess(
                message: "Net connection failed",
                esType: ErrorSuccess.ESType.INTERNET_ERROR
            ))
            //print("Net connection failed")
            return
        }
        self.onSuccess?(ErrorSuccess(
            message: "Net connected",
            esType: ErrorSuccess.ESType.INTERNET_SUCCESS
        ))
        //print("Net connected")
        //shurjopaySdkPlugin = ShurjopaySdkPlugin(onSuccess: self.onSuccess!, onFailed: self.onFailed!)
        //shurjopaySdkPlugin?.onCheck()
    }*/
    /*public func makePaymentOld01(viewController: UIViewController, sdkType: String, requestData: RequestData) {
        //Utils.showProgressBar(viewController: viewController)
        if(!NetConnection.isConnected()) {
            print("Net connection failed")
            return
        }
        print("Net connected")
    }*/
}

/*
WLAMA - Wite label ATM merchant acquiring
Application Development Requirements
------------------------------------
QR
 - QR WLAMA
 - Document management
 - PRA Acount - Mobile wallet
*/
