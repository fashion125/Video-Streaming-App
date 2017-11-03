//
//  AuthTitleTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class AuthTitleTableCell: GenericCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)

        let cm: TitleCellModel = self.cellModel as! TitleCellModel
        
        self.titleLabel.text = cm.titleValue
    }
}
