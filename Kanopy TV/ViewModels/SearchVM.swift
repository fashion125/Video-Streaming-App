//
//  SearchVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/11/17.
//
//

import UIKit

class SearchVM: GenericVM {

    private(set) var titleText: String!
    private(set) var items: Array<ItemModel>!
    private(set) var delegate: SearchVCDelegate!
    
    var isCanDownload: Bool = true
    
    
    // MARK: - Init methods 
    
    
    init(title: String!, items: Array<ItemModel>!, delegate: SearchVCDelegate!) {
        super.init()
        
        self.delegate = delegate
        self.titleText = title
        self.items = items
        
        self.generateSections()
    }
    
    
    // MARK: - 
    
    
    private func generateSections() {
        
        var cellModels = [GenericCellModel]()
        
        for item in self.items {
            let cmd = ChooseItemSearchVCCommand.init(delegate: self.delegate)
            let cm = ItemCellModel.init(item: item,
                                        chooseItemCommand: cmd,
                                        cellID: CollectionCellIDs.videoCollectionCell,
                                        width: 376, height: 224,
                                        focusWidth: 456, focusHeight: 276)
            
            cellModels.append(cm)
        }
        
        let sm = SectionModel.init(cellModels: cellModels)
        sm.sectionLineSpacing = 80.0
        
        self.sections.append(sm)
    }
}
