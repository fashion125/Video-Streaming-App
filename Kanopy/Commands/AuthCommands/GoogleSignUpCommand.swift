//
//  GoogleSignUpCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class GoogleSignUpCommand: AuthCommand {

    override func execute() {
        self.delegate.didPressToGoogleSignUpButton()
    }
}
