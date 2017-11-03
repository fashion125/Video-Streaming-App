//
//  TitleCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/12/17.
//
//

import UIKit

class TitleCellModel: GenericCellModel {
    
    var titleValue: String!
    
    
    // MARK: - Init methods 
    
    
    init(titleValue: String!) {
        
        super.init(TableCellIDs.titleCell, height: 47.0)
        
        self.titleValue = titleValue
    }
    
    
    init(titleValue: String!, cellID: String!, height: CGFloat!) {
        super.init(cellID, height: height)
        
        self.titleValue = titleValue
    }
}
