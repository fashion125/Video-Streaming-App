//
//  RatingCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class RatingCellModel: GenericCellModel {

    private(set) var ratingCount: Int!
    private(set) var isHaveCaption: Bool!
    
    // MARK: - Init method 
    
    
    init(ratingCount: Int!, isHaveCaption: Bool!) {
        super.init(TableCellIDs.ratingTableCell, height: 100.0)
        
        self.ratingCount = ratingCount
        self.isHaveCaption = isHaveCaption
        self.isCanFocus = false
    }
}
