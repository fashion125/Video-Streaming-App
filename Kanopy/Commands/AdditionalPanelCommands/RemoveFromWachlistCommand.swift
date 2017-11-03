//
//  RemoveFromWachlistCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 25.05.17.
//
//

import UIKit

class RemoveFromWachlistCommand: GeneralCommand {

    private(set) var delegate: ContentVCDelegate!
    
    
    // MARK: - Init method
    
    
    init(delegate: ContentVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
    
    override func execute() {
        self.delegate.didPressRemoveFromWatchlistButton()
    }
}
