//
//  PlaylistModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/23/17.
//
//

import UIKit

class PlaylistModel: NSObject {

    private(set) var playlistID: String = ""
    private(set) var titleValue: String = ""
    private(set) var isWatchlist: Bool = false
    private(set) var itemsCount: Int = 0
    
    
    // MARK: - Init methods
    
    
    override init() {
        super.init()
    }
    
    
    /** 
     Init method for Playlist object
     
     - parameters:
       - playlistID: Identifire for playlist
       - titleValue: Playlist's title
       - isWatchlist: If playlist is watchlist - true, else - false
       - itemsCount: Playlist's items count
    */
    init(_ playlistID: String!,
         _ titleValue: String!,
         _ isWatchlist: Bool!,
         _ itemsCount: Int!) {
        
        super.init()
        
        self.playlistID = playlistID
        self.titleValue = titleValue
        self.isWatchlist = isWatchlist
        self.itemsCount = itemsCount
    }
    
    
    open func removeItem() {
        self.itemsCount = self.itemsCount - 1
    }
    
    
    open func insertItem() {
        self.itemsCount = self.itemsCount + 1
    }
}
