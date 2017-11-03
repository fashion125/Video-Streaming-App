//
//  ValidateRokuCode.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 01/06/2017.
//
//

import UIKit

class ValidateRokuCode: GeneralCommand {
    var delegate: LinkYourRokuVCDelegate!
    var textFieldCellModel: TextFieldCellModel!
    
    // MARK: - Init method
    
    
    init(delegate: LinkYourRokuVCDelegate!, textFieldCellModel: TextFieldCellModel!) {
        super.init()
        
        self.delegate = delegate
        self.textFieldCellModel = textFieldCellModel
    }
    
    override func execute() {
        self.delegate.didValidCodeRoku(code: textFieldCellModel.value)
    }
}
