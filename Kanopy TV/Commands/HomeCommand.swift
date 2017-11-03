//
//  HomeCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/20/17.
//
//

import UIKit

class HomeCommand: GeneralCommand {

    private(set) var delegate: HomeVCDelegate!
    
    // MARK: - Init method 
    
    init(delegate: HomeVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
}
