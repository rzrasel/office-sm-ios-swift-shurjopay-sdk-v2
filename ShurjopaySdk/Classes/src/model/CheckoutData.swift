//
//  RequestData.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-11
//

import Foundation

public struct CheckoutData {
    public var token:               String
    public var storeId:             Int
    public var prefix:              String
    public var currency:            String
    public var returnUrl:           String
    public var cancelUrl:           String
    public var amount:              Double
    public var orderId:             String
    public var discsountAmount:     Double
    public var discPercent:         Double
    public var clientIp:            String
    public var customerName:        String
    public var customerPhone:       String
    public var customerEmail:       String
    public var customerAddress:     String
    public var customerCity:        String
    public var customerState:       String
    public var customerPostcode:    String
    public var customerCountry:     String
    public var value1:              String
    public var value2:              String
    public var value3:              String
    public var value4:              String
}