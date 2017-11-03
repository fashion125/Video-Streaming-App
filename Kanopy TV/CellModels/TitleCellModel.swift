//
//  TitleCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/9/17.
//
//

import UIKit

class TitleCellModel: GenericCellModel {

    private(set) var title: String! = ""
    
    
    // MARK: - Init method 
    
    
    init(title: String!) {
        super.init(CollectionCellIDs.titleCollectionCell, width: UIScreen.main.bounds.width, height: 0.0)
        
        self.isCanFocus = false
        
        self.title = title
    }
}
