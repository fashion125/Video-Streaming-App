//
//  TextTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class TextTableCell: GenericCell {

    @IBOutlet weak var titleTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .gray
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleTextLabel.text = self.textCM.text
        self.titleTextLabel.font = self.textCM.font
        self.titleTextLabel.textColor = self.textCM.color
    }
    
    
    var textCM: TextCellModel {
        get {
            return self.cellModel as! TextCellModel
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
    }
}
