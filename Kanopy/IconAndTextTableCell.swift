//
//  IconAndTextTableCell.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 22/06/2017.
//
//

import UIKit

class IconAndTextTableCell: GenericCell {
    
    
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let iconAndTextCellModel: IconAndTextCellModel = self.iconAndTextCellModel()
        
        self.statusIconImageView.image = iconAndTextCellModel.icon
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        
        var size = 16.0
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            size = 24.0
        }
        
        var font: UIFont? = UIFont.init(name: "AvenirNextLTPro-Regular", size: CGFloat(size))
        
        if font == nil {
            font = UIFont.systemFont(ofSize: CGFloat(size))
        }
        
        let attributes: [String : Any] = [ NSForegroundColorAttributeName: UIColor.white,
                                            NSFontAttributeName: font!,
                                            NSParagraphStyleAttributeName: style]
        let attrString = NSAttributedString(string: iconAndTextCellModel.title, attributes: attributes)
        self.titleLabel.attributedText = attrString
    }
    
    
    func iconAndTextCellModel() -> IconAndTextCellModel {
        return self.cellModel as! IconAndTextCellModel
    }
}
