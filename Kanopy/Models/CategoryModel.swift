//
//  CategoryModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/8/17.
//
//

import UIKit

class CategoryModel: NSObject {
    
    private(set) var termID: String! = ""
    private(set) var vocabularyID: String! = ""
    private(set) var name: String! = ""
    private(set) var vocabulary: String! = ""
    private(set) var subcategory: Array<CategoryModel>? = [CategoryModel]()
    
    // MARK: - Init methods 
    
    
    override init() {
        super.init()
    }
    
    
    init(termID: String!,
         vocabularyID: String!,
         name: String!,
         vocabulary: String!,
         subcategory: Array<CategoryModel>?) {
        
        super.init()
        
        self.termID = termID
        self.vocabularyID = vocabularyID
        self.name = name
        self.vocabulary = vocabulary
        self.subcategory = subcategory
    }
    
    
    func getSubcategoryWithTitle(title: String!) -> CategoryModel? {
        
        for c in self.subcategory! {
            if c.name == title {
                return c
            }
        }
        
        return nil
    }
}
