//
//  DescriptionTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/19/17.
//
//

import UIKit

class DescriptionTableCell: GenericCell {

    @IBOutlet weak var descriptionTextLabel: ReadMoreLabel!
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.separatorHeight.constant = 0.5
    }

    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: DescriptionCellModel = self.cellModel as! DescriptionCellModel
        
        self.descriptionTextLabel.text = cm.descriptionText
        self.descriptionTextLabel.showButton(cm.isShow,
                                             width: UIScreen.main.bounds.width - 30.0) {
                                                cm.changeSize(cellWidth: self.bounds.width)
        }
    }
}
