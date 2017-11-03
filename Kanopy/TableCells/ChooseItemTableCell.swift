//
//  ChooseItemTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

class ChooseItemTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var isCheckIcon: UIImageView!
    
    
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
        
        self.titleLabel.text = self.chooseItemCM.title
        self.descriptionText.text = self.chooseItemCM.descriptionText
        
        if !self.chooseItemCM.isCheck {
            self.isCheckIcon.isHidden = true
        }
    }
    
    var chooseItemCM: ChooseItemCellModel {
        get {
            return self.cellModel as! ChooseItemCellModel
        }
    }
}
