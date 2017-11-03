//
//  AuthDataModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/3/17.
//
//

import UIKit

class AuthDataModel: NSObject {

    private(set) var firstName: String? = ""
    private(set) var lastName: String? = ""
    private(set) var email: String! = ""
    private(set) var password: String = ""
    
    
    // MARK: -
    
    
    init(firstName: String?,
         lastName: String?,
         email: String!,
         password: String!)
    {
        super.init()
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
    
    
    func verifyForSignIn() -> Bool {
        return true
//        return self.email.isValidEmail() &&
//            self.password.characters.count > 0
    }
    
    
    func verifyForSignUp() -> Bool {
        
        return self.email.characters.count > 0 &&
            self.password.characters.count > 0 &&
            (self.firstName?.characters.count)! > 0 &&
            (self.lastName?.characters.count)! > 0
    }
    
    
    func verifyPasswordForSignUp() -> Bool {
        
        return self.password.characters.count >= 6
    }
    
    
    func verifyEmailForSignUp() -> Bool {
        
        return self.email.isValidEmail()
    }
}
