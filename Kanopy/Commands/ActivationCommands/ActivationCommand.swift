//
//  ActivationCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/7/17.
//
//

import UIKit

class ActivationCommand: GeneralCommand {

    private(set) var delegate: ActivationVCDelegate!
    
    init(delegate: ActivationVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
}
