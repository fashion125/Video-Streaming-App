//
//  CategoryVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/9/17.
//
//

import UIKit

protocol CategoryVMDelegate {
    
    /** Method is call when user tap to 'See More' button on the cell */
    func didPressToSeeAllButton(shelf: ShelfModel!, categoryViewModel: CategoryVM!)
    
    /** Method is call when user tap to item */
    func didChooseItem(item: ItemModel!, categoryViewModel: CategoryVM!)
}

class CategoryVM: GenericVM {
    
    open var delegate: CategoryVCDelegate!
    
    private(set) var shelves: Array<ShelfModel> = [ShelfModel]()
    private(set) var currentCategory: CategoryModel!
    private(set) var currentVC: CategoryVC!
    
    init(shelves: Array<ShelfModel>, delegate: CategoryVCDelegate!, category: CategoryModel!, currentVC: CategoryVC!) {
        
        super.init()
        
        self.shelves = shelves
        self.delegate = delegate
        self.currentCategory = category
        self.currentVC = currentVC
        
        self.generateSections()
    }
    
    
    private func generateSections() {
        
        var cellModels = [ShelfCellModel]()
        
        for shelf in self.shelves {
            
            cellModels.append(self.shelfCellModel(shelf))
        }
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    func shelfCellModel(_ shelf: ShelfModel!) -> ShelfCellModel {
        
        let seeAllCommand = SeeMoreCategoryCommand.init(delegate: self.delegate, categoryVC: self.currentVC)
        let chooseItemCommand = ChooseItemCategoryCommand.init(delegate: self.delegate, categoryVC: self.currentVC)
        let loadItemsCommand = LoadItemsCategoryCommand.init(delegate: self.delegate, categoryVC: self.currentVC)
        
        let shelfCM = ShelfCellModel.init(shelf: shelf,
                                          seeAllCommand: seeAllCommand,
                                          chooseItemCommand: chooseItemCommand,
                                          loadItemsCommand: loadItemsCommand)
        
        return shelfCM
    }
}
