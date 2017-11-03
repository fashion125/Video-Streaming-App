//
//  ImageModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/8/17.
//
//

import UIKit

class ImageModel: NSObject {
    
    private(set) var roku_small: String? = ""
    private(set) var roku_medium: String? = ""
    
    private(set) var screenshots_small: String? = ""
    private(set) var screenshots_medium: String? = ""
    
    // MARK: - Init methods 
    
    override init() {
        super.init()
        
        self.roku_small = ""
        self.roku_medium = ""
        self.screenshots_small = ""
        self.screenshots_medium = ""
    }
    
    
    init(roku_small: String?,
         roku_medium: String?,
         screenshots_small: String?,
         screenshots_medium: String?) {
        
        super.init()
        
        self.roku_small = roku_small
        self.roku_medium = roku_medium
        self.screenshots_small = screenshots_small
        self.screenshots_medium = screenshots_medium
    }
    
    
    open func smallThumbURL() -> String {
        if self.screenshots_small != nil {
            return self.screenshots_small!
        } else if self.roku_small != nil {
            return self.roku_small!
        } else if self.screenshots_medium != nil {
            return self.screenshots_medium!
        } else if self.roku_medium != nil {
            return self.roku_medium!
        } else {
            return ""
        }
    }
    
    
    open func mediumThumbURL() -> String {
        if self.screenshots_medium != nil {
            return self.screenshots_medium!
        } else if self.roku_medium != nil {
            return self.roku_medium!
        }  else {
            return ""
        }
    }
}
