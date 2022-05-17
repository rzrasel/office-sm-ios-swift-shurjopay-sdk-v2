//
//  ErrorSuccess.swift
//  ShurjopaySdk
//
//  Created by MacBook Pro on 16/5/22.
//

import Foundation

public class ErrorSuccess {
    public var message: String?
    public var esType:  ESType?
    
    public init(message: String, esType: ESType) {
        self.message    = message
        self.esType     = esType
    }
    
    public enum ESType: CaseIterable {
        // ES = Error Success
        case SUCCESS, ERROR
        case INTERNET_SUCCESS, INTERNET_ERROR
        case HTTP_SUCCESS, HTTP_ERROR
    }
}
