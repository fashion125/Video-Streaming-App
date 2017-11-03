//
//  CaptionTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/20/17.
//
//

import UIKit

class CaptionTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: CaptionCellModel = self.cellModel as! CaptionCellModel
        self.titleLabel.text = cm.titleValue
        
        if cm.isSelected {
            self.updateForSelected()
        } else {
            self.updateForNotSelected()
        }
    }
    
    
    // MARK: - Tools 
    
    
    func updateForSelected() {
        self.titleLabel.font = UIFont.init(name: "AvenirNextLTPro-Medium", size: 16.0)
        self.titleLabel.layer.opacity = 1.0
        self.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    
    func updateForNotSelected() {
        self.titleLabel.font = UIFont.init(name: "AvenirNextLTPro-Regular", size: 16.0)
        self.titleLabel.layer.opacity = 0.7
        self.accessoryType = UITableViewCellAccessoryType.none
    }
}
