//
//  TextCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/7/17.
//
//

import UIKit

class TextCellModel: GenericCellModel {

    private(set) var textAttribute: NSAttributedString!
    
    // MARK: - init method 
    
    
    init(textAttribute: NSAttributedString!, height: CGFloat!) {
        super.init(TableCellIDs.textTableCell, height: height)
        
        self.textAttribute = textAttribute
    }
}
