//
//  LoadItemsCategoryCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 05.05.17.
//
//

import UIKit

class LoadItemsCategoryCommand: CategoryCommand {

    override func execute(loadItemsWithShelfCellModel shelfCellModel: ShelfCellModel!, offset: Int!) {
        self.delegate.loadItemsOnCategoryScreen(shelfCellModel: shelfCellModel, offset: offset, categoryVC: self.categoryVC)
    }
}
