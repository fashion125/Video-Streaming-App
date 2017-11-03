//
//  SubjectsVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/31/17.
//
//

import UIKit

class SubjectsVM: GenericVM {

    private(set) var delegate: SubjectsVCDelegate!
    private(set) var items: Array<CategoryModel>!
    
    
    // MARK: - Init methods 
    
    
    init(delegate: SubjectsVCDelegate!, items: Array<CategoryModel>!) {
        super.init()
        
        self.delegate = delegate
        self.items = items
        
        self.generateSubjectsSection()
    }
    
    
    // MARK: - Tools 
    
    
    private func generateSubjectsSection() {
        
        var cellModels = [GenericCellModel]()
        
        cellModels.append(self.marginTVCellModel(140.0))
        
        for cm in self.items {
            let cmd = ChooseCategorySubjectsCommand.init(delegate: self.delegate)
            let cm = CategoryCellModel.init(category: cm, chooseCommand: cmd)
            cellModels.append(cm)
        }
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
}
