//
//  MyPlaylistItemCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 14.05.17.
//
//

import UIKit

class MyPlaylistItemCellModel: GenericCellModel {

    private(set) var item: ItemModel!
    private(set) var pressItemCommand: MyPlaylistChooseItemCommand!
    private(set) var menuCommand: OpenMenuCommand!
    
    // MARK: - Init method
    
    init(item: ItemModel!, pressItemCommand: MyPlaylistChooseItemCommand!, menuCommand: OpenMenuCommand!) {
        super.init(TableCellIDs.itemWithMenuTableCell, height: 81.0)
        
        self.item = item
        self.pressItemCommand = pressItemCommand
        self.menuCommand = menuCommand
    }
    
    
    // MARK: - Actions
    
    
    override func didSelect() {
        self.pressItemCommand.execute(cellModel: self)
    }
    
    
    func didPressToMenuButton() {
        self.menuCommand.execute(cellModel: self)
    }
}
