//
//  IdentityCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

class IdentityCellModel: GenericCellModel {

    private(set) var identity: IdentityModel!
    private(set) var title: String!
    private(set) var viewModel: MembershipCellVM!
    
    
    // MARK: - Init method 
    
    
    init(identity: IdentityModel!, cellID: String!, height: CGFloat!, title: String!, command: GeneralCommand!, viewModel: MembershipCellVM!) {
        super.init(cellID, height: height)
        
        self.identity = identity
        self.title = title
        self.command = command
        self.viewModel = viewModel
    }
    
    
    override func didSelect() {
        let command = self.command as! MembershipCommand
        command.execute(identity: self.identity)
    }
}
