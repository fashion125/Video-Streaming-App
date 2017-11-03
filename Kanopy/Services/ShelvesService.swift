//
//  ShelvesService.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/3/17.
//
//

import UIKit

class ShelvesService: NSObject {
    
    /// Instance
    static let sharedInstance = ShelvesService()
    
    
    /** Method load and return in completion block shelves array for category
     - parameter categoryID: category id value (term id)
     - parameter completion:  Completion block. Return shelves array and top shelf object
     - parameter failure:  Failure block. Return error object
     */
    open func shelves(categoryID: String!,
                      completion: @escaping ((Array<ShelfModel>) -> Void),
                      failure: @escaping ((ErrorModel) -> Void)) {
        RequestService.sharedInstance.shelves(categoryID: categoryID,
            completion: { (shelves: Array<ShelfModel>) -> Void in
                completion(shelves)
        }) { (error: ErrorModel) -> Void in
                failure(error)
        }
    }
    
    
    /** Method load and return in completion block one shelf
     - parameter shelfHash: shelf id value
     - parameter completion:  Completion block. Return shelf.
     - parameter failure:  Failure block. Return error object.
     */
    open func shelf(shelfHash: String!,
                    completion: ((ShelfModel) -> Void)?,
                    failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.shelf(shelfHash: shelfHash,
                                            completion: { (shelf: ShelfModel) -> Void! in
            completion!(shelf)
        }) { (error: ErrorModel) -> Void! in
            failure!(error)
        }
    }
    
    
    open func shelfItems(shelfID: String!,
                         offset: Int!,
                         limit: Int!,
                         completion: ((Array<ItemModel>) -> Void)?,
                         failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.shelfItems(shelfID: shelfID, offset: offset, limit: limit, completion: { (items: Array<ItemModel>) in
            completion!(items)
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
}
