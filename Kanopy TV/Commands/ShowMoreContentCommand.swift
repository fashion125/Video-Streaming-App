//
//  ShowMoreContentCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class ShowMoreContentCommand: ContentCommand {

    override func execute() {
        self.delegate.didPressShowMoreButton()
    }
}
