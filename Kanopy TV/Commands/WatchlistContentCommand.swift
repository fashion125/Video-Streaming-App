//
//  WatchlistContentCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class WatchlistContentCommand: ContentCommand {

    override func execute() {
        self.delegate.didPressToWatchlistButton()
    }
}
