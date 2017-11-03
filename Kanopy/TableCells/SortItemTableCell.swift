//
//  SortItemTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/10/17.
//
//

import UIKit

class SortItemTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        
        super.configure(cellModel: cellModel)
        
        let cm: SortItemCellModel = self.cellModel as! SortItemCellModel
        
        self.titleLabel.text = cm.title
        
        self.accessoryType = cm.isSelectedType == true ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
    }
}
