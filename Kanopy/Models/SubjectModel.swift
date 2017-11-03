//
//  SubjectModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/24/17.
//
//

import UIKit

class SubjectModel: NSObject {
    
    private(set) var tid: Int! = 0
    private(set) var vid: Int! = 0
    private(set) var name: String! = ""
    private(set) var vocabulary: String! = ""
    
    
    // MARK: - Init methods 
    
    
    init(tid: Int!, vid: Int!, name: String!, vocabulary: String!) {
        super.init()
        
        self.tid = tid
        self.vid = vid
        self.name = name
        self.vocabulary = vocabulary
    }
}
