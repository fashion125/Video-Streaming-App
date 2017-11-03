//
//  SortItemCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/10/17.
//
//

import UIKit

class SortItemCellModel: GenericCellModel {
    
    private(set) var title: String! = ""
    private(set) var actionKey: String! = ""
    private(set) var isSelectedType: Bool! = false
    
    // MARK: - Init methods 
    
    init(title: String!, actionKey: String!, isSelected: Bool!) {
        super.init(TableCellIDs.sortItemCell, height: 46.0)
        
        self.title = title
        self.actionKey = actionKey
        self.isSelectedType = isSelected
    }
    
    
    open func updateSelectedType(newSelectedType: Bool!) {
        self.isSelectedType = newSelectedType
    }
}
