//
//  RequestService.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/15/17.
//
//

import UIKit

protocol RequestServiceDelegate {
    
    func notifyAboutUnauthorization(requestService: RequestService!)
}

class RequestService: NSObject {

    
    /// Instance
    static var sharedInstance = RequestService()
    
    private var observers: NSMutableArray?
    
    var authApi: SWGAuthApi?
    var homePageApi: SWGHomePageApi?
    var videoApi: SWGVideoApi?
    var analyticsApi: SWGAnalyticsApi?
    var playlistApi: SWGPlaylistsApi?
    var shelfApi: SWGShelfApi?
    var searchApi: SWGSearchApi?
    var userAPI: SWGUserApi?
    
    // MARK: - Init methods
    
    
    override init() {
        super.init()
        
        InjectedMap.baseURL = "https://api.kanopystreaming.com/v1.1/"
        SWGDefaultConfiguration.sharedConfig().setDefaultHeaderValue(InjectedMap.xVersionHeaderValueTVOS, forKey: "X-version")
        SWGDefaultConfiguration.sharedConfig().setDefaultHeaderValue(InjectedMap.UserAgentHeaderValueTVOS, forKey: "User-Agent")
        
        self.observers = NSMutableArray.init()
    }
    
    
    // MARK: - Observers methods
    
    
    open func addObserver(observer: RequestServiceDelegate!) {
        if !(self.observers?.contains(observer))! {
            self.observers?.add(observer)
        }
    }
    
    
    open func removeObserver(observer: RequestServiceDelegate!) {
        if (self.observers?.contains(observer))! {
            self.observers?.remove(observer)
        }
    }
    
    
    open func notifyAllObserversAboutUnauthorized() {
        let observersArray = self.observers
        
        for delegate in observersArray! {
            let dg = delegate as! RequestServiceDelegate
            dg.notifyAboutUnauthorization(requestService: self)
        }
    }
    
    
    // MARK: - Auth
    
    
    open func checkAuthAPI() {
        if self.authApi == nil {
            self.authApi = SWGAuthApi()
        }
    }
    
    
    open func activateAuthcode(authcode: String!,
                               completion: ((String, UserModel) -> Void)?,
                               failure: ((ErrorModel) -> Void)?) {
        
        if !self.checkInternetConnection(failure: failure!) {
            return
        }
        
        self.checkAuthAPI()
        
        let authcodeBody = SWGAuthcodeBody.init()
        authcodeBody.authcode = authcode
        
        _ = self.authApi?.authcodesActivatePost(withAuthcode: authcodeBody,
                                                authorization: self.token()){ (response: SWGSignupResponse?, error: Error?) in
                                                    
                                                    if error == nil {
                                                        let swgUser = response?.user!
                                                        completion!((response?.token)!, (swgUser?.userModel())!)
                                                    } else {
                                                        failure!((error?.errorModel())!)
                                                    }
        }
    }
    
    
    open func signIn(_ email: String!,
                     _ password: String!,
                     completion: ((String, UserModel) -> Void)?,
                     failure: ((ErrorModel) -> Void)?) {
        
        if !self.checkInternetConnection(failure: failure!) {
            return
        }
        
        let loginDataBody = SWGLoginDataBody()
        loginDataBody.mail = email
        loginDataBody.pass = password
        
        self.checkAuthAPI()
        
        _ = self.authApi?.signinPost(with: loginDataBody,
                                     authorization: self.token()) { (response: SWGSignupResponse?, error: Error?) in
                                        
                                        if error == nil {
                                            let swgUser = response?.user!
                                            completion!((response?.token)!, (swgUser?.userModel())!)
                                        } else {
                                            failure!((error?.errorModel())!)
                                        }
        }
    }
    
    
    open func signUp(_ firstName: String!,
                     _ lastName: String!,
                     _ email: String!,
                     _ password: String!,
                     completion: ((String, UserModel) -> Void)?,
                     failure: ((ErrorModel) -> Void)?) {
        
        if !self.checkInternetConnection(failure: failure!) {
            return
        }
        
        let signUpDataBody = SWGSignUpDataBody()
        signUpDataBody.firstName = firstName
        signUpDataBody.lastName = lastName
        signUpDataBody.mail = email
        signUpDataBody.pass = password
        
        self.checkAuthAPI()
        
        _ = self.authApi?.signupPost(with: signUpDataBody, authorization: self.token(),
                                     completionHandler: { (response: SWGSignupResponse?, error: Error?) in
                                        
                                        if error == nil {
                                            completion!((response?.token)!, (response?.user?.userModel())!)
                                        } else {
                                            failure!((error?.errorModel())!)
                                        }
        })
    }
    
    
    open func signInWithSocial(provider: String!,
                               token: String!,
                               completion: ((String, UserModel) -> Void)?,
                               failure: ((ErrorModel) -> Void)?)
    {
        if !self.checkInternetConnection(failure: failure!) {
            return
        }
        
        self.checkAuthAPI()
        
        let socialBody = SWGSocialDataBody()
        socialBody.provider = provider
        socialBody.accessToken = token
        
        _ = self.authApi?.signinSocialPost(with: socialBody,
                                           authorization: self.token(),
                                           completionHandler: { (response: SWGSignupResponse?, error: Error?) in
                                            
                                            if error == nil {
                                                let swgUser = response?.user!
                                                completion!((response?.token)!, (swgUser?.userModel())!)
                                            } else {
                                                failure!((error?.errorModel())!)
                                            }
        })
    }
    
    
    open func signUpWithSocial(provider: String!,
                               token: String?,
                               completion: ((String, UserModel) -> Void)?,
                               failure: ((ErrorModel) -> Void)?)
    {
        if !self.checkInternetConnection(failure: failure!) {
            return
        }
        
        self.checkAuthAPI()
        
        let socialBody = SWGSocialDataBody()
        socialBody.provider = provider
        
        socialBody.accessToken = token
        
        _ = self.authApi?.signupSocialPost(with: socialBody,
                                           authorization: self.token(),
                                           completionHandler: { (response: SWGSignupResponse?, error: Error?) in
                                            
                                            if error == nil {
                                                let swgUser = response?.user!
                                                completion!((response?.token)!, (swgUser?.userModel())!)
                                            } else {
                                                failure!((error?.errorModel())!)
                                            }
        })
    }
    
    
    open func checkStatusVerification(userID: String!,
                                      completion: @escaping ((StatusActivationModel) -> Void!),
                                      failure: @escaping ((ErrorModel) -> Void!)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkAuthAPI()
        
        _ = self.authApi?.usersUserIdActivateStatusGet(withUserId: userID,
                                                       authorization: self.token(),
                                                       completionHandler: { (response: SWGActivationStatusObject?, error: Error?) in
                                                        
                                                        if error == nil {
                                                            completion((response?.statusModel())!)
                                                        } else {
                                                            failure((error?.errorModel())!)
                                                        }
        })
    }
    
    
    open func resendEmail(userID: String!,
                          completion: @escaping (() -> Void!),
                          failure: @escaping ((ErrorModel) -> Void!)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkAuthAPI()
        
        _ = self.authApi?.usersUserIdActivateResendPost(withUserId: userID,
                                                        authorization: self.token(),
                                                        completionHandler: { (response: SWGActivateResendResponse?, error: Error?) in
                                                            
                                                            if error == nil {
                                                                completion()
                                                            } else {
                                                                failure((error?.errorModel())!)
                                                            }
        })
    }
    
    
    open func resetPassword(email: String!,
                            completion: (() -> Void)?,
                            failure: ((ErrorModel) -> Void)?) {
        
        if !self.checkInternetConnection(failure: failure!) {
            return
        }
        
        self.checkAuthAPI()
        
        let body = SWGResetPasswordObject()
        body.mail = email
        
        _ = self.authApi?.accountPasswordResetPost(withBody: body,
                                                   authorization: self.token(),
                                                   completionHandler: { (response: NSObject?, error: Error?) in
                                                    
                                                    if error == nil {
                                                        completion!()
                                                    } else {
                                                        failure!((error?.errorModel())!)
                                                    }
        })
    }
    
    
    open func getToken(authToken: String?,
                       completion: @escaping ((String, UserModel) -> Void),
                       failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkAuthAPI()
        
        _ = self.authApi?.handshakeGet(withAuthorization: authToken) { (response: SWGHandshakeResponse?, error: Error?) in
            
            if error == nil {
                completion((response?.token)!, (response?.user.userModel())!)
            } else {
                failure((error?.errorModel())!)
            }
        }
    }
    
    
    // MARK: - Displays
    
    
    open func checkHomePageAPI() {
        if self.homePageApi == nil {
            self.homePageApi = SWGHomePageApi()
        }
    }
    
    
    open func displays(completion: @escaping (([ShelfModel], [CategoryModel], UserModel, [CategoryModel]) -> Void),
                       cacheCompletion: @escaping (([ShelfModel], [CategoryModel], UserModel, [CategoryModel]) -> Void),
                       failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkHomePageAPI()
        
        let isHomepage = NSNumber.init(value: true)
        let isCategories = NSNumber.init(value: true)
        let isRokuHorizontal = NSNumber.init(value: true)
        let isRokuMenu = NSNumber.init(value: true)
        
        let task = self.homePageApi?.displayGet(withAuthorization: self.token(),
                                                homepage: isHomepage,
                                                categories: isCategories,
                                                rokuHorizontalCategories: isRokuHorizontal,
                                                rokuMenuCategories: isRokuMenu) { (response:SWGDisplayResponse?, error: Error?) in
                                                    
                                                    if error == nil {
                                                        
                                                        response?.parseForAppleTV(completion: completion)
                                                        
                                                    } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                        failure((error?.errorModel())!)
                                                    }
        }
        
        
        let data = CacheService.sharedInstance.dataFromFile(task?.currentRequest?.url?.key())
        
        if data != nil {
            
            do {
                let response: SWGDisplayResponse = try self.homePageApi?.apiClient.responseDeserializer.deserialize(data, class: SWGDisplayResponse.description()) as! SWGDisplayResponse
                
                response.parseForAppleTV(completion: cacheCompletion)
                
            } catch  {
                print(error)
            }
        }
    }
    
    
    // MARK: - Shelves
    
    
    open func checkShelfAPI() {
        if self.shelfApi == nil {
            self.shelfApi = SWGShelfApi()
        }
    }
    
    /** Method return all slelves for category
     - parameter categoryID:  category id (term id)
     - parameter completion:  Completion block. Return categoris array
     - parameter failure:  Failure block. Return error object
     */
    open func shelves(categoryID: String!,
                      completion: @escaping ((Array<ShelfModel>) -> Void!),
                      failure: @escaping ((ErrorModel) -> Void!)){
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        var categoryIDNumber = NSNumber.init(value: 0)
        
        if let myInteger = Int(categoryID) {
            categoryIDNumber = NSNumber(value:myInteger)
        }
        
        self.checkShelfAPI()
        
        let task = shelfApi?.shelfgroupsTermIdentifierGet(withIdentifier: categoryIDNumber, authorization: self.token(), includeVideoSources: NSNumber.init(value: 0)) { (response: SWGGetShelvesGroupResponse?, error: Error?) in
            
            if error == nil {
                response?.parse(completion: completion)
            } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                failure((error?.errorModel())!)
            }
        }
        
        let data = CacheService.sharedInstance.dataFromFile(task?.currentRequest?.url?.key())
        
        if data != nil {
            
            do {
                let response: SWGGetShelvesGroupResponse = try self.shelfApi?.apiClient.responseDeserializer.deserialize(data, class: SWGGetShelvesGroupResponse.description()) as! SWGGetShelvesGroupResponse
                response.parse(completion: completion)
            } catch  {
                print(error)
            }
        }
    }
    
    
    open func shelf(shelfHash: String!,
                    completion: @escaping ((ShelfModel) -> Void!),
                    failure: @escaping ((ErrorModel) -> Void!)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkShelfAPI()
        
        let task = self.shelfApi?.shelvesShelfIdGet(withShelfId: shelfHash,
                                                    authorization: self.token(),
                                                    includeVideoSources: NSNumber.init(value: 0)) { (shelf: SWGShelf?, error: Error?) in
                                                        
                                                        if error == nil {
                                                            completion((shelf?.shelf())!)
                                                        } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                            failure((error?.errorModel())!)
                                                        }
        }
        
        let data = CacheService.sharedInstance.dataFromFile(task?.currentRequest?.url?.key())
        
        if data != nil {
            
            do {
                let response: SWGShelf = try self.shelfApi?.apiClient.responseDeserializer.deserialize(data, class: SWGShelf.description()) as! SWGShelf
                response.parse(completion: completion)
            } catch  {
                print(error)
            }
        }
    }
    
    
    
    open func shelfItems(shelfID: String!,
                         offset: Int!,
                         limit: Int!,
                         completion: ((Array<ItemModel>) -> Void)?,
                         failure: ((ErrorModel) -> Void)?) {
        
        if !self.checkInternetConnection(failure: failure!) {
            return
        }
        
        self.checkShelfAPI()
        
        _ = self.shelfApi?.shelvesShelfIdItemsGet(withShelfId: shelfID,
                                                  authorization: self.token(),
                                                  limit: NSNumber.init(value: limit),
                                                  offset: NSNumber.init(value: offset),
                                                  completionHandler: { (response: SWGGetShelfItemsResponse?, error: Error?) in
                                                    
                                                    if error == nil {
                                                        
                                                        var items = [ItemModel]()
                                                        
                                                        for video in (response?.items)! {
                                                            let vd: SWGVideoList = video as! SWGVideoList
                                                            items.append(vd.video())
                                                        }
                                                        
                                                        completion!(items)
                                                        
                                                    } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                        failure!((error?.errorModel())!)
                                                    }
        })
    }
    
    
    // MARK: - Categories
    
    
    open func categories(completion: @escaping ((Array<CategoryModel>) -> Void!),
                         failure: @escaping ((ErrorModel) -> Void!)) {
        
        //        let categoriesApi = SWGCategoriesApi()
        //        categoriesApi.categoriesGet { (response: SWGInlineResponse2004?, error: Error?) in
        //            if error == nil {
        //
        //                var categories = [CategoryModel]()
        //
        //                for category in (response?.categories)! {
        //                    let ct: SWGCategories = category as! SWGCategories
        //                    if ct.parents.last == "0" {
        //                        categories.append(ct.categoriesModel())
        //                    }
        //                }
        //
        //                completion(categories)
        //
        //            } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
        //                failure((error?.errorModel())!)
        //            }
        //        }
    }
    
    
    // MARK: - Videos
    
    
    open func checkVideoAPI() {
        if self.videoApi == nil {
            self.videoApi = SWGVideoApi()
        }
    }
    
    
    open func checkSearchApi() {
        if self.searchApi == nil {
            self.searchApi = SWGSearchApi()
        }
    }
    
    
    open func searchVideos(text: String!,
                           offset: Int!,
                           limit: Int!,
                           completion: @escaping ((Array<ItemModel>, Int) -> Void),
                           failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        let offset = NSNumber.init(value: offset)
        let limit = NSNumber.init(value: limit)
        let ivs = NSNumber.init(value: 0)
        
        self.checkSearchApi()
        _ = self.searchApi?.searchKeywordsGet(withKeywords: text,
                                              authorization: self.token(),
                                              offset: offset,
                                              limit: limit,
                                              sort: NSNumber.init(value: 0),
                                              includeVideoSources: ivs) { (response: SWGSearchResult?, error: Error?) in
                                                if error == nil {
                                                    var videos = [ItemModel]()
                                                    
                                                    if response?.videos != nil {
                                                        for video in (response?.videos)! {
                                                            let vd: SWGVideoList = video as! SWGVideoList
                                                            videos.append(vd.video())
                                                        }
                                                    }
                                                    
                                                    var count: Int = 0
                                                    
                                                    if response?.numFound != nil {
                                                        count = (response?.numFound.intValue)!
                                                    }
                                                    
                                                    completion(videos, count)
                                                    
                                                } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                    failure((error?.errorModel())!)
                                                }
        }
    }
    
    
    open func searchInstitutions(text: String!,
                                 completion: @escaping ((Array<ItemModel>, Array<ItemModel>) -> Void),
                                 failure: @escaping ((ErrorModel) -> Void)) {
        
        self.checkSearchApi()
        
        //        _ = self.searchApi.institutionsSearchGet(withQuery: text,
        //                                                  authorization: self.token(),
        //                                                  completionHandler: { (response: SWGInstitutionsResponse?, error: Error?) in
        //
        //                                                    if error == nil {
        //                                                        var suggestedInstitutions = [ItemModel]()
        //                                                        var otherInstitutions = [ItemModel]()
        //
        //                                                        if response?.result.suggested.results != nil {
        //                                                            for institution in (response?.result.suggested.results)! {
        //                                                                let insti: SWGInstitution = institution as! SWGInstitution
        //                                                                suggestedInstitutions.append(ItemModel.init(itemID: insti._id, title: insti.title, subdomain: insti.subdomain, isInstitution: true))
        //                                                            }
        //                                                        }
        //
        //                                                        if response?.result.other.results != nil {
        //                                                            for institution in (response?.result.other.results)! {
        //                                                                let insti: SWGInstitution = institution as! SWGInstitution
        //                                                                otherInstitutions.append(ItemModel.init(itemID: insti._id, title: insti.title, subdomain: insti.subdomain, isInstitution: true))
        //                                                            }
        //                                                        }
        //
        //                                                        completion(suggestedInstitutions, otherInstitutions)
        //
        //                                                    } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
        //                                                        failure((error?.errorModel())!)
        //                                                    }
        //        })
    }
    
    
    open func recommendVideos(videoID: String!,
                              offset: Int!,
                              limit: Int!,
                              completion: @escaping ((Array<ItemModel>) -> Void),
                              failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkVideoAPI()
        
        _ = self.videoApi?.videosVideoIdRecommendationsGet(withVideoId: videoID,
                                                           authorization: self.token(),
                                                           limit: NSNumber.init(value: limit),
                                                           offset: NSNumber.init(value: offset),
                                                           includeVideoSources: NSNumber.init(value: 0)) { (response: SWGRecommendedVideoResult?, error: Error?) in
                                                            if error == nil {
                                                                var videos = [ItemModel]()
                                                                
                                                                if response?.items != nil {
                                                                    for video in (response?.items)! {
                                                                        let vd: SWGVideoList = video as! SWGVideoList
                                                                        videos.append(vd.video())
                                                                    }
                                                                }
                                                                
                                                                completion(videos)
                                                                
                                                            } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                                failure((error?.errorModel())!)
                                                            }
        }
    }
    
    
    open func videosForItem(videoID: String!,
                            offset: Int!,
                            limit: Int!,
                            completion: @escaping ((Array<ItemModel>) -> Void),
                            cachedCompletion: @escaping ((Array<ItemModel>) -> Void),
                            failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkVideoAPI()
        
        let task = self.videoApi?.videosVideoIdItemsGet(withVideoId: videoID,
                                                        authorization: self.token(),
                                                        limit: NSNumber.init(value: limit),
                                                        offset: NSNumber.init(value: offset),
                                                        includeVideoSources: NSNumber.init(value: 0)) { (response: SWGRecommendedVideoResult?, error: Error?) in
                                                            
                                                            if error == nil {
                                                                response?.parse(completion: completion)
                                                                
                                                            } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                                failure((error?.errorModel())!)
                                                            }
        }
        
        
        let data = CacheService.sharedInstance.dataFromFile(task?.currentRequest?.url?.key())
        
        if data != nil {
            
            do {
                let response: SWGRecommendedVideoResult = try self.videoApi?.apiClient.responseDeserializer.deserialize(data, class: SWGRecommendedVideoResult.description()) as! SWGRecommendedVideoResult
                response.parse(completion: cachedCompletion)
            } catch {
                print(error)
            }
        }
    }
    
    
    func getVideoItem(videoID: String!,
                      completion: @escaping ((ItemModel) -> Void),
                      cachedCompletion: @escaping ((ItemModel) -> Void),
                      failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkVideoAPI()
        
        _ = self.videoApi?.videosVideoIdGet(withVideoId: videoID,
                                            authorization: self.token(),
                                            completionHandler: { (item: SWGVideoList?, error: Error?) in
                                                
                                                if error == nil {
                                                    completion((item?.video())!)
                                                } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                    failure((error?.errorModel())!)
                                                }
        })
    }
    
    
    // MARK: - Analytics
    
    
    open func checkAnalyticsAPI() {
        if self.analyticsApi == nil {
            self.analyticsApi = SWGAnalyticsApi()
        }
    }
    
    
    open func analyticsPageView(_ videoID: String!, refVideoID: String!,
                                completion: @escaping ((String) -> Void),
                                failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        let pageViewBody = SWGPageViewBody()
        pageViewBody.nid = videoID
        pageViewBody.refNid = refVideoID
        
        self.checkAnalyticsAPI()
        
        _ = self.analyticsApi?.analyticsPageviewsPost(with: pageViewBody, authorization: self.token()) { (response: SWGPageviewResponse?, error: Error?) in
            if error == nil {
                completion((response?.pageviewId)!)
            } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                failure((error?.errorModel())!)
            }
        }
    }
    
    
    open func videoPlaybackDetails(_ videoID: String!,
                                   pageViewID: String!,
                                   completion: @escaping ((PlaybackDetailsModel) -> Void),
                                   failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkVideoAPI()
        
        _ = self.videoApi?.videosVideoIdPlaybackPageviewIdGet(withVideoId: videoID,
                                                              pageviewId: pageViewID, authorization: self.token()) { (response: SWGVideoPlaybackDetails?, error: Error?) in
                                                                
                                                                if error == nil {
                                                                    completion((response?.playbackDetails())!)
                                                                } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                                    failure((error?.errorModel())!)
                                                                }
        }
    }
    
    
    open func sendAnalytics(videoPlayID: String!,
                            from: UInt,
                            to: UInt)
    {
        self.checkVideoAPI()
        
        let body = SWGSendAnalyticsBody()
        
        body.fromMs = NSNumber.init(value: from)
        body.toMs = NSNumber.init(value: to)
        
        _ = self.videoApi?.analyticsPlaybacksVideoplayIdPut(withVideoplayId: videoPlayID,
                                                            body: body,
                                                            authorization: self.token(),
                                                            completionHandler: { (response: SWGAnalyticsPlaybackResponse?, error: Error?) in
                                                                
        })
    }
    
    
    open func getCaptions(videoID: String!,
                          completion: @escaping (([CaptionModel]) -> Void),
                          failure: @escaping ((ErrorModel) -> Void)) {
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        let videoApi = SWGVideoApi()
        videoApi.videosVideoIdCaptionsGet(withVideoId: videoID,
                                          authorization: self.token()) { (response:SWGCaptionsResponse?, error: Error?) in
                                            
                                            if error == nil {
                                                
                                                var captions = [CaptionModel]()
                                                
                                                if response?.captions != nil {
                                                    for cpt in (response?.captions)! {
                                                        let caption: SWGCaption = cpt as! SWGCaption
                                                        captions.append(caption.caption())
                                                    }
                                                }
                                                
                                                completion(captions)
                                                
                                            } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                failure((error?.errorModel())!)
                                            }
        }
    }
    
    
    // MARK: - Playlists
    
    
    open func checkPlaylistAPI() {
        if self.playlistApi == nil {
            self.playlistApi = SWGPlaylistsApi()
        }
    }
    
    
    func myPlaylist(completion: @escaping ((Array<PlaylistModel>) -> Void),
                    failure: @escaping ((ErrorModel) -> Void))
    {
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkPlaylistAPI()
        
        let task = self.playlistApi?.playlistsGet(withAuthorization: self.token()) { (response: SWGPlaylistResponse?, error: Error?) in
            
            if error == nil {
                response?.parse(completion: completion)
            } else {
                failure((error?.errorModel())!)
            }
        }
        
        let data = CacheService.sharedInstance.dataFromFile(task?.currentRequest?.url?.key())
        
        if data != nil {
            
            do {
                let response: SWGPlaylistResponse = try self.playlistApi?.apiClient.responseDeserializer.deserialize(data, class: SWGPlaylistResponse.description()) as! SWGPlaylistResponse
                response.parse(completion: completion)
            } catch  {
                print(error)
            }
        }
    }

    
    open func playlistDetails(playlistID: String!,
                              offset: Int!,
                              limit: Int!,
                              completion: @escaping (([ItemModel]) -> Void),
                              cachedCompletion: @escaping (([ItemModel]) -> Void),
                              failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkPlaylistAPI()
        
        let task = self.playlistApi?.playlistsPlaylistIdItemsGet(withPlaylistId: playlistID,
                                                                 authorization: self.token(),
                                                                 offset: NSNumber.init(value: offset),
                                                                 limit: NSNumber.init(value: limit)) { (response: SWGPlaylistItemsResponse?, error: Error?) in
                                                                    
                                                                    if error == nil {
                                                                        response?.parse(completion: completion)
                                                                        
                                                                    } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                                        failure((error?.errorModel())!)
                                                                    }
        }
        
        let key = task?.currentRequest?.url?.key()
        let data = CacheService.sharedInstance.dataFromFile(key)
        
        if data != nil {
            
            do {
                let response: SWGPlaylistItemsResponse = try self.playlistApi?.apiClient.responseDeserializer.deserialize(data, class: SWGPlaylistItemsResponse.description()) as! SWGPlaylistItemsResponse
                response.parse(completion: cachedCompletion)
            } catch  {
                print(error)
            }
        }
    }
    
    
    /** This method insert video item to a playlist
     - parameter itemID: Video item identifier
     - parameter playlistID: Playlist indentifier
     - parameter completion:  Completion block.
     - parameter failure:  Failure block. Return error object
     */
    open func insertItemToPlaylist(itemID: String!, playlistID: String!,
                                   completion: (() -> Void)?,
                                   failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkPlaylistAPI()
        
        _ = self.playlistApi?.playlistsPlaylistIdVideosVideoIdPost(withPlaylistId: playlistID,
                                                                   videoId: itemID, authorization: self.token(),
                                                                   completionHandler: { (response: NSObject?, error: Error?) in
                                                                    
                                                                    if error == nil {
                                                                        completion!()
                                                                    } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                                        failure((error?.errorModel())!)
                                                                    }
        })
    }
    
    
    /** This method removes video item to a playlist
     - parameter itemID: Video item identifier
     - parameter playlistID: Playlist indentifier
     - parameter completion:  Completion block.
     - parameter failure:  Failure block. Return error object
     */
    open func removeItemToPlaylist(itemID: String!, playlistID: String!,
                                   completion: (() -> Void)?,
                                   failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkPlaylistAPI()
        
        _ = self.playlistApi?.playlistsPlaylistIdVideosVideoIdDelete(withPlaylistId: playlistID, videoId: itemID, authorization: self.token(),
                                                                     completionHandler: { (response: NSObject?, error: Error?) in
                                                                        if error == nil {
                                                                            completion!()
                                                                        } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                                            failure((error?.errorModel())!)
                                                                        }
        })
    }
    
    
    // MARK: - User
    
    
    open func checkUserAPI() {
        if self.userAPI == nil {
            self.userAPI = SWGUserApi()
        }
    }
    
    
    open func getMeUser(completion: ((UserModel) -> Void)?,
                        cacheCompletion: ((UserModel) -> Void)?,
                        failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkUserAPI()
        
        let task = self.userAPI?.usersMeGet(withAuthorization: self.token(),
                                            completionHandler: { (response: SWGUserProfile?, error: Error?) in
                                                
                                                if error == nil {
                                                    completion!((response?.userModel())!)
                                                } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                    failure((error?.errorModel())!)
                                                }
        })
        
        let data = CacheService.sharedInstance.dataFromFile(task?.currentRequest?.url?.key())
        
        if data != nil {
            
            do {
                let response: SWGUserProfile = try self.userAPI?.apiClient.responseDeserializer.deserialize(data, class: SWGUserProfile.description()) as! SWGUserProfile
                cacheCompletion!(response.userModel())
            } catch  {
                print(error)
            }
        }
    }
    
    
    open func switchMembership(identity: Int!,
                               completion: ((String) -> Void)?,
                               failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkUserAPI()
        
        _ = self.userAPI?.identitiesIdentityIdSwitchGet(withAuthorization: self.token(),
                                                        identityId: NSNumber.init(value: identity),
                                                        completionHandler: { (resposne: SWGSwitchIdentityResponse?, error: Error?) in
                                                            if error == nil {
                                                                completion!((resposne?.token)!)
                                                            } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                                                                failure((error?.errorModel())!)
                                                            }
        })
    }
    
    
    open func getAutologinUrl(userID: String!, destination: String!, hashtag: String!,
                              completion: ((String) -> Void)?,
                              failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkAuthAPI()
        
        _ = self.authApi?.usersUserIdAutologinGet(withUserId: userID, authorization: self.token(), destination: destination, hashtag: hashtag, completionHandler: { (response: SWGUserAutologinUrl?, error: Error?) in
            
            if error == nil {
                if (response?.url != nil) {
                    completion!((response?.url)!)
                } else {
                    let errorModel = ErrorModel.init("ERROR".localized, "No URL in response", statusCode: 0, type: "Missing element in response")
                    failure(errorModel)
                }
                
            } else if !self.checkErrorToUnauthorized(error: error?.errorModel()) {
                failure((error?.errorModel())!)
            }
        })
    }
    
    
    // MARK: -
    
    
    private func token() -> String {
        return "Bearer " + AuthService.sharedInstance.sessionToken!
    }
    
    
    private func checkErrorToUnauthorized(error: ErrorModel!) -> Bool {
        
        if error.statusCode == 401 && (error.type == "authError" || error.type == "expired" || error.type == "required") {
            self.notifyAllObserversAboutUnauthorized()
            return true
        }
        
        return false
    }
    
    
    
    open func breakAllRequests() {
    }

    
    // MARK: - For Apple TV
    
    
    open func getAuthCode(completion: @escaping ((String) -> Void),
                          failure: @escaping ((ErrorModel) -> Void)) {
        
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkAuthAPI()
        
        _ = self.authApi?.authcodesGeneratePost(withDeviceId: UIDevice.current.identifierForVendor?.uuidString, authorization: self.token(),
                                                completionHandler: { (response: SWGInlineResponse200?, error: Error?) in
                                                    
                                                    if error == nil {
                                                        completion((response?.authcode)!)
                                                    } else {
                                                        failure((error?.errorModel())!)
                                                    }
        })
    }
    
    
    open func authCodeVerification(authCode: String?,
                                   completion: @escaping ((String, UserModel?) -> Void),
                                   failure: @escaping ((ErrorModel) -> Void)) {
        if !self.checkInternetConnection(failure: failure) {
            return
        }
        
        self.checkAuthAPI()
        
        let token = self.token()
        
        let autcb = SWGAuthcodeBody.init()
        autcb.authcode = authCode
        
        _ = self.authApi?.authcodesAuthenticatePost(with: autcb,
                                                    authorization: token,
                                                    completionHandler: { (response: SWGAuthenticateUsingAnAuthenticationCodeResponse?, error: Error?) in
                                                        if error == nil && response?.token != nil {
                                                            completion((response?.token)!, response?.user.userModel())
                                                        } else if error == nil && response?.token == nil {
                                                            completion("", nil)
                                                        } else {
                                                            failure((error?.errorModel())!)
                                                        }
        })
    }
    
    
    private func checkInternetConnection(failure: ((ErrorModel) -> Void!)) -> Bool {
        
        if !self.isInternetAvailable() {
            failure(ErrorModel.init("Slow Internet?", "There seems to be a problem with your Internet connection.", statusCode: 0, type: ""))
            return false
        } else {
            return true
        }
    }
    
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
