//
//  ChooseItemSearchVCCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/11/17.
//
//

import UIKit

class ChooseItemSearchVCCommand: SearchVCCommand {

    override func execute(_ itemModel: ItemModel!) {
        self.delegate.didPressToItem(item: itemModel)
    }
}
