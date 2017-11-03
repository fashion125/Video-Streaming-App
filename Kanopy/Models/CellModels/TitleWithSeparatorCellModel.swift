//
//  TitleWithSeparatorCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class TitleWithSeparatorCellModel: GenericCellModel {

    private(set) var titleValue: String! = ""
    
    
    // MARK: - Init methods
    
    
    init(titleValue: String!) {
        super.init(TableCellIDs.titleWithSeparatorTableCell, height: 44.0)
        
        self.titleValue = titleValue
    }
}
