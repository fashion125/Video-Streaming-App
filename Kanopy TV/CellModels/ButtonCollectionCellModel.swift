//
//  ButtonCollectionCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class ButtonCollectionCellModel: GenericCellModel {

    private(set) var title: String! = ""
    private(set) var iconName: String! = ""
    
    
    // MARK: - Init methods 
    
    
    init(title: String!, iconName: String!, command: GeneralCommand!) {
        super.init(CollectionCellIDs.buttonCollectionCell, width: 157, height: 150)
        
        self.title = title
        self.iconName = iconName
        self.command = command
    }
    
    
    override func didSelect() {
        self.command?.execute()
    }
}
