//
//  LoadShelfItemHomeCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/20/17.
//
//

import UIKit

class LoadShelfItemHomeCommand: HomeCommand {

    func execute(shelfModel: ShelfCellModel!) {
        self.delegate.loadItemForShelf(shelfCM: shelfModel)
    }
}
