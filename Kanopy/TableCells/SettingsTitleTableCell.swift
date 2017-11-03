//
//  SettingsTitleTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/25/17.
//
//

import UIKit

class SettingsTitleTableCell: GenericCell {

    @IBOutlet weak var titleLabel: UILabel!
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
        
        self.titleLabel.text = self.settingsTitleCM.titleText
    }
    
    
    var settingsTitleCM: SettingsTitleCellModel {
        get {
            return self.cellModel as! SettingsTitleCellModel
        }
    }
}
