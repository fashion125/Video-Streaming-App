//
//  ExitCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/10/17.
//
//

import UIKit

class ExitCommand: ActivationCommand {

    override func execute() {
        self.delegate.exit()
    }
}
