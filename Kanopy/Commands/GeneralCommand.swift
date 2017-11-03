//
//  GeneralCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/7/17.
//
//

import UIKit

class GeneralCommand: NSObject {

    // MARK: - Init method 
    
    
    override init() {
        super.init()
    }
    
    
    /**
     This method start command
     */
    func execute() {
        assertionFailure("Must be implemented in subclass")
    }
    
    
    func execute(_ value: Bool!) {
        assertionFailure("Must be implemented in subclass")
    }
    
    
    open func execute(_ itemModel: ItemModel!) {
        
    }
}
