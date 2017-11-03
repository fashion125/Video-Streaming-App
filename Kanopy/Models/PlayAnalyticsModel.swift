//
//  PlayAnalyticsModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 18.05.17.
//
//

import UIKit

class PlayAnalyticsModel: NSObject {

    private(set) var currentPosition: Int! = 0
    
    // MARK: - Init method 
    
    
    init(currentPosition: Int!) {
        super.init()
        
        self.currentPosition = currentPosition
    }
}
