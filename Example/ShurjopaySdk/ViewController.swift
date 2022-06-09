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
    let alertService = AlertService()
    var shurjopaySdk: ShurjopaySdk?

    override func viewDidLoad() {
        super.viewDidLoad()
        //AppConstants.SDK_TYPE_SANDBOX
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickShurjoPay(_ sender: UIButton) {
        onShurjoPaySdk(viewController: self)
        //if UserDefaults.standard.string(forKey: "username") != nil {
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "viewControllerSecond")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)*/
    }
    
    func onShurjoPaySdk(viewController: UIViewController) {
        let orderId = Int.random(in: 0 ... 1000)
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
        shurjopaySdk = ShurjopaySdk(onSuccess: onSuccess, onFailed: onFailed)
        shurjopaySdk?.makePayment(
            uiProperty:     UIProperty(viewController: self,
                                       storyboardName: "Main",
                                       identifier: "sPayViewController"),
            sdkType:        AppConstants.SDK_TYPE_SANDBOX,
            requestData:    requestData
        )
    }
    func onSuccess(transactionData: TransactionData?, message: ErrorSuccess) {
        if(message.esType == ErrorSuccess.ESType.INTERNET_SUCCESS) {
            print("DEBUG_LOG_PRINT: INTERNET SUCCESS \(String(describing: message.message))")
        } else {
            print("DEBUG_LOG_PRINT: HTTP SUCCESS TRANSACTION_DATA: \(String(describing: transactionData)) \(String(describing: message.message))")
        }
    }
    func onFailed(message: ErrorSuccess) {
        if(message.esType == ErrorSuccess.ESType.INTERNET_ERROR) {
            print("DEBUG_LOG_PRINT: INTERNET ERROR \(String(describing: message.message))")
            //alertService.alert(viewController: self, message: message.message!)
        } else if(message.esType == ErrorSuccess.ESType.HTTP_CANCEL) {
            print("DEBUG_LOG_PRINT: HTTP CANCEL ERROR \(String(describing: message.message))")
        } else {
            print("DEBUG_LOG_PRINT: HTTP ERROR \(String(describing: message.message))")
        }
    }
    /*func onShurjoPaySdkOld01(viewController: UIViewController) {
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
        shurjopaySdk = ShurjopaySdk(onSuccess: onSuccess, onFailed: onFailed)
        shurjopaySdk?.makePayment(
            viewController: self,
            sdkType:        AppConstants.SDK_TYPE_SANDBOX,
            requestData:    requestData
        )
    }*/
}
