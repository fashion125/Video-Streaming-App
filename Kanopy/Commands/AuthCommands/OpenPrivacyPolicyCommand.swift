//
//  OpenPrivacyPolicyCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 19.06.17.
//
//

import UIKit

class OpenPrivacyPolicyCommand: AuthCommand {

    override func execute() {
        self.delegate.didPressToPrivacyPolicyButton()
    }
}
