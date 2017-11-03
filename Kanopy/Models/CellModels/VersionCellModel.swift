//
//  VersionCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 07.06.17.
//
//

import UIKit

class VersionCellModel: GenericCellModel {

    private(set) var versionValue: String = ""
    private(set) var buildTypeValue: String = ""
    
    
    // MARK: - Init method
    
    
    init(cellID: String, height: CGFloat!) {
        super.init(cellID, height: height)
        
        self.updateBuildTypeValue()
        self.updateVersionNumberValue()
    }
    
    
    // MARK: - Tools 
    
    
    private func updateVersionNumberValue() {
        self.versionValue = "VERSION".localized + " " + String.appVersionValue() + " (" + String.buildVersionValue() + ")"
    }
    
    
    private func updateBuildTypeValue() {
        self.buildTypeValue = String.buildTypeValue()
    }
}
