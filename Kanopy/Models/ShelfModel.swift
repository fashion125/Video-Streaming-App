//
//  ShelfModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/3/17.
//
//

import UIKit

class ShelfModel: NSObject {
    
    private(set) public var shelfID: String!
    
    private(set) public var title: String!
    private(set) public var itemType: String!
    private(set) public var items: Array<ItemModel>!
    
    private(set) public var created: Date?
    private(set) public var changed: Date?
    
    // MARK: - Init method
    
    init(shelfID: String!, title: String!, itemType: String!, items: Array<ItemModel>!, created: Date, changed: Date) {
        super.init()
        
        self.shelfID = shelfID
        self.title = title
        self.itemType = itemType
        self.items = items
        
        self.created = created
        self.changed = changed
    }
    
    
    init(shelfID: String!, title: String!, items: Array<ItemModel>!) {
        super.init()
        
        self.shelfID = shelfID
        self.title = title
        self.items = items
    }
    
    
    // MARK: - Tools 
    
    
    func insertItems(items: Array<ItemModel>!) {
        self.items.append(contentsOf: items)
    }
}
