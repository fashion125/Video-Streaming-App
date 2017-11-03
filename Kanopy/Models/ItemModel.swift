//
//  ItemModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/3/17.
//
//

import UIKit

class TypeItem {
    static let productKey: String = "product"
    static let playlistKey: String = "playlist"
    static let collectionKey: String = "collection"
}

class ItemModel: NSObject {
    
    private(set) public var itemID: String!
    
    private(set) public var status: Bool!
    private(set) public var title: String!
    private(set) public var tagline: String!
    private(set) public var descriptionText: String!
    private(set) public var path: String?
    
    private(set) public var images: ImageModel?
    
    private(set) public var classification: String!
    private(set) public var hasBurnInCaption: Bool!
    private(set) public var hasCaptions: Bool!
    
    private(set) public var yearOfProduction: String!
    private(set) public var runningTime: Int32!
    private(set) public var subtype: String!
    
    private(set) public var ownedContent: Bool!
    private(set) public var director: [String]!
    
    private(set) public var subject: [SubjectModel]!
    private(set) public var subjects: [SubjectModel]!
    private(set) public var filmmakers: [SubjectModel]!
    private(set) public var cast: [SubjectModel]!
    private(set) public var languages: [SubjectModel]!
    private(set) public var tags: [SubjectModel]!
    
    private(set) public var rating: RatingModel!

    private(set) public var videoLanguage: String!
    
    private(set) public var popular: Bool!
    private(set) public var isSeries: Int!
    private(set) public var isMyPlaylistValue: Bool! = false
    private(set) public var isInWatchlist: Bool! = false
    private(set) public var commentPolicy: Int32!
    private(set) public var commentCount: Int32!
    
    private(set) public var secureVideoSource: String?
    private(set) public var defaultVideoSource: String?
    
    private(set) public var items: Array<ItemModel>!
    private(set) public var itemsCount: Int = 0
    
    private(set) public var created: Date?
    private(set) public var changed: Date?
    
    private(set) public var subdomain: String?
    private(set) public var isInstitution: Bool! = false
    
    
    // MARK: - Init methods
    
    
    init(itemID: String!,
         status: Bool!,
         title:String!,
         tagline: String!,
         descriptionText: String!,
         path: String?,
         images: ImageModel?,
         classification: String!,
         hasBurnInCaption: Bool!,
         yearOfProduction: String!,
         runningTime: Int32!,
         subtype: String!,
         ownedContent: Bool!,
         director: [String]!,
         popular: Bool!,
         isSeries: Int!,
         commentPolicy: Int32!,
         commentCount: Int32!,
         secureVideoSource: String?,
         defaultVideoSource: String?,
         created: Date?,
         changed: Date?,
         items: [ItemModel],
         subject: [SubjectModel]!,
         subjects: [SubjectModel]!,
         filmmakers: [SubjectModel]!,
         cast: [SubjectModel]!,
         languages: [SubjectModel]!,
         tags: [SubjectModel]!,
         rating: RatingModel!,
         itemsCount: Int,
         hasCaptions: Bool!,
         isInWatchlist: Bool!) {
        
        super.init()
        
        self.itemID = itemID
        self.status = status
        self.title = title
        self.tagline = tagline
        self.descriptionText = descriptionText
        self.path = path
        self.images = images
        self.classification = classification
        self.hasBurnInCaption = hasBurnInCaption
        self.yearOfProduction = yearOfProduction
        self.runningTime = runningTime
        self.subtype = subtype
        self.ownedContent = ownedContent
        self.director = director
        self.popular = popular
        self.isSeries = isSeries
        self.commentPolicy = commentPolicy
        self.commentCount = commentCount
        self.secureVideoSource = secureVideoSource
        self.defaultVideoSource = defaultVideoSource
        self.created = created
        self.changed = changed
        self.cast = cast
        self.items = items
        self.subject = subject
        self.subjects = subjects
        self.languages = languages
        self.filmmakers = filmmakers
        self.cast = cast
        self.tags = tags
        self.rating = rating
        self.itemsCount = itemsCount
        self.hasCaptions = hasCaptions
        self.isInWatchlist = isInWatchlist
    }
    
    
    init(itemID: String!, title:String!, subdomain:String!, isInstitution: Bool) {
        
        super.init()
        
        self.itemID = itemID
        self.title = title
        self.subdomain = subdomain
        self.isInstitution = isInstitution
    }
    
    
    init(itemID: String!, title:String!, isMyPlaylistValue: Bool) {
        
        super.init()
        
        self.itemID = itemID
        self.title = title
        self.isMyPlaylistValue = isMyPlaylistValue
    }
    
    
    init(title: String!) {
        super.init()
        
        self.title = title
        self.subtype = "product"
    }
    
    
    init(itemID: String!) {
        super.init()
        
        self.itemID = itemID
        self.title = "Title"
        self.subtype = "product"
    }
    
    // MARK: -
    
    
    open func updateItems(items: Array<ItemModel>!) {
        self.items = items
    }
    
    
    open func insertItems(items: Array<ItemModel>!) {
        self.items.append(contentsOf: items)
    }
    
    
    open func isMovie() -> Bool {
        return self.subtype == TypeItem.productKey
    }
    
    
    open func isSupplier() -> Bool {
        return self.subtype == TypeItem.collectionKey && self.isSeries == 0
    }
    
    
    open func isCommercialPlaylist() -> Bool {
        return self.subtype == TypeItem.collectionKey && self.isSeries == 2
    }
    
    
    open func isEpisodes() -> Bool {
        return self.subtype == TypeItem.collectionKey && self.isSeries == 1
    }
    
    
    open func isPlaylist() -> Bool {
        return self.subtype == TypeItem.playlistKey
    }
    
    
    open func isMyPlaylist() -> Bool {
        return self.isMyPlaylistValue
    }
    
    
    open func updateIsInMyWathclist(_ value: Bool!) {
        self.isInWatchlist = value
    }
}
