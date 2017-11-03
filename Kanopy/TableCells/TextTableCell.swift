//
//  TextTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/7/17.
//
//

import UIKit

class TextTableCell: GenericCell {

    @IBOutlet weak var valueLabel: UILabel!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.valueLabel.attributedText = self.textCellModel().textAttribute
    }
    
    
    func textCellModel() -> TextCellModel {
        return self.cellModel as! TextCellModel
    }
}
