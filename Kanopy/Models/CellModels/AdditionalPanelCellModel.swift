//
//  AdditionalPanelCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/12/17.
//
//

import UIKit

class AdditionalPanelCellModel: GenericCellModel {
    
    private(set) var titleText: String! = ""
    private(set) var iconName: String! = ""
    
    
    // MARK: - Init method
    
    
    init(command: GeneralCommand!, titleText: String!, iconName: String!) {
        super.init(TableCellIDs.additionalPanelTableCell, height: 30.0)
        
        self.command = command
        self.titleText = titleText
        self.iconName = iconName
    }
}
