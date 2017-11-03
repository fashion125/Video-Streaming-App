//
//  IdentityCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

class IdentityCellModel: GenericCellModel {

    private(set) var identity: IdentityModel!
    private(set) var statusColorValue: UIColor!
    
    // MARK: - Init method 
    
    
    init(identity: IdentityModel!, command: GeneralCommand!) {
        super.init(TableCellIDs.identityTableCell, height: 72.0)
        
        self.identity = identity
        self.command = command
        self.updateStatusPointViewColor()
    }
    
    
    func updateStatusPointViewColor() {
        
        if ((self.identity.isNotNational())!) {
            if self.identity.statusKey == "active" {
                self.statusColorValue = UIColor.membershipGreenColor()
            } else {
                self.statusColorValue = UIColor.membershipRedColor()
            }
        } else {
            self.statusColorValue = UIColor.white
        }
    }
    
    
    override func didSelect() {
        let ccmd: ChooseMembershipCommand = self.command as! ChooseMembershipCommand
        ccmd.execute(identity: self.identity)
    }
}
