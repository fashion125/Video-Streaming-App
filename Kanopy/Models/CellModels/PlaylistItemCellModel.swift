//
//  PlaylistItemCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/26/17.
//
//

import UIKit

class PlaylistItemCellModel: ItemTableCellModel {
    
    var timeLabelHeight: CGFloat = 0.0
    var titleLabelHeight: CGFloat = 0.0
    var showMoreButtonHeight: CGFloat = 0.0
    var thumbViewHeight: CGFloat = 0.0
    
    
    // MARK: - Init methods
    
    
    override init(item: ItemModel!, height: CGFloat!, cellID: String!, actionBlock: @escaping ((_ itemCellModel: ItemTableCellModel) -> Void)) {
        
        super.init(item: item,
                   height: height,
                   cellID: cellID,
                   actionBlock: actionBlock)
    }
    
    
    open func numberOfLines() -> Int {
        return self.isShow == false ? 0 : 1
    }
    
    
    open func lineBreakMode() -> NSLineBreakMode {
        return self.isShow == false ? .byWordWrapping : .byClipping
    }
    
    
    open func descriptionText(width: CGFloat) -> String {
        if self.isShow == false || self.sizeIsValid(width: width) {
            return self.item.descriptionText
        } else {
            return ""
        }
    }
    
    
    override func heightValue(width: CGFloat) -> CGFloat {
        let ht = self.height(width: width, numberOfLines: 0)
        
        return ht + self.titleLabelHeight + self.timeLabelHeight + self.showMoreButtonHeight + 14
    }
    
    
    // MARK: -
    
    
    private func height(width: CGFloat, numberOfLines: Int) -> CGFloat {
        
        let textLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0,
                                                        width: width,
                                                        height: 0.0))
        
        textLabel.font = UIFont.init(name: "AvenirNextLTPro-Light", size: 14.0)!
        textLabel.text = self.item.descriptionText
        textLabel.numberOfLines = numberOfLines
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.sizeToFit()
        
        return textLabel.bounds.height
    }
    
    
    private func sizeIsValid(width: CGFloat!) -> Bool {
        
        let ht = self.height(width: width, numberOfLines: 1)
        
        return self.titleLabelHeight + self.timeLabelHeight + self.showMoreButtonHeight + ht + 6 < self.thumbViewHeight
    }
}
