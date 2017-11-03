//
//  LinkDeviceCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/18/17.
//
//

import UIKit

class LinkDeviceCommand: NSObject {

    private(set) var delegate: LinkDeviceVCDelegate!
    
    // MARK: - Init method
    
    
    init(delegate: LinkDeviceVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
    
    
    open func execute() {
        assertionFailure("Must be implemented in subclass")
    }
}
