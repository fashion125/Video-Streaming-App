//
//  SuggestResultTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/12/17.
//
//

import UIKit

class SuggestResultTableCell: GenericCell {
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        if highlighted == true {
            self.backgroundColor = UIColor.mainBackgroundDarkGreyColor()
            self.contentView.backgroundColor = UIColor.mainBackgroundDarkGreyColor()
        } else {
            self.backgroundColor = UIColor.clear
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: ItemTableCellModel = self.cellModel as! ItemTableCellModel
        self.titleLabel.text = cm.item.title
    }
}
