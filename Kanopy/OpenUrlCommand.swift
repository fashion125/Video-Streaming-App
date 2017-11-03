//
//  OpenUrlCommand.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 02/06/2017.
//
//

import UIKit

class OpenUrlCommand: GeneralCommand {
    var url: String!
    
    // MARK: - Init method
    
    
    init(url: String!) {
        super.init()
        
        self.url = url
    }
    
    
    override func execute() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(NSURL(string: self.url)! as URL)
        } else {
            UIApplication.shared.openURL(URL(string: self.url)!)
        }
    }
}
