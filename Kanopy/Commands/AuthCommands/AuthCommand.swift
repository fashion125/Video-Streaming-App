//
//  AuthCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class AuthCommand: GeneralCommand {

    var delegate: AuthVCDelegate!
    
    // MARK: - Init method 
    
    
    init(delegate: AuthVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
    
    
    /**
     This method start command
     */
    override func execute() {
        assertionFailure("Must be implemented in subclass")
    }
}
