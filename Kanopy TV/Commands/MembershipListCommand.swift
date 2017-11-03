//
//  MembershipListCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

class MembershipListCommand: GeneralCommand {

    private(set) var delegate: MembershipListVCDelegate!
    
    // MARK: - Init method 
    
    
    init(delegate: MembershipListVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
}
