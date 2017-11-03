//
//  SwitcherTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/25/17.
//
//

import UIKit

class SwitcherTableCell: GenericCell {

    
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.separatorHeight.constant = 0.5
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.switcherCM.titleText
        self.switcher.setOn(self.switcherCM.value, animated: false)
    }
    
    
    var switcherCM: SwitcherCellModel {
        get {
            return self.cellModel as! SwitcherCellModel
        }
    }
    
    
    @IBAction func switcherAction(_ sender: Any) {
        self.switcherCM.command?.execute(self.switcher.isOn)
    }
}
