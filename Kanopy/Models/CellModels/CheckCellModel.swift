//
//  CheckCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/9/17.
//
//

import UIKit

class CheckCellModel: GenericCellModel {

    private(set) var isCheck: Bool = false
    private(set) var isNext: Bool = false
    private(set) var title: String! = ""
    private(set) var descriptionText: String! = ""
    
    private(set) var buttonCommand: GeneralCommand! = nil
    private(set) var isUnderline: Bool = false
    
    
    // MARK: - Init 
    
    
    init(isCheck: Bool!, isNext: Bool!, title: String!, descriptionText: String!, height: CGFloat!) {
        super.init(TableCellIDs.checkTableCell, height: height)
        
        self.isCheck = isCheck
        self.title = title
        self.descriptionText = descriptionText
        self.isNext = isNext
    }
    
    
    init(isCheck: Bool!, isNext: Bool!, title: String!, descriptionText: String!, height: CGFloat!, buttonCommand: GeneralCommand!, isUnderline: Bool!) {
        super.init(TableCellIDs.checkTableCell, height: height)
        
        self.isCheck = isCheck
        self.title = title
        self.descriptionText = descriptionText
        self.isNext = isNext
        
        self.buttonCommand = buttonCommand
        self.isUnderline = isUnderline
    }
}
