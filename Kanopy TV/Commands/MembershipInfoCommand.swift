//
//  MembershipInfoCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

class MembershipInfoCommand: GeneralCommand {

    private(set) var delegate: MembershipInfoVCDelegate!
    
    // MARK: - Init method 
    
    init(delegate: MembershipInfoVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
}
