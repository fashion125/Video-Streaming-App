//
//  AddYourLibraryCommand.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 16/05/2017.
//
//

import UIKit

class AddYourLibraryCommand: ActivationCommand {
    
    override func execute() {
        let destination = "/wayf/user/welcome"
        // Logging the user to the wayf
        self.delegate.autologinTo(destination: destination, hashtag: "")
    }
}
