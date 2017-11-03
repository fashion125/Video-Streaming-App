//
//  VideoService.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/24/17.
//
//

import UIKit

protocol VideoServiceDelegate {
    
    /** This method is call when data for home page is downloaded */
    func didLoadHomePageData(categories: Array<CategoryModel>)
}

class VideoService: NSObject {
    
    /// Instance
    static var sharedInstance = VideoService()
    
    private var observers: NSMutableArray?
    
    
    override init() {
        super.init()
        
        self.observers = NSMutableArray.init()
    }
    
    
    // MARK: - Observers methods
    
    
    open func addObserver(observer: VideoServiceDelegate!) {
        if !(self.observers?.contains(observer))! {
            self.observers?.add(observer)
        }
    }
    
    
    open func removeObserver(observer: VideoServiceDelegate!) {
        if (self.observers?.contains(observer))! {
            self.observers?.remove(observer)
        }
    }
    
    
    open func notifyAllObserversForDownloadCategories(categories: Array<CategoryModel>!) {
        let observersArray = self.observers
        
        for delegate in observersArray! {
            let dg = delegate as! VideoServiceDelegate
            dg.didLoadHomePageData(categories: categories)
        }
    }
    
    
    /** Method return recommend video for current video object
     - parameter completion:  Completion block. Return items array
     - parameter failure:  Failure block. Return error object
     */
    open func getRecommendVideos(videoID: String!,
                                 offset: Int!,
                                 limit: Int!,
                                 completion: ((Array<ItemModel>) -> Void)?,
                                 failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.recommendVideos(videoID: videoID,
                                                      offset: offset,
                                                      limit: limit,
                                                      completion: { (items: Array<ItemModel>) in
                                      completion!(items)
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    /** Method return videos for the collection or playlist 
     - parameter videoID: Collection/playlist identifier
     - parameter completion: Completion block. Return items array
     - parameter failure:  Failure block. Return error object
     */
    open func videosForItem(videoID: String!,
                            offset: Int!,
                            limit: Int!,
                            completion: ((Array<ItemModel>) -> Void)?,
                            cachedCompletion: @escaping ((Array<ItemModel>) -> Void),
                            failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.videosForItem(videoID: videoID, offset: offset, limit: limit,
                                                    completion: { (items: Array<ItemModel>) in
                                                        completion!(items)
        }, cachedCompletion: { (items: Array<ItemModel>) in
            cachedCompletion(items)
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    /** Method return pageviewID for the movie object
     - parameter videoID: Collection/playlist/movie identifier
     - parameter refVideoID: Ref collection/playlist/movie identifier
     - parameter completion: Completion block. Return Page view identifire
     - parameter failure:  Failure block. Return error object
     */
    open func analyticsPageView(_ videoID: String!, refVideoID: String!,
                                completion: ((String) -> Void)?,
                                failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.analyticsPageView(videoID, refVideoID: refVideoID,
        completion: { (pageViewID: String) in
            completion!(pageViewID)
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    /** Method return video playback details for the movie object
     - parameter videoID: Collection/playlist/movie identifier
     - parameter pageViewID: Page view identifier
     - parameter completion: Completion block. Return PlaybackDetailsModel object
     - parameter failure:  Failure block. Return error object
     */
    open func videoPlaybackDetails(_ videoID: String!, pageViewID: String!,
                                completion: @escaping ((PlaybackDetailsModel) -> Void),
                                failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.videoPlaybackDetails(videoID, pageViewID: pageViewID,
        completion: { (response: PlaybackDetailsModel) in
            completion(response)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    open func getVideoItem(videoID: String!,
                           completion: @escaping ((ItemModel) -> Void),
                           cachedCompletion: @escaping ((ItemModel) -> Void),
                           failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.getVideoItem(videoID: videoID,
                                                   completion: { (item: ItemModel) in
                                                        completion(item)
        }, cachedCompletion: { (item: ItemModel) in
            cachedCompletion(item)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    /** Method return categories and shelves objects for home page and menu
     - parameter completion: Completion block. Return PlaybackDetailsModel object
     - parameter failure:  Failure block. Return error object
     */
    open func displays(completion: (([ShelfModel], [CategoryModel], UserModel) -> Void)?,
                       cacheCompletion: (([ShelfModel], [CategoryModel], UserModel) -> Void)?,
                       failure: ((ErrorModel) -> Void)?) {
        
        RequestService.sharedInstance.displays(completion: { (shelfs: [ShelfModel], categories: [CategoryModel], userModel: UserModel, allCategories: [CategoryModel]) in
            
            self.notifyAllObserversForDownloadCategories(categories: allCategories)
            
            completion!(shelfs, categories, userModel)
        }, cacheCompletion: { (shelfs: [ShelfModel], categories: [CategoryModel], userModel: UserModel, allCategories: [CategoryModel]) in
            cacheCompletion!(shelfs, categories, userModel)
        }) { (error: ErrorModel) in
            failure!(error)
        }
    }
    
    
    /** Method return all info about captions for video
     - parameter videoID: Video's identifire for captions
     - parameter completion: Completion block. Return PlaybackDetailsModel object
     - parameter failure:  Failure block. Return error object
     */
    open func captions(videoID: String!,
                       completion: @escaping (([CaptionModel]) -> Void),
                       failure: @escaping ((ErrorModel) -> Void)) {
        RequestService.sharedInstance.getCaptions(videoID: videoID,
                                                  completion: { (captions:[CaptionModel]) in
                                                    completion(captions)
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    /** Method save video position for item 
     - parameter timeSeconds: Current time in seconds for item
     - parameter itemID: Video identifire for saving
     */
    open func saveVideoPosition(_ timeSeconds: Float, itemID: String!) {
        
        FileService.sharedInstance.saveRecord(FileNames.videoPosition,
                                              timeSeconds,
                                              itemID: itemID)
    }
    
    
    /** Method get video position record for itemID 
     - parameter itemID: item identifire for which return value
     */
    open func getRecord(itemID: String) -> Dictionary<String, Float>? {
        return FileService.sharedInstance.getRecord(FileNames.videoPosition,
                                                    itemID: itemID) as! Dictionary<String, Float>?
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
                                   failure: @escaping ((ErrorModel) -> Void)) {
        
        RequestService.sharedInstance.insertItemToPlaylist(itemID: itemID,
                                                           playlistID: playlistID,
                                                           completion: { 
                                                            completion!()
        }) { (error: ErrorModel) in
            failure(error)
        }
    }
    
    
    // MARK: -
    
    
    open func sendAnalytics(videodPlayID: String!,
                            from: UInt!,
                            to: UInt!) {
        
        RequestService.sharedInstance.sendAnalytics(videoPlayID: videodPlayID,
                                                    from: from,
                                                    to: to)
    }
}
