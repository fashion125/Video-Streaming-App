//
//  ChooseItemCategoryCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 05.05.17.
//
//

import UIKit

class ChooseItemCategoryCommand: CategoryCommand {

    override func execute(chooseItemWithItem item: ItemModel!) {
        self.delegate.didPressToItemOnCategoryScreen(item: item, categoryVC: self.categoryVC)
    }

}
