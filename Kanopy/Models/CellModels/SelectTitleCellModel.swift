//
//  SelectTitleCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/25/17.
//
//

import UIKit

class SelectTitleCellModel: GenericCellModel {

    private(set) var titleText: String! = ""
    private(set) var descriptionText: String! = ""
    
    
    // MARK: - Init method 
    
    
    init(titleText: String!, descriptionText: String!, command: GeneralCommand!) {
        super.init(TableCellIDs.selectTitleTableCell, height: 64.0)
        
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.command = command
    }
}
