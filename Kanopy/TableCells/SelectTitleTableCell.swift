//
//  SelectTitleTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/25/17.
//
//

import UIKit

class SelectTitleTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        self.titleLabel.text = self.selectTitleCM.titleText
        self.descriptionLabel.text = self.selectTitleCM.descriptionText
    }
    
    
    var selectTitleCM: SelectTitleCellModel {
        get {
            return self.cellModel as! SelectTitleCellModel
        }
    }
}
