//
//  WatchlistCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/9/17.
//
//

import UIKit

class WatchlistCommand: GeneralCommand {

    private(set) var delegate: WatchlistVCDelegate!
    
    // MARK: - Init method
    
    
    init(delegate: WatchlistVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
}
