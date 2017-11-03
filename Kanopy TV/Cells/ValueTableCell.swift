//
//  ValueTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class ValueTableCell: GenericCell {
   
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleTextLabel.text = self.valueCM.valueText
        self.valueLabel.text = self.valueCM.titleText
    }
    
    
    var valueCM: ValueCellModel {
        get {
            return self.cellModel as! ValueCellModel
        }
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
    }
}
