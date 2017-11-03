//
//  PlaylistService.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/27/17.
//
//

import UIKit

class PlaylistService: NSObject {

    private(set) var myPlaylists: Array<PlaylistModel>! = [PlaylistModel]()
    
    /// Instance
    static let sharedInstance = PlaylistService()
    
    
    // MARK: -
    
    
    /** This method return user's playlists
     - parameters:
        - completion: Completion block. Return PlaylisModel array
        - failure: Failure block. Return ErrorModel object
     */
    func myPlaylist(completion: @escaping ((Array<PlaylistModel>) -> Void),
                    failure: @escaping ((ErrorModel) -> Void))
    {
        RequestService.sharedInstance.myPlaylist(completion: { (playlists: Array<PlaylistModel>) in
            self.myPlaylists = playlists
            completion(playlists)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    /** This method return playlist's items
     - parameters:
        - playlistID: Playlist's identifier
        - completion: Completion block. Return ItemMode array
        - failure: Failure block. Return ErrorModel object
     */
    open func playlistDetails(playlistID: String!,
                              offset: Int!,
                              limit: Int!,
                              completion: @escaping (([ItemModel]) -> Void),
                              cachedCompletion: @escaping (([ItemModel]) -> Void),
                              failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.playlistDetails(playlistID: playlistID,
                                                      offset: offset,
                                                      limit: limit,
                                                      completion: { (videos: [ItemModel]) in
                                                        completion(videos)
        }, cachedCompletion: { (videos: [ItemModel]) in
            cachedCompletion(videos)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    /** This method insert item to playlist by identifier
     - parameter itemID: item identifire which insert to playlist
     - parameter playlistID: playlist identifier in which need insert item
     - parameter completion: Completion block.
     - parameter failure:  Failure block. Return error object
     */
    open func insertItemToPlaylist(itemID: String!,
                                   playlistID: String!,
                                   completion: (() -> Void)?,
                                   failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.insertItemToPlaylist(itemID: itemID,
                                                           playlistID: playlistID,
                                                           completion: { 
                 completion!()
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    /** This method remove item to playlist by identifier
     - parameter itemID: item identifire which remove to playlist
     - parameter playlistID: playlist identifier in which need remove item
     - parameter completion: Completion block.
     - parameter failure:  Failure block. Return error object
     */
    open func removeItemFromPlaylist(itemID: String,
                                     playlistID: String!,
                                     completion: (() -> Void)?,
                                     failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.removeItemToPlaylist(itemID: itemID,
                                                           playlistID: playlistID,
                                                           completion: { 
                    completion!()
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    // MARK: - Tools 
    
    
    /** This method return user's wathclist object */
    open func myWathchlist() -> PlaylistModel? {
        
        for pm in self.myPlaylists {
            if pm.isWatchlist {
                return pm
            }
        }
        
        return nil
    }
}
