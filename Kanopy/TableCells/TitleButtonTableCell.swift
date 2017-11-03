//
//  TitleButtonTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/29/17.
//
//

import UIKit

class TitleButtonTableCell: GenericCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let tbCM: ButtonCellModel = self.cellModel as! ButtonCellModel
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attrs = [
            NSFontAttributeName : tbCM.font!,
            NSForegroundColorAttributeName : tbCM.color!,
            NSUnderlineStyleAttributeName : tbCM.isUnderline,
            NSParagraphStyleAttributeName: paragraph] as [String : Any]
        
        let attStr = NSMutableAttributedString.init(string: tbCM.title, attributes: attrs)
        
        self.button.titleLabel?.lineBreakMode = .byWordWrapping
        self.button.titleLabel?.numberOfLines = 0
        self.button.setAttributedTitle(attStr, for: .normal)
    }
    
    
    @IBAction func buttonAction(_ sender: Any) {
        
        let tbCM: ButtonCellModel = self.cellModel as! ButtonCellModel
        tbCM.buttonCommand.execute()
    }
}
