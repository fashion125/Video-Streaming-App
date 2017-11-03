//
//  TitlteWithSeparatorTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class TitlteWithSeparatorTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: TitleWithSeparatorCellModel = self.cellModel as! TitleWithSeparatorCellModel
        self.titleLabel.text = cm.titleValue
    }
}
