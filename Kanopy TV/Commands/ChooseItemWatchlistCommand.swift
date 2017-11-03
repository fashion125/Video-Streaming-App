//
//  ChooseItemWatchlistCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/9/17.
//
//

import UIKit

class ChooseItemWatchlistCommand: WatchlistCommand {

    override func execute(_ itemModel: ItemModel!) {
        self.delegate.didPressToItem(item: itemModel)
    }
}
