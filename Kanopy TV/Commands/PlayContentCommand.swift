//
//  PlayContentCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class PlayContentCommand: ContentCommand {

    override func execute() {
        self.delegate.didPressToPlayButton()
    }
}
