//
//  StatusActivationModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/9/17.
//
//

import UIKit

class StatusActivationModel: NSObject {

    private(set) var isVerifyEmail: Bool!
    private(set) var isAddMembership: Bool!
    private(set) var isMembershipStatusLookup: Bool!
    private(set) var isVerifyAccount: Bool!
    
    
    // MARK: - Init 
    
    
    init(isVerifyEmail: Bool!, isAddMembership: Bool!, isMembershipStatusLookup: Bool!,
         isVerifyAccount: Bool!) {
        super.init()
        
        self.isVerifyEmail = isVerifyEmail
        self.isAddMembership = isAddMembership
        self.isMembershipStatusLookup = isMembershipStatusLookup
        self.isVerifyAccount = isVerifyAccount
    }
}
