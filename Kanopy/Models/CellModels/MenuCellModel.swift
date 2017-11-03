//
//  MenuCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/8/17.
//
//

import UIKit

class MenuCellModel: GenericCellModel {
    
    private(set) var title: String! = ""
    private(set) var key: String! = ""
    private(set) var isShowBottomSeparator = false
    
    private(set) var isEnableSelected: Bool = true
    
    
    // MARK: - Init methods 
    
    
    init(title: String!, isSelected: Bool!, command: MenuCommand!, key: String!) {
        
        super.init(TableCellIDs.menuCell, height: 50.0)
        
        self.key = key
        self.title = title
        self.isSelected = isSelected
        self.command = command
    }
    
    
    init(_ cellID: String!, height: CGFloat!, key: String!) {
        super.init(cellID, height: height)
        
        self.key = key
        self.title = ""
        self.isSelected = false
    }
    
    
    // MARK: -
    
    
    open func updateSelectedValue(newSelectedValue: Bool!) {
        self.isSelected = newSelectedValue
    }
    
    
    open func updateShowSeparator(newShowSeparatorValue: Bool) {
        self.isShowBottomSeparator = newShowSeparatorValue
    }
    
    
    open func updateEnableSelected(newIsEnableSelectedValue: Bool) {
        self.isEnableSelected = newIsEnableSelectedValue
    }
    
    
    override func didSelect() {
        self.command?.execute()
    }
}
