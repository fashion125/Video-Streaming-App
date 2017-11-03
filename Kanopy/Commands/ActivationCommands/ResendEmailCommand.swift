//
//  ResendEmailCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/7/17.
//
//

import UIKit

class ResendEmailCommand: ActivationCommand {
    
    override func execute() {
        self.delegate.resendEmail()
    }
}
