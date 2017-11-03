//
//  AdditionalPanelCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/12/17.
//
//

import UIKit

class AdditionalPanelCommand: GeneralCommand {

    private(set) var delegate: ContentVCDelegate!
    
    
    // MARK: - Init method 
    
    
    init(delegate: ContentVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
    
    override func execute() {
        self.delegate.didPressAddToWatchlistButton()
    }
}
