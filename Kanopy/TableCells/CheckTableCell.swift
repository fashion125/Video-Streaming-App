//
//  CheckTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/9/17.
//
//

import UIKit

class CheckTableCell: GenericCell {

    
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let tbCM: CheckCellModel = self.checkCellModel()
        
        self.statusIconImageView.image = tbCM.isCheck ? #imageLiteral(resourceName: "isCheck_icon") : #imageLiteral(resourceName: "is_not_check_icon")
        
        if (tbCM.isUnderline) {
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: tbCM.title, attributes: underlineAttribute)
            self.titleLabel.attributedText = underlineAttributedString
            
            if (tbCM.buttonCommand != nil) {
                let tap = UITapGestureRecognizer(target: self, action: #selector(CheckTableCell.executeCommand))
                self.titleLabel.isUserInteractionEnabled = true
                self.titleLabel.addGestureRecognizer(tap)
            }
        } else {
            self.titleLabel.text = tbCM.title
        }
        
        self.descriptionLabel.text = tbCM.descriptionText
        
        self.descriptionLabel.isHidden = !((self.descriptionLabel.text?.characters.count)! > 0)
        
        self.titleLabel.textColor = tbCM.isNext ? UIColor.mainOrangeColor() : UIColor.white
    }
    
    
    func checkCellModel() -> CheckCellModel {
        return self.cellModel as! CheckCellModel
    }
    
    func executeCommand(sender:UITapGestureRecognizer) {
        let tbCM: CheckCellModel = self.cellModel as! CheckCellModel
        tbCM.buttonCommand.execute()
    }
}
