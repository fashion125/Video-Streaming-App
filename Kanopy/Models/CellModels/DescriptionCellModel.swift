//
//  DescriptionCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/17/17.
//
//

import UIKit

class DescriptionCellModel: GenericCellModel {

    private(set) var isShow = false
    private(set) var descriptionText: String!
    private(set) var actionBlock: ((_ descriptionCellModel: DescriptionCellModel) -> Void)!
    
    private(set) var shortDescriptionText: String = ""

    
    // MARK: - Init methods 
    
    
    init(descriptionText: String!, actionBlock: ((_ descriptionCellModel: DescriptionCellModel) -> Void)!) {
        super.init(TableCellIDs.descriptionCell, height: SizeStrategy.descriptionCellHeight())
        
        self.descriptionText = descriptionText
        self.actionBlock = actionBlock
        self.isShow = true
        self.updateShortDescriptionValue()
    }
    
    
    open func changeSize(cellWidth: CGFloat) {
        if self.isShow == true {
            self.isShow = false
            self.updateHeight(self.heightValue(width: cellWidth))
            self.actionBlock(self)
        } else {
            self.isShow = true
            self.updateHeight(SizeStrategy.descriptionCellHeight())
            self.actionBlock(self)
        }
    }
    
    
    open func descriptionTextValue() -> String {
        if self.isShow == false {
            return self.descriptionText
        } else {
            return self.shortDescriptionText
        }
    }
    
    
    private func heightValue(width: CGFloat) -> CGFloat {
        let textView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: width - 20.0, height: 0.0))
        
        textView.font = UIFont.init(name: "AvenirNextLTPro-Light", size: 15.0)!
        textView.text = self.descriptionText
        textView.sizeToFit()
        
        return textView.contentSize.height + 10.0
    }
    
    
    private func updateShortDescriptionValue() {
        
//        let font = UIFont.init(name: "AvenirNextLTPro-Light", size: 15.0)!
//        let size = CGSize.init(width: UIScreen.main.bounds.width - 20.0,
//                               height: CGFloat(64.0))
//        
//        let count = self.descriptionText.charactersCountInLabel(font: font,
//                                                                size: size)
//        let nstr = NSString.init(string: self.descriptionText)
//        
//        self.shortDescriptionText = nstr.substring(to: count)
    }
}
