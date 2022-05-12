//
//  ShurjopaySdk.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-11
//

import Foundation

public class ShurjopaySdk {
    public init() {
    }
    public func paramValue(key argKey: String, value argValue: Any) {
    }
    public func makePayment(viewController: UIViewController, sdkType: String, requestData: RequestData) {
        addCircleProgress(viewController: viewController)
    }
    private func addCircleProgress(viewController: UIViewController) {
        let progressHUD = ProProgressBar(label: "Loading...")
        viewController.view.addSubview(progressHUD)
    }
}
