//
//  ChooseItemHomeCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 05.05.17.
//
//

import UIKit

class ChooseItemHomeCommand: HomeCommand {

    override func execute(chooseItemWithItem item: ItemModel!) {
        self.delegate.didPressToItem(item: item)
    }
}
