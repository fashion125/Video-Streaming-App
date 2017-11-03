//
//  ChooseItemContentCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/24/17.
//
//

import UIKit

class ChooseItemContentCommand: ContentCommand {

    override func execute(_ itemModel: ItemModel!) {
        self.delegate.didPressToItem(itemModel: itemModel)
    }
}
