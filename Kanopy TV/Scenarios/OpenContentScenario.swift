//
//  OpenContentScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/24/17.
//
//

import UIKit

protocol OpenContentScenarioDelegate {
    
}

class OpenContentScenario: Scenario, GenericContentVCDelegate, OpenContentScenarioDelegate, MoreInfoVCDelegate, PlayMovieScenarioDelegate {

    private(set) var rootVC: UIViewController!
    private(set) var itemModel: ItemModel!
    private(set) var delegate: OpenContentScenarioDelegate!
    open var contentVC: GenericContentVC!
    private(set) var pageViewID: String = ""
    private(set) var playMovieScenario: PlayMovieScenario!
    
    
    // MARK: - Init methods 
    
    
    init(rootVC: UIViewController!, item: ItemModel!, delegate: OpenContentScenarioDelegate) {
        super.init()
        
        self.delegate = delegate
        self.rootVC = rootVC
        self.itemModel = item
    }
    
    
    // MARK: - Override methods 
    
    
    override func start() {
        
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: -
    
    
    open func loadItem(completion: @escaping (ItemModel) -> Void,
                       cacheCompletion: @escaping (ItemModel) -> Void,
                       failure: @escaping (ErrorModel) -> Void) {
        
        self.getPageViewID()
        
        VideoService.sharedInstance.getVideoItem(videoID: self.itemModel.itemID,
                                                 completion: { (item: ItemModel) in
                                                    self.itemModel = item
                                                    completion(item)
        }, cachedCompletion: { (item: ItemModel) in
            self.itemModel = item
            cacheCompletion(item)
        }) { (error: ErrorModel) in
            failure(error)
            
            UIAlertController.showAlert(title: error.titleError, message: error.messageError!, fromVC: self.contentVC, okButton: { 
                self.contentVC.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
    func getPageViewID() {
        
        VideoService.sharedInstance.analyticsPageView(self.itemModel.itemID,
                                                      refVideoID: self.itemModel.itemID,
                                                      completion: { (pageViewID: String) in
                                                        self.pageViewID = pageViewID
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: error.titleError,
                                        message: error.messageError!,
                                        fromVC: self.contentVC!)
        }
    }
    
    
    // MARK: - 
    
    
    func didPressToItem(itemModel: ItemModel!) {
        ContentScenarioFactory.scenario(withItem: itemModel, rootVC: self.contentVC, delegate: self)?.start()
    }
    
    
    func didPressToWatchlistButton() {
        if self.itemModel.isInWatchlist {
            self.didPressRemoveFromWatchlistButton()
        } else {
            self.didPressAddToWatchlistButton()
        }
    }
    
    
    func didPressShowMoreButton() {
        let vm = MoreInfoVM.init(itemModel: self.itemModel)
        let moreVC = MoreInfoVC.init(viewModel: vm, delegate: self)
        
        self.contentVC.present(moreVC, animated: false, completion: nil)
        moreVC.updateViewModel(vm)
    }
    
    
    func didPressToPlayButton() {
        
        if AuthService.sharedInstance.isAuthorized() {
            self.playMovieScenario = PlayMovieScenario.init(item: self.itemModel,
                                                            rootVC: self.contentVC,
                                                            delegate: self)
            self.playMovieScenario.start()
        } else {
            UIAlertController.showAlert(title: "You are not authorized", message: "Please login in app with your Kanopy account", fromVC: self.contentVC)
        }
        
    }
    
    
    func didPressAddToWatchlistButton() {
        
        let myWatchlist = AuthService.sharedInstance.user.myWathclistID
        
        if myWatchlist != nil {
            
            let loadVC = LoadVC()
            
            self.contentVC.present(loadVC, animated: true, completion: nil)
            
            PlaylistService.sharedInstance.insertItemToPlaylist(itemID: self.itemModel.itemID,
                                                                playlistID: myWatchlist,
                                                                completion: {
                                                                    self.itemModel.updateIsInMyWathclist(true)
                                                                    let vm = ContentVM.init(itemModel: self.itemModel,
                                                                                            bgThumbURL: URL.init(string:(self.itemModel.images?.mediumThumbURL())!),
                                                                                            suggestedVideos: self.contentVC.viewModel.suggestedVideos, delegate: self)
                                                                    self.contentVC.updateViewModel(vm)
                                                                    self.contentVC.dismiss(animated: true, completion: nil)
                                                                    
            }) { (error: ErrorModel) in
                self.contentVC.dismiss(animated: true, completion: nil)
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.contentVC!)
            }
        }
    }
    
    
    func didPressRemoveFromWatchlistButton() {
        
        let myWatchlist = AuthService.sharedInstance.user.myWathclistID
        
        if myWatchlist != nil {
            
            let loadVC = LoadVC()
            
            self.contentVC.present(loadVC, animated: true, completion: nil)
            
            PlaylistService.sharedInstance.removeItemFromPlaylist(itemID: self.itemModel.itemID,
                                                                  playlistID: myWatchlist,
                                                                  completion: {
                                                                    
                                                                    self.itemModel.updateIsInMyWathclist(false)
                                                                    let vm = ContentVM.init(itemModel: self.itemModel,
                                                                                            bgThumbURL: URL.init(string:(self.itemModel.images?.mediumThumbURL())!),
                                                                                            suggestedVideos: self.contentVC.viewModel.suggestedVideos, delegate: self)
                                                                    self.contentVC.updateViewModel(vm)
                                                                    self.contentVC.dismiss(animated: true, completion: nil)
            }, failure: { (error: ErrorModel) in
                self.contentVC.dismiss(animated: true, completion: nil)
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.contentVC!)
            })
        }
    }
}
