//
//  ProfileInfoTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

class ProfileInfoTableCell: GenericCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.infoCM.title
        self.valueLabel.text = self.infoCM.value
    }
    
    
    var infoCM: InfoCellModel {
        get {
            return self.cellModel as! InfoCellModel
        }
    }
}
