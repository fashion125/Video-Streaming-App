//
//  SearchService.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/12/17.
//
//

import UIKit

class SearchService: NSObject {
    
    /// Instance
    static let sharedInstance = SearchService()
    
    
    open func searchVideos(text: String!,
                           offset: Int!,
                           limit: Int!,
                           completion: @escaping ((Array<ItemModel>, Int) -> Void),
                           failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.searchVideos(text: text,
                                                   offset: offset,
                                                   limit: limit,
                                                   completion: { (videos: Array<ItemModel>, count: Int) in
                                                        completion(videos, count)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    open func searchInstitutions(text: String!,
                           completion: @escaping ((Array<ItemModel>, Array<ItemModel>) -> Void),
                           failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.searchInstitutions(text: text,
                                                   completion: { (suggestedInstitutions: Array<ItemModel>, otherInstitutions: Array<ItemModel>) in
                                                    completion(suggestedInstitutions, otherInstitutions)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
}
