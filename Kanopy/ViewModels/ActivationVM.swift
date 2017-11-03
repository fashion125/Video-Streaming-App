//
//  ActivationVM.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/7/17.
//
//

import UIKit

class ActivationVM: GenericVM {

    var delegate: ActivationVCDelegate!
    
    // MARK: - Init methods
    
    init(delegate: ActivationVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
    
    
    func attrCellModel(_ text: String,_ font: UIFont,_ color: UIColor!,_ height: CGFloat!) -> TextCellModel {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 0.25 * font.lineHeight
        paragraphStyle.alignment = .center
        
        let attrs = [
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : color,
            NSParagraphStyleAttributeName: paragraphStyle] as [String : Any]
        
        let ta = NSAttributedString.init(string: text,
                                         attributes: attrs)
        
        return TextCellModel.init(textAttribute: ta, height: height)
    }
}
