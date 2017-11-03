//
//  ButtonCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class ButtonCellModel: GenericCellModel {

    private(set) var title: String! = ""
    private(set) var buttonCommand: GeneralCommand!
    private(set) var isUnderline: Bool = false
    
    private(set) var font: UIFont?
    private(set) var color: UIColor?
    var buttonWidth: CGFloat = UIScreen.main.bounds.width - 32.0
    
    
    // MARK: - Init methods 
    
    
    init(title: String!, buttonCommand: GeneralCommand!, cellID: String!) {
        
        super.init(cellID, height: 48.0)
        
        self.title = title
        self.buttonCommand = buttonCommand
    }
    
    
    init(title: String!, buttonCommand: GeneralCommand!, cellID: String!, height: CGFloat!) {
        
        super.init(cellID, height: height)
        
        self.title = title
        self.buttonCommand = buttonCommand
    }
    
    
    init(title: String!, font: UIFont!, color: UIColor!, buttonCommand: GeneralCommand!, cellID: String!, isUnderline: Bool!, height: CGFloat!) {
        
        super.init(cellID, height: height)
        
        self.title = title
        self.buttonCommand = buttonCommand
        self.font = font
        self.color = color
        self.isUnderline = isUnderline
    }
}
