//
//  SeparatorTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/11/17.
//
//

import UIKit

class SeparatorTableCell: GenericCell {

    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.separatorHeight.constant = 1.0
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        
    }
}
