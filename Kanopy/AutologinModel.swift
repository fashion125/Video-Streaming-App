//
//  AutologinModel.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 16/05/2017.
//
//

import UIKit

class AutologinModel: NSObject {
    
    private(set) var url: String? = ""
    
    
    // MARK: - Init method
    
    
    init(url: String?) {
        super.init()
        
        self.url = url
    }
}
