//
//  LinkYourRokuCommand.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 01/06/2017.
//
//

import UIKit

class LinkYourRokuCommand: MenuCommand {
    
    // MARK: - Init method

    
    override func execute() {
        self.delegate.didPressLinkYourRoku()
    }
}
