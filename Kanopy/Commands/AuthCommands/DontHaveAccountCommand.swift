//
//  DontHaveAccountCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class DontHaveAccountCommand: AuthCommand {

    override func execute() {
        self.delegate.didPressToDontHaveAccountButton()
    }
}
