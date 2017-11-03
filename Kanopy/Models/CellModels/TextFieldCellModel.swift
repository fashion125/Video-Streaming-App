//
//  TextFieldCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class TextFieldCellModel: GenericCellModel {

    private(set) var placeholder: String! = ""
    private(set) var value: String! = ""
    private(set) var iconImage: UIImage!
    private(set) var isSecretField: Bool = false
    
    private(set) var additionalPlaceholder: String? = ""
    private(set) var additionalValue: String? = ""
    private(set) var returnClickedCommand: GeneralCommand? = nil
    
    
    // MARK: - Init methods 
    
    
    init(placeholder: String!, value: String!, iconImage: UIImage!, isSecretField: Bool) {
        
        super.init(TableCellIDs.textFieldTableCell, height: 40.0)
        
        self.placeholder = placeholder
        self.value = value
        self.iconImage = iconImage
        self.isSecretField = isSecretField
    }
    
    
    init(placeholder: String!, value: String!, iconImage: UIImage!, isSecretField: Bool, returnClickedCommand: GeneralCommand) {
        
        super.init(TableCellIDs.textFieldTableCell, height: 40.0)
        
        self.placeholder = placeholder
        self.value = value
        self.iconImage = iconImage
        self.isSecretField = isSecretField
        self.returnClickedCommand = returnClickedCommand
    }
    
    
    init(firstPlaceholder: String!, firstValue: String!, secondPlaceholder: String!, secondValue: String!, iconImage: UIImage!) {
        
        super.init(TableCellIDs.twoFieldsTableCell, height: 40.0)
        
        self.placeholder = firstPlaceholder
        self.value = firstValue
        
        self.additionalPlaceholder = secondPlaceholder
        self.additionalValue = secondValue
        
        self.iconImage = iconImage
        
        self.isSecretField = false
    }
    
    
    func updateReturnClickedCommand(returnClickedCommand: GeneralCommand!) {
        self.returnClickedCommand = returnClickedCommand
    }
    
    
    func updateValue(_ newValue: String!) {
        self.value = newValue
    }
    
    
    func updateAdditionalValue(_ newValue: String!) {
        self.additionalValue = newValue
    }
}
