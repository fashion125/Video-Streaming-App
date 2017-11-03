//
//  TextWithLinksTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 19.06.17.
//
//

import UIKit
import TTTAttributedLabel

class TextWithLinksTableCell: GenericCell, TTTAttributedLabelDelegate {

    @IBOutlet weak var textLinkLabel: TTTAttributedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateLabelDesign()
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.updateText()
    }
    
    
    // MARK: - Tools

    
    var textWithLinkCM: TextWithLinksCellModel {
        get {
            return self.cellModel as! TextWithLinksCellModel
        }
    }
    
    
    func updateLabelDesign() {
        
        textLinkLabel.textColor = UIColor.white
        textLinkLabel.delegate = self
        
        let font = UIFont.init(name: "AvenirNextLTPro-Medium", size: 14.0)
        
        let attrs = [
            NSFontAttributeName : font!,
            NSForegroundColorAttributeName : UIColor.mainOrangeColor(),
            NSUnderlineStyleAttributeName : true] as [String : Any]
        
        textLinkLabel.linkAttributes = attrs
    }
    
    
    func updateText() {
        
        textLinkLabel.text = self.textWithLinkCM.text
        
        self.updateLinks()
    }
    
    
    func updateLinks() {
        let str: NSString = textLinkLabel.text! as NSString
        
        for tl in self.textWithLinkCM.links {
            
            let range: NSRange = str.range(of: tl.text)
            textLinkLabel.addLink(to: URL.init(string: tl.key), with: range)
        }
    }
    
    
    // MARK: - TTTAttributedLabelDelegate methods 
    
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url != nil {
            self.textWithLinkCM.didPressToLink(linkText: url.absoluteString)
        }
        
    }
}
