//
//  MembershipInfoVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

class MembershipInfoVM: NSObject {

    private(set) var delegate: MembershipInfoVCDelegate!
    
    private(set) var userNameValue: String!
    private(set) var membershipValue: String!
    private(set) var statusValue: String!
    private(set) var statusColorValue: UIColor!
    
    
    // MARK: - Init methods 
    
    
    init(delegate: MembershipInfoVCDelegate!) {
        super.init()
        
        self.delegate = delegate
        
        self.generateInfo()
    }
    
    
    // MARK: -
    
    
    private func generateInfo() {
        self.userNameValue = AuthService.sharedInstance.user.username
        self.membershipValue = AuthService.sharedInstance.user.currentIdentity?.domainName
        self.statusValue = AuthService.sharedInstance.user.currentIdentity?.statusKey
        
        self.updateStatusPointViewColor()
    }
    
    
    func updateStatusPointViewColor() {
        
        if ((AuthService.sharedInstance.user.currentIdentity?.isNotNational())!) {
            if AuthService.sharedInstance.user.currentIdentity?.statusKey == "active" {
                self.statusColorValue = UIColor.membershipGreenColor()
            } else {
                self.statusColorValue = UIColor.membershipRedColor()
            }
        } else {
            self.statusColorValue = UIColor.white
        }
    }
}
