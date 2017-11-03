//
//  VideoQualityModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

class VideoQualityModel: NSObject {

    private(set) var title: String!
    private(set) var descriptionText: String!
    private(set) var keyValue: String!
    
    
    // MARK: - Init method
    
    
    init(titleValue: String!, descriptionTextValue: String!, keyValue: String!) {
        super.init()
        
        self.title = titleValue
        self.descriptionText = descriptionTextValue
        self.keyValue = keyValue
    }
}
