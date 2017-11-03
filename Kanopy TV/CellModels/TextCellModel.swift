//
//  TextCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class TextCellModel: GenericCellModel {

    private(set) var text: String! = ""
    private(set) var font: UIFont!
    private(set) var color: UIColor!
    
    
    // MARK: - Init methods 
    
    
    init(text: String!, font: UIFont!, color: UIColor!) {
        super.init(TableCellIDs.textTableCell, height: 100)
        
        self.text = text
        self.font = font
        self.color = color
        self.updateHeight(self.heightForText())
    }
    
    
    private func heightForText() -> CGFloat {
        let containerWidth = UIScreen.main.bounds.width - 836.0
        
        let titlefont = self.font
        let titleBounds = self.text.bounds(font: titlefont,
                                       containerWidth: containerWidth)
        
        return titleBounds.height
    }
}
