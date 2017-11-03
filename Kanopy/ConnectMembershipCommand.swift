//
//  ConnectMembershipCommand.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 16/05/2017.
//
//

import UIKit

class ConnectMembershipCommand: GeneralMembershipCommand {
    
    override func execute() {
        // Logging the user to the destination list and hashtag
        self.delegate.autologinTo(destination: self.destination, hashtag: self.hashtag)
    }
}
