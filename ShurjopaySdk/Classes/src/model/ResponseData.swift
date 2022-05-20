//
//  ResponseData.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-11
//

import Foundation

struct ResponseData {
    public var checkoutUrl:         String?
    public var amount:              Double?
    public var currency:            String?
    public var spOrderId:           String?
    public var customerOrderId:     String?
    public var customerName:        String?
    public var customerAddress:     String?
    public var customerCity:        String?
    public var customerPhone:       String?
    public var customerEmail:       String?
    public var clientIp:            String?
    public var intent:              String?
    public var transactionStatus:   String?
}
