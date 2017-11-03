//
//  ItemCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/8/17.
//
//

import UIKit

class ItemCellModel: GenericCellModel {
    
    private(set) var item: ItemModel!
    private(set) var chooseItemActionBlock: ((ItemModel) -> Void)!
    
    
    // MARK: - Init methods 
    
    
    init(item: ItemModel!, chooseItemActionBlock: @escaping ((ItemModel) -> Void)) {
        super.init(CollectionCellIDs.itemCell,
                   width: SizeStrategy.sizeItem().width,
                   height: SizeStrategy.sizeItem().height)
        
        self.item = item
        self.chooseItemActionBlock = chooseItemActionBlock
    }
    
    
    init(item: ItemModel!, width: CGFloat!, height: CGFloat!,
         chooseItemActionBlock: @escaping ((ItemModel) -> Void)) {
        
        super.init(CollectionCellIDs.itemCell, width: width, height: height)
        
        self.item = item
        self.chooseItemActionBlock = chooseItemActionBlock
    }
    
    
    // MARK: - Actions 
    
    
    open func didPressToItem() {
        self.chooseItemActionBlock(self.item)
    }
}
