//
//  ContentCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/24/17.
//
//

import UIKit

class ContentCommand: GeneralCommand {

    private(set) var delegate: GenericContentVCDelegate!
    
    
    // MARK: - Init method 
    
    
    init(delegate: GenericContentVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
}
