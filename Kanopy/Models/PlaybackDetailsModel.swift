//
//  PlaybackDetailsModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/7/17.
//
//

import UIKit

class PlaybackDetailsModel: NSObject {

    private(set) var videoPlayID: String = ""
    private(set) var videoPlayPosition: UInt = 0
    
    private(set) var secureURL: String! = ""
    private(set) var defaultURL: String! = ""
    
    
    // MARK: - Init methods
    
    
    init(videoPlayID: String!,
         videoPlayPosition: UInt!,
         secureURL: String!,
         defaultURL: String!) {
        
        super.init()
        
        self.videoPlayID = videoPlayID
        self.videoPlayPosition = videoPlayPosition
        self.secureURL = secureURL
        self.defaultURL = defaultURL
    }
}
