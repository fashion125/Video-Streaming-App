//
//  WatchNowLinkDeviceCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/18/17.
//
//

import UIKit

class WatchNowLinkDeviceCommand: LinkDeviceCommand {

    override func execute() {
        self.delegate.didPressWatchNow()
    }
}
