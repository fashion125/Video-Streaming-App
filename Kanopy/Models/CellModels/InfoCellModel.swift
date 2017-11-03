//
//  InfoCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/17/17.
//
//

import UIKit

class InfoCellModel: GenericCellModel {

    private(set) var title: String!
    private(set) var value: String!
    
    
    // MARK: - Init methods 
    
    
    init(title: String!, value: String!) {
        super.init(TableCellIDs.infoCell, height: 20.0)
        
        self.title = title
        self.value = value
    }
    
    
    init(title: String!, value: String!, height: CGFloat!) {
        super.init(TableCellIDs.infoCell, height: height)
        
        self.title = title
        self.value = value
    }
    
    
    init(title: String!, value: String!, cellID: String!, height: CGFloat!) {
        super.init(cellID, height: height)
        
        self.title = title
        self.value = value
    }
}
