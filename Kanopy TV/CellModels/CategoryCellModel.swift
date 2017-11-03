//
//  CategoryCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/31/17.
//
//

import UIKit

class CategoryCellModel: GenericCellModel {

    private(set) var category: CategoryModel!
    
    // MARK: - Init methods 
    
    
    init(category: CategoryModel!, chooseCommand: GeneralCommand!) {
        super.init(TableCellIDs.categoryTableCell, height: 80.0)
        
        self.category = category
        self.command = chooseCommand
    }
    
    
    override func didSelect() {
        let cm = self.command as! ChooseCategorySubjectsCommand
        cm.execute(categoryModel: self.category)
    }
}
