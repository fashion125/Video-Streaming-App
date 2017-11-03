//
//  HomeCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 05.05.17.
//
//

import UIKit

class HomeCommand: ShelfCommand {

    private(set) var delegate: HomeVCDelegate!
    
    
    // MARK: - Init methods 
    
    init(delegate: HomeVCDelegate) {
        super.init()
        
        self.delegate = delegate
    }
}
