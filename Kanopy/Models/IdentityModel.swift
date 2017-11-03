//
//  IdentityModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

class IdentityModel: NSObject {

    private(set) var ID: Int = 0
    private(set) var status: Bool = false
    private(set) var domainName: String = ""
    private(set) var isDefault: Bool = false
    private(set) var creditAvailable: Int = -1
    private(set) var statusKey: String = ""
    private(set) var expirationDate: Date?
    private(set) var domainStem: String = ""
    
    // MARK: - Init
    

    init(ID: Int!,
         status: Bool!,
         domainName: String!,
         isDefault: Bool!,
         creditAvailable: Int,
         statusKey: String,
         expirationDate: Date?,
         domainStem: String!) {
        
        super.init()
        
        self.ID = ID
        self.status = status
        self.domainName = domainName
        self.isDefault = isDefault
        self.creditAvailable = creditAvailable
        self.statusKey = statusKey
        self.expirationDate = expirationDate
        self.domainStem = domainStem
    }
    
    
    open func updatestatusKey(_ key: String!) {
        self.statusKey = key
    }
    
    
    open func isNational() -> Bool! {
        return !self.isNotNational()
    }
    
    
    open func isNotNational() -> Bool! {
        var nonNationalVP = false
        
        AuthService.sharedInstance.user.identities.forEach({ (identityModel: IdentityModel) in
            if (!nonNationalVP && self.ID == identityModel.ID) {
                nonNationalVP = true
            }
        })
        
        return nonNationalVP
    }
}
