//
//  ChooseItemCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/27/17.
//
//

import UIKit

class ChooseItemCellModel: GenericCellModel {

    private(set) var title: String! = ""
    private(set) var descriptionText: String! = ""
    private(set) var isCheck: Bool! = false
    private(set) var keyValue: String! = ""
    
    
    // MARK: - Init method
    
    
    init(title: String!, descriptionText: String!, isCheck: Bool!, keyValue: String!) {
        
        super.init(TableCellIDs.chooseItemTableCell, height: 64.0)
        
        self.title = title
        self.descriptionText = descriptionText
        self.isCheck = isCheck
        self.keyValue = keyValue
    }
}
