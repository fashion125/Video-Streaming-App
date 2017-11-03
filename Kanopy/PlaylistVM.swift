//
//  PlaylistVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/27/17.
//
//

import UIKit

protocol PlaylistVMDelegate {
}

class PlaylistVM: GenericVM {

    private(set) var playlistModel: PlaylistModel!
    private(set) var items: Array<ItemModel> = [ItemModel]()
    
    private(set) var menuSections: Array<SectionModel> = [SectionModel]()
    private(set) var itemsSection: SectionModel!
    
    var isCanDownload: Bool = false
    var offset: Int = 0
    
    var delegate: PlaylistVCDelegate!
    
    
    // MARK: - Init methods 
    
    
    init(playlistModel: PlaylistModel!, items: Array<ItemModel>!, delegate: PlaylistVCDelegate!) {
        super.init()
        
        self.delegate = delegate
        self.playlistModel = playlistModel
        self.items = items
        
        self.genericSections()
    }
    
    
    // MARK: -
    
    
    func genericSections() {
        
        //self.addHeaderSection()
        self.addItemsSection()
    }
    
    
    func addHeaderSection() {
        
        let headerCellModel = HeaderCellModel.init(name: self.playlistModel.titleValue,
                                                   cellID: TableCellIDs.myPlaylistHeaderCell,
                                                   height: self.heightForHeaderCell())
        
        self.sections.append(SectionModel.init(cellModels: [headerCellModel]))
    }
    
    
    func addItemsSection() {
        
        let isNeedLoadCell = items.count >= Constants.itemsLimit
        self.offset = self.items.count
        
        var cellModels = [GenericCellModel]()
        
        for it in self.items {
            
            let pic = MyPlaylistChooseItemCommand.init(delegate: self.delegate)
            let omc = OpenMenuCommand.init(delegate: self.delegate)
            
            let licm = MyPlaylistItemCellModel.init(item: it,
                                                    pressItemCommand: pic,
                                                    menuCommand: omc)
            
            
            
            cellModels.append(licm)
        }
        
        if isNeedLoadCell {
            cellModels.append(GenericCellModel.init(TableCellIDs.loadTableCell, height: 80.0))
        }
        
        self.itemsSection = SectionModel.init(cellModels: cellModels)
        self.sections.append(self.itemsSection)
        self.checkIsCanDownload(self.items.count)
    }
    
    
    private func heightForHeaderCell() -> CGFloat {
        
        let containerWidth = UIScreen.main.bounds.width - 30.0
        
        let titlefont = UIFont.init(name: "AvenirNextLTPro-Medium", size: 24)
        let titleHeight = self.playlistModel.titleValue.height(font: titlefont,
                                                 containerWidth: containerWidth)
        
        return titleHeight + 30.0
    }
    
    
    // MARK: - Pagintaion methods 
    
    
    open func insertItems(items: Array<ItemModel>) {
        
        let isNeedLoadCell = items.count >= Constants.itemsLimit
        
        self.items.append(contentsOf: items)
        self.offset = self.items.count
        
        var cellModels = [GenericCellModel]()
        var oldCells = self.itemsSection.cellModels
        oldCells.removeLast()
        cellModels.append(contentsOf: oldCells)
        
        for it in items {
            
            let pic = MyPlaylistChooseItemCommand.init(delegate: self.delegate)
            let omc = OpenMenuCommand.init(delegate: self.delegate)
            
            let licm = MyPlaylistItemCellModel.init(item: it,
                                                    pressItemCommand: pic,
                                                    menuCommand: omc)
            
            
            
            cellModels.append(licm)
        }
        
        if isNeedLoadCell {
            cellModels.append(GenericCellModel.init(TableCellIDs.loadTableCell, height: 80.0))
        }
        
        self.itemsSection.updateCellModels(cellModels: cellModels)
        self.checkIsCanDownload(items.count)
    }
    
    
    func checkIsCanDownload(_ count: Int) {
        self.isCanDownload = count >= Constants.itemsLimit
    }
    
    
    // MARK: - Remove methods 
    
    
    func removeItem(cellModel: MyPlaylistItemCellModel!) {
        let ip = self.indexPath(cellModel: cellModel)
        self.removeCellModel(indexPath: ip)
        let index = self.items.index(of: cellModel.item)
        self.items.remove(at: index!)
        
        self.offset = self.offset - 1
        
        self.playlistModel.removeItem()
    }
}
