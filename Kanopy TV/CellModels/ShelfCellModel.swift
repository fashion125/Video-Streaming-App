//
//  ShelfCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/19/17.
//
//

import UIKit

class ShelfCellModel: GenericCellModel {

    private(set) var shelf: ShelfModel!
    private(set) var sections: [SectionModel]!
    private(set) var loadCommand: LoadShelfItemHomeCommand!
    private(set) var isCanDownload: Bool = true
    private(set) var offset: Int = 0
    private(set) var cellDelegate: HomeVCDelegate!
    
    // MARK: - Init method
    
    
    init(shelf: ShelfModel!, loadCommand: LoadShelfItemHomeCommand, delegate: HomeVCDelegate!) {
        super.init(TableCellIDs.shelfTableCellTV, height: 350.0)
        
        self.isCanFocus = false
        
        self.cellDelegate = delegate
        self.shelf = shelf
        self.loadCommand = loadCommand
        self.updateContentOffset(CGPoint.init(x: -50.0, y: 0.0))
        self.sections = [SectionModel]()
        self.generateVideoCellModels()
    }
    
    
    private func generateSections() {
        
        var cellModels = [GenericCellModel]()
        
        for item in self.shelf.items {
            let cm = ChooseItemHomeCommand.init(delegate: self.cellDelegate)
            cellModels.append(ItemCellModel.init(item: item, chooseItemCommand: cm))
        }
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    // MARK: - Open methods 
    
    
    open func loadItems() {
        if self.isCanDownload {
            self.isCanDownload = false
            self.loadCommand.execute(shelfModel: self)
        }
    }
    
    
    func updateShelfItems(items: Array<ItemModel>!) {
        
        self.isCanDownload = self.shelf.items.count >= Constants.shelfItemsLimit
        self.shelf.insertItems(items: items)
        self.generateVideoCellModels()
    }
    
    
    private func generateVideoCellModels() {
        
        self.sections = [SectionModel]()
        
        var cellModels = [GenericCellModel]()
        
        for item in self.shelf.items {
            let cm = ChooseItemHomeCommand.init(delegate: self.cellDelegate)
            cellModels.append(ItemCellModel.init(item: item, chooseItemCommand: cm))
        }
        
        self.sections.append(SectionModel.init(cellModels: cellModels))
        
        self.offset = self.shelf.items.count
    }
}
