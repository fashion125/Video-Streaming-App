//
//  SeeMoreHomeCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 05.05.17.
//
//

import UIKit

class SeeMoreHomeCommand: HomeCommand {

    override func execute(seeMoreWithShelf shelf: ShelfModel!) {
        self.delegate.didPressToAllSeeButton(shelf: shelf)
    }
}
