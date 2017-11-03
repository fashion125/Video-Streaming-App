//
//  TextFieldTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class TextFieldTableCell: GenericCell, UITextFieldDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerView.layer.cornerRadius = 1.0
    }

    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.iconImageView.image = self.textFieldCM().iconImage
        self.textField.text = self.textFieldCM().value
        self.textField.isSecureTextEntry = self.textFieldCM().isSecretField
        self.textField.delegate = self;
        self.placeholderLabel.text = self.textFieldCM().placeholder
        self.updatePlaceholder()
        
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (self.textFieldCM().returnClickedCommand != nil) {
            self.textFieldCM().returnClickedCommand!.execute()
        }
        return false
    }
    
    
    func textFieldCM() -> TextFieldCellModel {
        return self.cellModel as! TextFieldCellModel
    }
    
    
    func textFieldDidChange(_ textField: UITextField) {
        self.textFieldCM().updateValue(textField.text)
        self.updatePlaceholder()
    }
    
    
    func updatePlaceholder() {
        self.placeholderLabel.isHidden = (self.textField.text?.characters.count)! > 0
    }
}
