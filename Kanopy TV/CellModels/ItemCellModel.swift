//
//  ItemCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/20/17.
//
//

import UIKit

class ItemCellModel: GenericCellModel {

    private(set) var item: ItemModel!
    private(set) var chooseItemCommand: GeneralCommand!
    
    private(set) var focusWidth: CGFloat! = 0
    private(set) var focusHeight: CGFloat! = 0
    
    
    // MARK: - Init methods 
    
    
    init(item: ItemModel!, chooseItemCommand: GeneralCommand!) {
        super.init(CollectionCellIDs.itemCell, width: 458, height: 272)
        
        self.item = item
        self.chooseItemCommand = chooseItemCommand
    }
    
    
    init(item: ItemModel!, chooseItemCommand: GeneralCommand!, width: CGFloat!, height: CGFloat!) {
        super.init(CollectionCellIDs.itemCell, width: width, height: height)
        
        self.item = item
        self.chooseItemCommand = chooseItemCommand
    }
    
    
    init(item: ItemModel!,
         chooseItemCommand: GeneralCommand!,
         cellID: String!,
         width: CGFloat!,
         height: CGFloat!,
         focusWidth: CGFloat,
         focusHeight: CGFloat) {
        
        super.init(cellID, width: width, height: height)
        
        self.item = item
        self.chooseItemCommand = chooseItemCommand
        self.focusWidth = focusWidth
        self.focusHeight = focusHeight
    }
    
    
    override func didSelect() {
        self.chooseItemCommand.execute(self.item)
    }
}
