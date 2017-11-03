//
//  LoadItemsHomeCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 05.05.17.
//
//

import UIKit

class LoadItemsHomeCommand: HomeCommand {

    override func execute(loadItemsWithShelfCellModel shelfCellModel: ShelfCellModel!, offset: Int!) {
        self.delegate.loadItems(shelfCellModel: shelfCellModel, offset: offset)
    }
}
