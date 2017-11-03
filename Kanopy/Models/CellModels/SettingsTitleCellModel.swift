//
//  SettingsTitleCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/25/17.
//
//

import UIKit

class SettingsTitleCellModel: GenericCellModel {

    private(set) var titleText: String! = ""
    
    // MARK: - Init method 
    
    
    init(titleText: String!, command: GeneralCommand!) {
        super.init(TableCellIDs.settingsTitleTableCell, height: 50.0)
        
        self.titleText = titleText
        self.command = command
    }
}
