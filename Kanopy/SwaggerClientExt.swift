//
//  SwaggerClientExt.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/7/17.
//
//

import Foundation
import SwaggerClient

extension SWGCurrentShelf {
    
    func shelf() -> ShelfModel {
        
        var items = [ItemModel]()
        
        for video in self.items {
            let v: SWGVideoList = video as! SWGVideoList
            items.append(v.video())
        }
        
        let shelf = ShelfModel.init(shelfID: self.hashShelf,
                                    title: self.title,
                                    itemType: self.itemType,
                                    items: items,
                                    created: Date.init(timeIntervalSince1970: TimeInterval(self.created.intValue)),
                                    changed: Date.init(timeIntervalSince1970: TimeInterval(self.changed.intValue)))
        return shelf
    }
}

extension SWGVideoList {
    
    func video() -> ItemModel {
        
        var itms = [ItemModel]()
        
        if self.items != nil {
            for video in self.items {
                let v: SWGVideoList = video as! SWGVideoList
                itms.append(v.video())
            }
        }
        
        var svs = ""
        var dvs = ""
        
        if self.videoSources != nil && self.videoSources.hls != nil {
            if self.videoSources.hls.secure != nil {
                svs = self.videoSources.hls.secure
            }
            
            if self.videoSources.hls._default != nil {
                dvs = self.videoSources.hls._default
            }
        }
        
        let item = ItemModel.init(itemID: self.nid.stringValue,
                                  status: self.status.boolValue,
                                  title: self.title,
                                  tagline: self.tagline,
                                  descriptionText: self.descriptionText,
                                  path: self.path,
                                  images: self.images != nil ? self.images.images() : ImageModel(),
                                  classification: self.classification,
                                  hasBurnInCaption: self.hasBurntInCaptions.boolValue,
                                  yearOfProduction: self.yearOfProduction.stringValue,
                                  runningTime: self.runningTime.int32Value,
                                  subtype: self.subtype,
                                  ownedContent: self.ownedContent.boolValue,
                                  director: self.director,
                                  popular: self.popular.boolValue,
                                  isSeries: self.isSeries.intValue,
                                  commentPolicy: self.commentPolicy.int32Value,
                                  commentCount: self.commentCount.int32Value,
                                  secureVideoSource: svs,
                                  defaultVideoSource: dvs,
                                  created: Date.init(timeIntervalSince1970: TimeInterval(self.created.intValue)),
                                  changed: Date.init(timeIntervalSince1970: TimeInterval(self.changed.intValue)),
                                  items: itms,
                                  subject: self.taxonomies.getSubject(),
                                  subjects: self.taxonomies.getSubjects(),
                                  filmmakers: self.taxonomies.getFilmmakers(),
                                  cast: self.taxonomies.getCast(),
                                  languages: self.taxonomies.getLanguages(),
                                  tags: self.taxonomies.getTags(),
                                  rating: RatingModel.init(count: self.ratings.count == nil ? 0 : self.ratings.count.intValue,
                                                           average: self.ratings.average == nil ? 0 : self.ratings.average.intValue),
                                  itemsCount: self.nbItems != nil ? self.nbItems.intValue : 0,
                                  hasCaptions: self.hasCaptions.boolValue,
                                  isInWatchlist: self.isInWatchlist.boolValue)
        
        return item
    }
}

extension SWGVideoListImages {
    
    func images() -> ImageModel {
        let imageModel = ImageModel.init(roku_small: self.roku != nil ? self.roku.small : "",
                                         roku_medium: self.roku != nil ? self.roku.medium : "",
                                         screenshots_small:self.screenshots != nil ? self.screenshots.small : "",
                                         screenshots_medium: self.screenshots != nil ? self.screenshots.medium : "")
        
        return imageModel
    }
}

extension SWGCategory {
    
    func categoriesModel() -> CategoryModel {
        
        var subCategories = [CategoryModel]()
        
        if self.children != nil {
            for swgCategory in self.children {
                let c: SWGCategory = swgCategory as! SWGCategory
                subCategories.append(c.categoriesModel())
            }
        }
        
        
        let categoryModel = CategoryModel.init(termID:String(self.tid.intValue),
                                               vocabularyID: String(self.vid.intValue),
                                               name: self.name,
                                               vocabulary: self.vocabulary,
                                               subcategory: subCategories)
        
        return categoryModel
    }
}

extension SWGShelf {
    
    func shelf() -> ShelfModel {
        
        var items = [ItemModel]()
        
        for video in self.items {
            let v: SWGVideoList = video as! SWGVideoList
            items.append(v.video())
        }
        
        let shelf = ShelfModel.init(shelfID: self.hashShelf,
                                    title: self.title,
                                    itemType: self.itemType,
                                    items: items,
                                    created: Date.init(timeIntervalSince1970: TimeInterval(self.created.intValue)),
                                    changed: Date.init(timeIntervalSince1970: TimeInterval(self.changed.intValue)))
        return shelf
    }
}


extension SWGVideoPlaybackDetails {
    
    func playbackDetails() -> PlaybackDetailsModel {
        
        var defaultURL = ""
        
        if self.videoSources != nil && self.videoSources.hls != nil && self.videoSources.hls._default != nil {
            defaultURL = self.videoSources.hls._default
        }
        
        var secureURL = ""
        
        if self.videoSources != nil && self.videoSources.hls != nil && self.videoSources.hls.secure != nil {
            secureURL = self.videoSources.hls.secure
        }
        
        
        var vpID = ""
        
        if self.videoplayId != nil {
            vpID = self.videoplayId
        }
        
        var resumePositionValue: UInt = 0
        
        if self.resumePlayPos != nil {
            resumePositionValue = self.resumePlayPos.uintValue
        }
        
        let pd = PlaybackDetailsModel(videoPlayID: vpID,
                                      videoPlayPosition: resumePositionValue,
                                      secureURL: secureURL,
                                      defaultURL: defaultURL)
        
        return pd
    }
}


extension SWGVideoListTaxonomies {
    
    func getSubject() -> Array<SubjectModel>{
        
        if self.subject == nil {
            return [SubjectModel]()
        } else {
            return self.subject.subjectModels()
        }
    }
    
    func getSubjects() -> Array<SubjectModel>{
        
        if self.subjects == nil {
            return [SubjectModel]()
        } else {
            return self.subjects.subjectModels()
        }
    }
    
    func getFilmmakers() -> Array<SubjectModel>{
        
        if self.filmmakers == nil {
            return [SubjectModel]()
        } else {
            return self.filmmakers.subjectModels()
        }
    }
    
    func getCast() -> Array<SubjectModel>{
        
        if self.cast == nil {
            return [SubjectModel]()
        } else {
            return self.cast.subjectModels()
        }
    }
    
    func getLanguages() -> Array<SubjectModel>{
        
        if self.languages == nil {
            return [SubjectModel]()
        } else {
            return self.languages.subjectModels()
        }
    }
    
    func getTags() -> Array<SubjectModel>{
        
        if self.tags == nil {
            return [SubjectModel]()
        } else {
            return self.tags.subjectModels()
        }
    }
}


extension SWGCaption {
    
    func caption() -> CaptionModel {
        
        let caption = CaptionModel.init(hashCaption: self.hashCaption,
                                        created: self.created.intValue,
                                        changed: self.changed.intValue,
                                        url_webvtt: self.urlWebvtt,
                                        url_dfxp: self.urlDfxp,
                                        url_activetranscript: self.urlActivetranscript,
                                        language: self.lang)
        
        return caption
    }
}


extension SWGUserPlaylist {
    
    func playlist() -> PlaylistModel {
        
        let playlist = PlaylistModel.init(self.nid,
                                          self.title,
                                          self.isWatchlist.boolValue,
                                          self.nbItems.intValue)
        
        return playlist
    }
}

extension SWGVideoPlaylist {
    
    func video() -> ItemModel {
        
        var itms = [ItemModel]()
        
        if self.sourceVideo != nil && self.sourceVideo.items != nil {
            for video in self.sourceVideo.items {
                let v: SWGVideoList = video as! SWGVideoList
                itms.append(v.video())
            }
        }
        
        var svs = ""
        var dvs = ""
        
        if self.sourceVideo != nil && self.sourceVideo.videoSources != nil && self.sourceVideo.videoSources.hls != nil {
            if self.sourceVideo.videoSources.hls.secure != nil {
                svs = self.sourceVideo.videoSources.hls.secure
            }
            
            if self.sourceVideo.videoSources.hls._default != nil {
                dvs = self.sourceVideo.videoSources.hls._default
            }
        }
        
        let item = ItemModel.init(itemID: self.sourceVideo.nid.stringValue,
                                  status: self.sourceVideo.status.boolValue,
                                  title: self.sourceVideo.title,
                                  tagline: self.sourceVideo.tagline,
                                  descriptionText: self.sourceVideo.descriptionText,
                                  path: self.sourceVideo.path,
                                  images: self.sourceVideo.images != nil ? self.sourceVideo.images.images() : ImageModel(),
                                  classification: self.sourceVideo.classification,
                                  hasBurnInCaption: self.sourceVideo.hasBurntInCaptions.boolValue,
                                  yearOfProduction: self.sourceVideo.yearOfProduction.stringValue,
                                  runningTime: self.sourceVideo.runningTime.int32Value,
                                  subtype: self.sourceVideo.subtype,
                                  ownedContent: self.sourceVideo.ownedContent.boolValue,
                                  director: self.sourceVideo.director,
                                  popular: self.sourceVideo.popular.boolValue,
                                  isSeries: self.sourceVideo.isSeries.intValue,
                                  commentPolicy: self.sourceVideo.commentPolicy.int32Value,
                                  commentCount: self.sourceVideo.commentCount.int32Value,
                                  secureVideoSource: svs,
                                  defaultVideoSource: dvs,
                                  created: Date.init(timeIntervalSince1970: TimeInterval(self.sourceVideo.created.intValue)),
                                  changed: Date.init(timeIntervalSince1970: TimeInterval(self.sourceVideo.changed.intValue)),
                                  items: itms,
                                  subject: self.sourceVideo.taxonomies.getSubject(),
                                  subjects: self.sourceVideo.taxonomies.getSubjects(),
                                  filmmakers: self.sourceVideo.taxonomies.getFilmmakers(),
                                  cast: self.sourceVideo.taxonomies.getCast(),
                                  languages: self.sourceVideo.taxonomies.getLanguages(),
                                  tags: self.sourceVideo.taxonomies.getTags(),
                                  rating: RatingModel.init(count: self.sourceVideo.ratings.count == nil ? 0 : self.sourceVideo.ratings.count.intValue,
                                                           average: self.sourceVideo.ratings.average == nil ? 0 : self.sourceVideo.ratings.average.intValue),
                                  itemsCount: self.sourceVideo.nbItems != nil ? self.sourceVideo.nbItems.intValue : 0,
                                  hasCaptions: false,
                                  isInWatchlist: self.sourceVideo.isInWatchlist.boolValue)
        
        return item
    }
}


extension SWGActivationStatusObject {
    
    func statusModel() -> StatusActivationModel {
        
        
        let statusModel = StatusActivationModel.init(isVerifyEmail: self.steps.emailActivated.boolValue,
                                                     isAddMembership: self.steps.identityAdded.boolValue,
                                                     isMembershipStatusLookup: self.steps.identityActivated.boolValue,
                                                     isVerifyAccount: complete.boolValue)
        
        return statusModel
    }
}


extension SWGUserProfile {
    
    func userModel() -> UserModel {
        
        if self.uid.intValue == 0 {
            return UserModel.init(anonymousUserWithUserID: self.uid.stringValue,
                                  displayName: self.displayName)
        }
        
        let user = UserModel.init(userID: self.uid.stringValue,
                                  username: String.concatenate(withFirstValue: self.firstName, self.lastName),
                                  displayName: self.displayName,
                                  mail: self.mail,
                                  status: self.status.boolValue,
                                  statusKey: self.statusKey,
                                  currentIdentity: self.currentIdentity.identity(),
                                  avatar: self.avatar != nil ? self.avatar : "",
                                  myWathclistID: self.watchlistNid != nil ? String(self.watchlistNid.intValue) : "")
        
        if self.identities != nil {
            
            var idts = [IdentityModel]()
            let dict = self.identities as! NSDictionary
            let array: Array<NSDictionary> = dict.allValues as! Array<NSDictionary>
            
            for dct in array {
                
                let ID: NSNumber = dct.value(forKey: "identity_id") as! NSNumber
                let creditAvailable = dct.value(forKey: "credit_available") as? NSNumber
                
                let im = IdentityModel.init(ID: ID.intValue,
                                            status: dct.value(forKey: "status") as! Bool,
                                            domainName: dct.value(forKey: "domain_name") as! String,
                                            isDefault: dct.value(forKey: "is_default") as! Bool,
                                            creditAvailable: creditAvailable != nil ? (creditAvailable?.intValue)! : -1,
                                            statusKey: dct.value(forKey: "status_key") as! String,
                                            expirationDate: Date(),
                                            domainStem: dct.value(forKey: "domain_stem") as! String)
                
                idts.append(im)
            }
            
            user.identities = idts
        }
        
        return user
    }
}

extension SWGUserAutologinUrl {
    
    func autologinModel() -> AutologinModel {
        
        return AutologinModel.init(url: self.url)
 
    }
}


extension SWGUserProfileCurrentIdentity {
    
    func identity() -> IdentityModel {
        
        var dateInt = 0
        
        if self.expirationDate != nil {
            dateInt = self.expirationDate.intValue
        }
        
        
        let im = IdentityModel.init(ID: self.identityId.intValue,
                                    status: self.status.boolValue,
                                    domainName: self.domainName,
                                    isDefault: self.isDefault.boolValue,
                                    creditAvailable: NSNumber.checkNil(self.creditAvailable).intValue,
                                    statusKey: self.statusKey,
                                    expirationDate: Date.init(timeIntervalSince1970: TimeInterval(dateInt)),
                                    domainStem: self.domainName)
        
        return im
    }
}


extension NSNumber {
    
    static func checkNil(_ value:  NSNumber?) -> NSNumber {
        
        if (value != nil) {
            return value!
        }
        
        return NSNumber.init(value: -1)
    }
}

//extension NSDictionary {
//    func userModel() -> UserModel {
//        
//        let user = UserModel.init(userID: String(self.object(forKey: "uid")),
//                                  username: "",
//                                  displayName: String(self.object(forKey:"first_name")) + " " + String(self.object(forKey:"last_name")),
//                                  mail: String(self.object(forKey:"mail"])),
//                                  status: false,
//                                  statusKey: "")
//        
//        return user
//    }
//
//}


extension Array {
    
    func subjectModels() -> Array<SubjectModel> {
        
        var items = [SubjectModel]()
        
        for it in self {
            let v: SWGSubject = it as! SWGSubject
            items.append(SubjectModel.init(tid: v.tid.intValue,
                                           vid: v.vid.intValue,
                                           name: v.name,
                                           vocabulary: v.vocabulary))
        }
        
        return items
    }
}
