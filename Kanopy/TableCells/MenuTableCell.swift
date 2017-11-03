//
//  MenuTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/8/17.
//
//

import UIKit

class MenuTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var bottomSeparatorHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bottomSeparatorHeight.constant = 1.0
    }
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: MenuCellModel = self.cellModel as! MenuCellModel
        
        self.titleLabel.text = cm.title
        self.selectedView.isHidden = !cm.isSelected
        self.bottomSeparator.isHidden = !cm.isShowBottomSeparator
    }
}
