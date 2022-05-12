//
//  Transaction.swift
//  ShurjopaySdk
//
//  Created by Rz Rasel on 2022-05-11
//

import Foundation

public struct TransactionData {
    public var id:                  Int
    public var orderId:             String
    public var currency:            String
    public var amount:              Double
    public var payableAmount:       Double
    public var discsountAmount:     Double
    public var discPercent:         Double
    public var usdAmt:              Double
    public var usdRate:             Double
    public var cardHolderName:      String
    public var cardNumber:          String
    public var phoneNo:             String
    public var bankTrxId:           String
    public var invoiceNo:           String
    public var bankStatus:          String
    public var customerOrderId:     String
    public var spCode:              Int
    public var spMassage:           String
    public var name:                String
    public var email:               String
    public var address:             String
    public var city:                String
    public var transactionStatus:   String
    public var dateTime:            String
    public var method:              String
    public var value1:              String
    public var value2:              String
    public var value3:              String
    public var value4:              String
}
