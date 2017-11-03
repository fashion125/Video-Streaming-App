//
//  LinkDeviceVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/15/17.
//
//

import UIKit

class LinkDeviceVM: NSObject {

    private(set) var iconImage: String!
    private(set) var title: String!
    private(set) var descriptionText: String!
    private(set) var buttonTitle: String!
    private(set) var buttonIsEnabled: Bool!
    private(set) var authCode: String?
    private(set) var command: LinkDeviceCommand!
    
    
    // MARK: - Init methods 
    
    
    init(iconImage: String!, title: String!, descriptionText: String!, buttonTitle: String!, command: LinkDeviceCommand, authCode: String?, buttonIsEnabled: Bool!) {
        
        super.init()
        
        self.iconImage = iconImage
        self.title = title
        self.descriptionText = descriptionText
        self.buttonTitle = buttonTitle
        self.authCode = authCode
        self.command = command
        self.buttonIsEnabled = buttonIsEnabled
    }
}
