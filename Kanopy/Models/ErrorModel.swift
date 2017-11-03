//
//  ErrorModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/6/17.
//
//

import UIKit

class ErrorModel: NSObject {
    
    private(set) var titleError: String! = ""
    private(set) var messageError: String?
    private(set) var statusCode: Int! = 0
    private(set) var type: String! = ""
    
    
    // MARK: -
    
    
    init(_ title: String!, _ message: String, statusCode: Int!, type: String!) {
        super.init()
        
        self.titleError = title
        self.messageError = message
        self.statusCode = statusCode
        self.type = type
    }
}
