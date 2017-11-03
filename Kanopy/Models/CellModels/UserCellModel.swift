//
//  UserCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

class UserCellModel: MenuCellModel {

    private(set) var user: UserModel!
    
    // MARK: - Init method 
    
    
    init(user: UserModel!, command: MenuCommand!) {
        
        super.init(TableCellIDs.userMenuTableCell, height: 94.0, key: MenuActionKey.userKey)
        
        self.user = user
        self.command = command
    }
    
    
    init(user: UserModel!, command: MenuCommand!, cellID: String!, height: CGFloat!) {
        super.init(cellID, height: height, key: MenuActionKey.userKey)
        
        self.user = user
        self.command = command
    }
}
