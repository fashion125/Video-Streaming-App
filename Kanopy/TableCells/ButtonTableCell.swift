//
//  ButtonTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class ButtonTableCell: GenericCell {

    @IBOutlet weak var button: UIButton!
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.button.layer.cornerRadius = 1.0
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.button.setTitle(self.buttonCM().title, for: .normal)
        
        self.updateButtonFrame(width: self.buttonCM().buttonWidth)
    }
    
    
    private func buttonCM() -> ButtonCellModel {
        return self.cellModel as! ButtonCellModel
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func buttonAction(_ sender: Any) {
        self.buttonCM().buttonCommand.execute()
    }
    
    
    // MARK: - Tools 
    
    
    func updateButtonFrame(width: CGFloat!) {
        
        self.button.frame = CGRect.init(x: 0,
                                        y: 0,
                                        width: width,
                                        height: self.button.bounds.height)
        
        self.button.center = self.contentView.center
    }
}
