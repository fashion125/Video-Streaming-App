//
//  InfoTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/17/17.
//
//

import UIKit

class InfoTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: InfoCellModel = self.cellModel as! InfoCellModel
        
        self.titleLabel.text = cm.title + ":"
        self.titleLabel.sizeToFit()
        self.titleWidth.constant = self.titleLabel.frame.size.width
        
        self.valueLabel.text = cm.value
    }
    
    
    
}
