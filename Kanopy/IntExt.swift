//
//  IntExt.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 22/06/2017.
//
//

import Foundation

extension Int {
    var stringValue:String {
        return "\(self)"
    }
}

extension Float {
    
    var checkForNegative: Float {
        if self < 0 {
            return 0.0
        } else {
            return self
        }
    }
}
