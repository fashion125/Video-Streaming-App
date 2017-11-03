//
//  CountTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/9/17.
//
//

import UIKit

class CountTableCell: GenericCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var outOfLabel: UILabel!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.countLabel.text = String(self.countCellModel().count)
        self.outOfLabel.text = "OUT_OF".localized
    }
    
    
    func countCellModel() -> CountCellModel {
        return self.cellModel as! CountCellModel
    }
}
