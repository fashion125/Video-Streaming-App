//
//  ShelfCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/3/17.
//
//

import UIKit

class ShelfCellModel: GenericCellModel {
    
    var shelf: ShelfModel!
    var currentCount: Int32 = 0
    private(set) var isCanDownload: Bool = true
    private(set) var offset: Int = 0
    
    var videoSecitons = [SectionModel]()

    private(set) var seeAllCommand: ShelfCommand!
    private(set) var chooseItemCommand: ShelfCommand!
    private(set) var loadItemsCommand: ShelfCommand!
    
    
    // MARK: - Init methods
    
    
    init(shelf: ShelfModel!,
         seeAllCommand: ShelfCommand!,
         chooseItemCommand: ShelfCommand,
         loadItemsCommand: ShelfCommand) {
        
        super.init(TableCellIDs.shelfCell, height: SizeStrategy.shelfCellHeight())
        
        self.shelf = shelf
        self.seeAllCommand = seeAllCommand
        self.chooseItemCommand = chooseItemCommand
        self.loadItemsCommand = loadItemsCommand
        self.updateContentOffset(CGPoint.init(x: -15.0, y: 0.0))
        
        self.isCanDownload = self.shelf.items.count >= Constants.shelfItemsLimit
        self.generateVideoCellModels()
        
    }
    
    
    // MARK: - Tools 
    
    
    func updateIsCanDownload(_ value: Bool!) {
        self.isCanDownload = value
    }
    
    
    func updateShelfItems(items: Array<ItemModel>!) {
        
        self.isCanDownload = self.shelf.items.count >= Constants.shelfItemsLimit
        self.shelf.insertItems(items: items)
        self.generateVideoCellModels()
    }
    
    
    private func generateVideoCellModels() {
        
        self.videoSecitons = [SectionModel]()
        var cellModels = [GenericCellModel]()
        
        
        for im in self.shelf.items {
            
            let icm = ItemCellModel.init(item: im, chooseItemActionBlock: { (item: ItemModel) in
                self.chooseItemCommand.execute(chooseItemWithItem: item)
            })
            
            cellModels.append(icm)
        }
        
        self.offset = self.shelf.items.count
        
        if (self.isCanDownload) {
            let loadCellModel = GenericCellModel.init(CollectionCellIDs.loadCell,
                                                      width: SizeStrategy.sizeItem().width,
                                                      height: SizeStrategy.sizeItem().height)
            cellModels.append(loadCellModel)
        }
        
        self.videoSecitons.append(SectionModel.init(cellModels: cellModels))
    }
    
    
    // MARK: - Actions 
    
    
    open func didPressSeeAllButton() {
        self.seeAllCommand.execute(seeMoreWithShelf: self.shelf)
    }
    
    
    open func needLoadItems() {
        if self.isCanDownload {
            self.isCanDownload = false
            self.loadItemsCommand.execute(loadItemsWithShelfCellModel: self, offset: self.offset)
        }
    }
}
