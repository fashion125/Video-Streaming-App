//
//  OpenTermsCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 19.06.17.
//
//

import UIKit

class OpenTermsCommand: AuthCommand {

    override func execute() {
        self.delegate.didPressToTermsButton()
    }
}
