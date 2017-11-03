//
//  SeeMoreCategoryCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 05.05.17.
//
//

import UIKit

class SeeMoreCategoryCommand: CategoryCommand {

    override func execute(seeMoreWithShelf shelf: ShelfModel!) {
        self.delegate.didPressToAllSeeButtonOnCategoryScreen(shelf: shelf, categoryVC: self.categoryVC)
    }
}
