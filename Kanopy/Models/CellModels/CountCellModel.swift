//
//  CountCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/9/17.
//
//

import UIKit

class CountCellModel: GenericCellModel {

    private(set) var count: Int = 0
    
    init(count: Int!) {
        super.init(TableCellIDs.countTableCell, height: 50.0)
        
        self.count = count
    }
}
