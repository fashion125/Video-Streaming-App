//
//  AdditionalPanelTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/12/17.
//
//

import UIKit

class AdditionalPanelTableCell: GenericCell {

    @IBOutlet weak var button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.button.setTitle(self.additionalPanelCellModel().titleText, for: .normal)
        self.button.setImage(UIImage.init(named: self.additionalPanelCellModel().iconName),
                             for: .normal)
    }
    
    
    func additionalPanelCellModel() -> AdditionalPanelCellModel {
        return self.cellModel as! AdditionalPanelCellModel
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        self.additionalPanelCellModel().command?.execute()
    }
}
