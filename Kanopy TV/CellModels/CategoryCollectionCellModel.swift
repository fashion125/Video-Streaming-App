//
//  CategoryCollectionCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/19/17.
//
//

import UIKit

class CategoryCollectionCellModel: GenericCellModel {

    private(set) var category: CategoryModel!
    private(set) var chooseCommand: HomeCommand!
    
    
    // MARK: - Init method
    
    
    init(category: CategoryModel!, isSelected: Bool, command: HomeCommand!) {
        super.init(CollectionCellIDs.categoryCollectionCell, width: 248, height: 100)
        
        self.category = category
        self.isSelected = isSelected
        self.chooseCommand = command
    }
    
    
    open func updateIsSelected(isSelected: Bool!) {
        self.isSelected = isSelected
    }
    
    
    override func didSelect() {
        let cm = self.chooseCommand as! ChooseCategoryCommand
        cm.execute(category: self.category)
    }
}
