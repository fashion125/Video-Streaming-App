//
//  ChooseItemHomeCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/24/17.
//
//

import UIKit

class ChooseItemHomeCommand: HomeCommand {

    override func execute(_ itemModel: ItemModel!) {
        self.delegate.didPressToItem(item: itemModel)
    }
}
