//
//  TextLinkModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 19.06.17.
//
//

import UIKit

class TextLinkModel: NSObject {

    private(set) var text: String! = ""
    private(set) var key: String! = ""
    private(set) var command: GeneralCommand!
    
    // MARK: - Init method
    
    
    init(text: String!, key: String!, command: GeneralCommand!) {
        super.init()
        
        self.text = text
        self.key = key
        self.command = command
    }
}
