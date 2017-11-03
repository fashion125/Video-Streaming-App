//
//  HomeVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/19/17.
//
//

import UIKit

class HomeVM: GenericVM {

    private(set) var shelves: [ShelfModel]!
    private(set) var categories: [CategoryModel]!
    private(set) var delegate: HomeVCDelegate!
    
    private(set) var topSections: [SectionModel]!
    private(set) var currentSelectedCategory: String!
    
    // MARK: - Init methods 
    
    
    init(shelves: [ShelfModel], categories: [CategoryModel], delegate: HomeVCDelegate!, currentSelectedCategory: String!) {
        super.init()
        
        self.delegate = delegate
        self.shelves = shelves
        self.categories = categories
        self.currentSelectedCategory = currentSelectedCategory
        
        self.topSections = [SectionModel]()
        self.sections = [SectionModel]()
        
        self.generateTopSections()
        self.generateSections()
    }
    
    
    func generateTopSections() {
        
        var cellModels = [CategoryCollectionCellModel]()
        
        for category in self.categories {
            let hc = ChooseCategoryCommand.init(delegate: self.delegate)
            let cm = CategoryCollectionCellModel.init(category: category, isSelected: false, command: hc)
            
            if category.termID == self.currentSelectedCategory {
                cm.updateIsSelected(isSelected: true)
            }
            
            cellModels.append(cm)
        }
        
        self.topSections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    func generateSections() {
        
        var cellModels = [GenericCellModel]()
        
        for shelf in self.shelves {
            let loadCommand = LoadShelfItemHomeCommand.init(delegate: self.delegate)
            cellModels.append(ShelfCellModel.init(shelf: shelf, loadCommand: loadCommand, delegate: self.delegate))
        }
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
}
