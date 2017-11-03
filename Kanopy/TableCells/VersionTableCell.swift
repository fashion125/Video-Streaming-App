//
//  VersionTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 07.06.17.
//
//

import UIKit

class VersionTableCell: GenericCell {

    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var versionTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.versionNumberLabel.text = self.versionCM.versionValue
        self.versionTypeLabel.text = self.versionCM.buildTypeValue
    }
    
    
    var versionCM: VersionCellModel {
        get {
            return self.cellModel as! VersionCellModel
        }
    }
}
