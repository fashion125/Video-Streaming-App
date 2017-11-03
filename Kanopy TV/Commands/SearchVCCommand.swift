//
//  SearchVCCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/11/17.
//
//

import UIKit

class SearchVCCommand: GeneralCommand {

    private(set) var delegate: SearchVCDelegate!
    
    // MARK: - Init methods
    
    
    init(delegate: SearchVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
}
