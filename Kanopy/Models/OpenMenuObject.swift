//
//  OpenMenuObject.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/9/17.
//
//

import UIKit

class OpenMenuObject: NSObject {
    
    private(set) var actionKey: String! = ""
    private(set) var objectID: String?
    
    init(actionKey: String!, objectID: String?) {
        super.init()
        
        self.actionKey = actionKey
        self.objectID = objectID 
    }
}
