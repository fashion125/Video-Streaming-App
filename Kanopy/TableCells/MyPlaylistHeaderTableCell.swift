//
//  MyPlaylistHeaderTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/27/17.
//
//

import UIKit

class MyPlaylistHeaderTableCell: GenericCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.separatorHeight.constant = 0.5
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: HeaderCellModel = self.cellModel as! HeaderCellModel
        self.nameLabel.text = cm.name
    }
}
