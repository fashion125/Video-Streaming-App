//
//  TitleHeaderTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

class TitleHeaderTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.titleCM.titleValue.uppercased()
    }
    
    
    var titleCM: TitleCellModel {
        get {
            return self.cellModel as! TitleCellModel
        }
    }
}
