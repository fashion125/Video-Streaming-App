//
//  ValueCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class ValueCellModel: GenericCellModel {

    private(set) var valueText: String! = ""
    private(set) var titleText: String! = ""
    
    
    // MARK: - Init methods 
    
    
    init(valueText: String!, titleText: String!) {
        super.init(TableCellIDs.valueTableCell, height: 10.0)
        
        self.valueText = valueText
        self.titleText = titleText
        
        self.updateHeight(self.heightForText())
    }
    
    
    private func heightForText() -> CGFloat {
        let containerWidth = UIScreen.main.bounds.width - 1000.0
        
        let titlefont = UIFont.systemFont(ofSize: 29.0)
        let titleBounds = self.valueText.bounds(font: titlefont,
                                                containerWidth: containerWidth)
        
        return titleBounds.height + 8
    }
}
