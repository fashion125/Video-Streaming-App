//
//  HeaderCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/16/17.
//
//

import UIKit

class HeaderCellModel: GenericCellModel {

    private(set) var name: String!
    private(set) var thumbURL: String!
    private(set) var timeValue: String!
    private(set) var ratingCount: Int!
    private(set) var year: String!
    private(set) var isHasCaption: Bool! = false
    
    private(set) var itemTitle: String?
    private(set) var partTitle: String?
    private(set) var subtitle: String?
    
    private(set) var item: ItemModel!
    var actionBlock: ((ItemModel) -> Void)!
    
    // MARK: - Init methods 
    
    
    /** Method create HeaderCellModel object for About Movie Page */
    init(name: String!, thumbURL: String!, timeValue: String!, ratingCount: Int!, year: String!, height: CGFloat!, item: ItemModel!, isHasCaption: Bool!) {
        
        super.init(TableCellIDs.movieHeaderCell, height: height)
        
        self.name = name
        self.thumbURL = thumbURL
        self.timeValue = timeValue
        self.ratingCount = ratingCount
        self.year = year
        self.item = item
        self.isHasCaption = isHasCaption
    }
    
    
    init(name: String!,
         thumbURL: String!,
         timeValue: String!,
         ratingCount: Int!,
         itemTitle: String!,
         partTitle: String!,
         subtitle: String!,
         height: CGFloat!,
         item:ItemModel!) {
        
        super.init(TableCellIDs.playlistHeaderCell, height: height)
        
        self.name = name
        self.thumbURL = thumbURL
        self.timeValue = timeValue
        self.ratingCount = ratingCount
        self.itemTitle = itemTitle
        self.partTitle = partTitle
        self.subtitle = subtitle
        self.item = item
    }
    
    
    init(name: String!,
         timeValue: String!,
         ratingCount: Int!,
         itemTitle: String!,
         partTitle: String!,
         subtitle: String!,
         height: CGFloat!,
         item: ItemModel!,
         cellID: String!) {
        
        super.init(cellID, height: height)
        
        self.name = name
        self.timeValue = timeValue
        self.ratingCount = ratingCount
        self.itemTitle = itemTitle
        self.partTitle = partTitle
        self.subtitle = subtitle
        self.item = item
    }
    
    
    init(name: String!, cellID: String!, height: CGFloat!) {
        super.init(cellID, height: height)
        
        self.name = name
    }
    
    
    open func updateAction(actionBlock: @escaping (_ item: ItemModel?) -> Void) {
        self.actionBlock = actionBlock
    }
    
    
    open func didPressToPlayButton() {
        self.actionBlock(self.item)
    }
}
