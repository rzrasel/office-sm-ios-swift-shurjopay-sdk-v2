//
//  ViewController.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-10
//  Copyright (c) 2022 shurjoMukhiDev. All rights reserved.
//

import UIKit
import ShurjopaySdk

class ViewController: UIViewController {
    var shurjopaySdk: ShurjopaySdk?

    override func viewDidLoad() {
        super.viewDidLoad()
        //AppConstants.SDK_TYPE_SANDBOX
        // Do any additional setup after loading the view, typically from a nib.
        onShurjoPaySdk(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onShurjoPaySdk(viewController: UIViewController) {
        let requestData = RequestData(
            username:           "username",
            password:           "password",
            prefix:             "prefix",
            currency:           "currency",
            amount:             0,
            orderId:            "",
            discountAmount:     0,
            discPercent:        0,
            customerName:       "customerName",
            customerPhone:      "customerPhone",
            customerEmail:      "customerEmail",
            customerAddress:    "customerAddress",
            customerCity:       "customerCity",
            customerState:      "customerState",
            customerPostcode:   "customerPostcode",
            customerCountry:    "customerCountry",
            returnUrl:          "returnUrl",
            cancelUrl:          "cancelUrl",
            clientIp:           "clientIp",
            value1:             "value1",
            value2:             "value2",
            value3:             "value3",
            value4:             "value4"
        )
        shurjopaySdk = ShurjopaySdk()
        shurjopaySdk?.makePayment(
            viewController: self,
            sdkType:        AppConstants.SDK_TYPE_SANDBOX,
            requestData:    requestData
        )
    }

}

