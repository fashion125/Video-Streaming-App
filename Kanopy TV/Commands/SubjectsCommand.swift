//
//  SubjectsCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/31/17.
//
//

import UIKit

class SubjectsCommand: GeneralCommand {

    private(set) var delegate: SubjectsVCDelegate!
    
    // MARK: - Init method 
    
    
    init(delegate: SubjectsVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
}
