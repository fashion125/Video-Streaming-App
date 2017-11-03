//
//  Scenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit

class Scenario: NSObject {
    
    /** Start the current scenario. */
    func start() {
        assertionFailure("Must be implemented in subclasses")
    }
    
    /** Stop the current scenario. */
    func stop() {
        assertionFailure("Must be implemented in subclasses")
    }
}
