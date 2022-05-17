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
