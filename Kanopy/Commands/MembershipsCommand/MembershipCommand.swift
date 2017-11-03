//
//  MembershipCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 11.05.17.
//
//

import UIKit

class MembershipCommand: GeneralCommand {

    private(set) var delegate: ProfileVCDelegate!
    
    // MARK: - Init method 
    
    
    init(delegate: ProfileVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
    
    
    
    func execute(identity: IdentityModel!) {
        self.delegate.didChooseMembership(identity: identity)
    }
}
