//
//  TwoFieldsTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/3/17.
//
//

import UIKit

class TwoFieldsTableCell: GenericCell {


    @IBOutlet weak var firstContainer: UIView!
    @IBOutlet weak var secondContainer: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var firstPlaceholder: UILabel!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var secondPlaceholder: UILabel!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.firstContainer.layer.cornerRadius = 1.0
        self.secondContainer.layer.cornerRadius = 1.0
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: TextFieldCellModel = self.cellModel as! TextFieldCellModel
        
        self.iconImageView.image = cm.iconImage
        
        self.firstPlaceholder.text = cm.placeholder
        self.firstTextField.text = cm.value
        
        self.secondPlaceholder.text = cm.additionalPlaceholder
        self.secondTextField.text = cm.additionalValue
        
        self.firstTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.secondTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.updatePlaceholder()
    }
    
    
    func textFieldCM() -> TextFieldCellModel {
        return self.cellModel as! TextFieldCellModel
    }
    
    
    func textFieldDidChange(_ textField: UITextField) {
        
        if textField == self.firstTextField {
            self.textFieldCM().updateValue(textField.text)
        } else if textField == self.secondTextField {
            self.textFieldCM().updateAdditionalValue(textField.text)
        }
        
        self.updatePlaceholder()
    }
    
    
    func updatePlaceholder() {
        self.firstPlaceholder.isHidden = (self.firstTextField.text?.characters.count)! > 0
        self.secondPlaceholder.isHidden = (self.secondTextField.text?.characters.count)! > 0
    }
}
