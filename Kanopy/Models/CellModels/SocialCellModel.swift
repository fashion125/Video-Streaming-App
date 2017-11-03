//
//  SocialCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class SocialCellModel: GenericCellModel {

    private(set) var googleCommand: AuthCommand!
    private(set) var faceBookCommand: AuthCommand!
    
    
    // MARK: - Init methods 
    
    
    init(googleCommand: AuthCommand!, faceBookCommand: AuthCommand!) {
        super.init(TableCellIDs.socialTableCell, height: 36.0)
        
        self.googleCommand = googleCommand
        self.faceBookCommand = faceBookCommand
    }
}
