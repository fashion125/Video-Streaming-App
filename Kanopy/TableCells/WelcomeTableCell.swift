//
//  WelcomeTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class WelcomeTableCell: GenericCell {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.welcomeLabel.text = "WELCOME".localized
    }
    
    
}
