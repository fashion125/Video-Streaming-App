//
//  SwitcherCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/25/17.
//
//

import UIKit

class SwitcherCellModel: GenericCellModel {

    private(set) var titleText: String! = ""
    private(set) var descriptionText: String! = ""
    private(set) var value: Bool! = false
    
    
    // MARK: - Init method 
    
    
    init(titleText: String!,
         descriptionText: String!,
         value: Bool!,
         command: GeneralCommand!)
    {
        super.init(TableCellIDs.switcherTableCell, height: 50.0)
        
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.value = value
        self.command = command
    }
    
    
    /** This method update bool value */
    open func updateValue(newValue: Bool!) {
        self.value = newValue
    }
}
