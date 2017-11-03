//
//  ContinueOnboardingCommand.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 21/07/2017.
//
//

import UIKit

class ContinueOnboardingCommand: GeneralCommand {
    
    private(set) var delegate: ProfileVCDelegate!
    
    init(delegate: ProfileVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
    
    override func execute() {
        self.delegate.continueOnboarding()
    }
}
