//
//  ListItemCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/26/17.
//
//

import UIKit

class ListItemCellModel: ItemTableCellModel {

    var timeLabelHeight: CGFloat = 0.0
    var titleLabelHeight: CGFloat = 0.0
    var showMoreButtonHeight: CGFloat = 0.0
    var thumbViewHeight: CGFloat = 0.0
    
    private(set) var shortDescriptionText: String! = ""
    
    
    // MARK: - Init methods 
    
    
    override init(item: ItemModel!, actionBlock: @escaping ((_ itemCellModel: ItemTableCellModel) -> Void)) {
        
        super.init(item: item, actionBlock: actionBlock)
        self.shortDescriptionText = self.item.descriptionText
//        self.updateShortDescriptionText()
    }
    
    
    override func heightValue(width: CGFloat) -> CGFloat {
        
        let ht = self.height(width: width, numberOfLines: 0)
        let margins = CGFloat(10.0)
        
        return ht + self.titleLabelHeight + self.timeLabelHeight + self.showMoreButtonHeight + margins
    }
    
    
    // MARK: -
    
    
    open func numberOfLines() -> Int {
        return self.isShow == false ? 0 : 2
    }
    
    
    open func lineBreakMode() -> NSLineBreakMode {
        return self.isShow == false ? .byWordWrapping : .byClipping
    }
    
    
    open func descriptionText(width: CGFloat) -> String {
        if self.isShow == false {
            return self.item.descriptionText
        } else {
            return self.shortDescriptionText
        }
    }
    
    
    // MARK: -
    
    
    private func height(width: CGFloat, numberOfLines: Int) -> CGFloat {
        
        let font = UIFont.init(name: "AvenirNextLTPro-Regular", size: 14.0)!
        return self.item.descriptionText.height(width: width,
                                                font: font,
                                                lineSpacing: 3)
    }
    
    
    private func updateShortDescriptionText() {
        
        let font = UIFont.init(name: "AvenirNextLTPro-Regular", size: 14.0)!
        let size = CGSize.init(width: (UIScreen.main.bounds.width - 30.0 - 130.0 - 8.0),
                               height: 73 - self.titleHeight() + 2)
        
        let count = self.item.descriptionText.charactersCountInLabel(font: font,
                                                                     size: size,
                                                                     lineSpacing: 3)
        
        self.shortDescriptionText = NSString.init(string: self.item.descriptionText).substring(to: count) + "..."
    }
    
    
    private func titleHeight() -> CGFloat {
        
        let font = UIFont.init(name: "AvenirNextLTPro-Regular", size: 14.0)!
        let width = UIScreen.main.bounds.width - 30.0 - 130.0 - 8.0
        
        return self.item.title.height(width: width,
                                      font: font,
                                      lineSpacing: 19)
    }
    
    private func sizeIsValid(width: CGFloat!) -> Bool {
        
        let ht = self.height(width: width, numberOfLines: 1)
        
        return self.titleLabelHeight + self.timeLabelHeight + self.showMoreButtonHeight + ht + 6 < self.thumbViewHeight
    }
}
