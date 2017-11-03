//
//  OpenContentScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/16/17.
//
//

import UIKit
import MBProgressHUD
import SystemConfiguration
import GoogleCast

protocol OpenContentScenarioDelegate {
    
}

class OpenContentScenario: GenericScenario, ContentVCDelegate, PlayMovieScenarioDelegate {

    var delegate: OpenContentScenarioDelegate?
    var item: ItemModel!
    private(set) var pageViewID: String = ""
    var completionLoadPageViewBlock: (() -> Void)!
    
    var contentVC: ContentVC?
    
    
    // MARK: - Init methods 
    
    
    init(nvc: MenuNavigationController!, item: ItemModel!, delegate: OpenContentScenarioDelegate?) {
        
        super.init()
        
        self.nvc = nvc
        self.item = item
        self.delegate = delegate
    }
    
    
    // MARK: - Override Start/Stop methods
    
    
    override func start() {
        super.start()
    }
    
    
    override func stop() {
        super.stop()
    }
    
    
    // MARK: - Tools
    
    
    open func showContentVC(withTitle title: String!) {
        self.contentVC = ContentVC.init(title: title, delegate: self)
        self.contentVC?.searchDelegate = self
        self.contentVC?.showLoadIndicator()
        
        self.nvc.pushViewController(self.contentVC!, animated: true)
    }
    
    
    open func loadItem(completion: @escaping (ItemModel) -> Void,
                       cacheCompletion: @escaping (ItemModel) -> Void,
                       failure: @escaping (ErrorModel) -> Void) {
        
        self.getPageViewID()
        
        VideoService.sharedInstance.getVideoItem(videoID: self.item.itemID,
                                                 completion: { (item: ItemModel) in
            self.item = item
                                                    completion(item)
        }, cachedCompletion: { (item: ItemModel) in
            self.item = item
            cacheCompletion(item)
        }) { (error: ErrorModel) in
            failure(error)
            UIAlertController.showAlert(title: error.titleError,
                                        message: error.messageError!,
                                        fromVC: self.contentVC!)
        }
    }
    
    
    func loadVideosForItem(_ vc: ContentVC!, viewModel: GenericContentVM!) {
        vc.showLoadIndicator()
        
        VideoService.sharedInstance.videosForItem(videoID: self.item.itemID,
                                                  offset: viewModel.offset,
                                                  limit: viewModel.limit,
                                                  completion: { (items: Array<ItemModel>) in
                                                    vc.hideLoadIndicator()
                                                    self.item.updateItems(items: items)
                                                    viewModel.didLoadVideos(videos: items)
                                                    vc.updateViewModel(contentVM: viewModel)
        }, cachedCompletion: { (items: Array<ItemModel>) in
            vc.hideLoadIndicator()
            self.item.updateItems(items: items)
            viewModel.didLoadVideos(videos: items)
            vc.updateViewModel(contentVM: viewModel)
        }) { (error: ErrorModel) in
            vc.hideLoadIndicator()
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: vc)
        }
    }
    
    
    func startPlayMovieScenario(parentVC: GenericVC!, item: ItemModel!) {
        if item == nil {
            return
        }

        let session = GCKCastContext.sharedInstance().sessionManager

        if ((session.hasConnectedCastSession() || SettingsService.sharedInstance.cellularDataUsage() || ReachabilityService.sharedInstance.currentReachabilityStatus == .reachableViaWiFi) && ReachabilityService.sharedInstance.currentReachabilityStatus != .notReachable) {
            let title = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus?.currentQueueItem?.mediaInformation.metadata?.string(forKey: kGCKMetadataKeyTitle)
        
            if (title != nil && title == item.title) {
                UIAlertController.showAlert(title: "THIS_MOVIE_IS_ALREADY_PLAYING".localized, message: "", fromVC: self.contentVC!)
            } else {
                let mpScenario = PlayMovieScenario.init(genericVC: parentVC, delegate: self, pageViewID: self.pageViewID)
                mpScenario.update(item,
                                  nextItem: self.nextVideo(item: item),
                                  refNid: self.item.itemID,
                                  playNextTimerSeconds: self.playNextVideoTimerValue())
        
                mpScenario.start()
            }
        } else if (ReachabilityService.sharedInstance.currentReachabilityStatus == .reachableViaWWAN) {
            UIAlertController.showAlert(title: "CELLULAR_DATA_DISABLED".localized, message: "CELLULAR_DATA_DISABLED_DESCRIPTION".localized, fromVC: self.contentVC!)
        } else if (ReachabilityService.sharedInstance.currentReachabilityStatus == .notReachable) {
            UIAlertController.showAlert(title: "NO_CONNECTION".localized, message: "NO_CONNECTION_DESCRIPTION".localized, fromVC: self.contentVC!)
        }
    }

    
    func getPageViewID() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        VideoService.sharedInstance.analyticsPageView(self.item.itemID,
            refVideoID: self.item.itemID,
            completion: { (pageViewID: String) in
            self.pageViewID = pageViewID
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }) { (error: ErrorModel) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            UIAlertController.showAlert(title: error.titleError,
                                        message: error.messageError!,
                                        fromVC: self.contentVC!)
        }
    }
    
    
    func openNextVideo(playMovieScenario: PlayMovieScenario!, item: ItemModel?) {
        
        if item != nil {
            
            playMovieScenario.update(item,
                                     nextItem: self.nextVideo(item: item),
                                     refNid: self.item.itemID,
                                     playNextTimerSeconds: self.playNextVideoTimerValue())
            
            playMovieScenario.playNextVideo()
            
        } else {
            self.stopPlayMovieScenario(playMovieScenario)
        }
        
        
    }
    
    
    func nextVideo(item: ItemModel!) -> ItemModel? {
        
        if self.item.isMovie() {
            return nil
        }
        
        if self.item.items.last != item {
            
            let currentIndex: Int? = self.item.items.index(of: item)
            
            if currentIndex == nil {
                return nil
            }
            
            let nextItemIndex = currentIndex! + 1
            return self.item.items[nextItemIndex]
            
        } else {
            return nil
        }
    }
    
    
    func stopPlayMovieScenario(_ playMovieScenario: PlayMovieScenario!) {
        playMovieScenario.stop()
    }
    
    
    // MARK: - ContentVCDelegate methods 
    
    
    func didPressToBackButton(contentVC: ContentVC!) {
        _ = self.nvc.popViewController(animated: true)
    }
    
    
    func didPressToItem(item: ItemModel!, contentVC: ContentVC!) {
        self.openItem(parentVC: contentVC, item: item)
    }
    
    
    func didPressToPlayButton(item: ItemModel!, contentVC: ContentVC!) {
        self.startPlayMovieScenario(parentVC: contentVC, item: item)
    }
    
    
    func didPressAddToWatchlistButton() {
        
        let myWatchlist = PlaylistService.sharedInstance.myWathchlist()
        
        if myWatchlist != nil {
            
            let loadingNotification = MBProgressHUD.showAdded(to: (self.contentVC?.view)!, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            
            PlaylistService.sharedInstance.insertItemToPlaylist(itemID: self.item.itemID,
                                                                playlistID: myWatchlist?.playlistID,
                                                                completion: {
                                                                    
                                                                    loadingNotification.hide(animated: true)
                                                                    
                                                                    self.item.updateIsInMyWathclist(true)
                                                                    self.contentVC?.viewModel.removeAdditionalCellModel()
                                                                    myWatchlist?.insertItem()
                                                                    
                                                                    self.contentVC?.updateViewModel(contentVM: self.contentVC?.viewModel)
            }) { (error: ErrorModel) in
                loadingNotification.hide(animated: true)
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.contentVC!)
            }
        }
    }
    
    
    func didPressRemoveFromWatchlistButton() {
        
        let myWatchlist = PlaylistService.sharedInstance.myWathchlist()
        
        if myWatchlist != nil {
            
            let loadingNotification = MBProgressHUD.showAdded(to: (self.contentVC?.view)!, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            
            PlaylistService.sharedInstance.removeItemFromPlaylist(itemID: self.item.itemID,
                                                                  playlistID: myWatchlist?.playlistID,
                                                                  completion: { 
                                                                    loadingNotification.hide(animated: true)
                                                                    
                                                                    self.item.updateIsInMyWathclist(false)
                                                                    self.contentVC?.viewModel.removeAdditionalCellModel()
                                                                    myWatchlist?.removeItem()
                                                                    self.contentVC?.updateViewModel(contentVM: self.contentVC?.viewModel)
            }, failure: { (error: ErrorModel) in
                loadingNotification.hide(animated: true)
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: self.contentVC!)
            })
        }
    }
    
    
    func didPressToRecommendItem(item: ItemModel!) {
        self.openItemScreen(parentVC: self.contentVC, item: item)
    }
    
    
    func didPressToAllSeeRecommendButton(shelf: ShelfModel!) {
        self.openRecommendedVideos(parentVC: contentVC, shelf: shelf)
    }
    
    
    func loadRecommendItems(shelfCellModel: ShelfCellModel!, offset: Int!) {
        
        VideoService.sharedInstance.getRecommendVideos(videoID: self.item.itemID,
                                                       offset: offset,
                                                       limit: Constants.shelfItemsLimit,
                                                       completion: { (items: Array<ItemModel>) in
                                                         shelfCellModel.updateShelfItems(items: items)
                                                        self.contentVC?.updateViewModel(contentVM: self.contentVC?.viewModel)
        }) { (error: ErrorModel) in
            shelfCellModel.updateShelfItems(items: [])
        }
    }
    
    
    func loadItemsForItem(contentVC: ContentVC!) {
        
        if !self.item.isMovie() {
            VideoService.sharedInstance.videosForItem(videoID: self.item.itemID,
                                                      offset: contentVC.viewModel.offset,
                                                      limit: contentVC.viewModel.limit,
                                                      completion: { (items: Array<ItemModel>) in
                                                        
                                                        self.item.insertItems(items: items)
                                                        contentVC.viewModel.didLoadVideos(videos: items)
                                                        contentVC.updateViewModel(contentVM: contentVC.viewModel)
            }, cachedCompletion: { (items: Array<ItemModel>) in
                
            }) { (error: ErrorModel) in
                UIAlertController.showAlert(title: "ERROR".localized,
                                            message: error.messageError!,
                                            fromVC: contentVC)
            }
        }
    }
    
    
    // MARK: - PlayMovieScenarioDelegate methods 
    
    
    func didFinishVideoPlaying(playMovieScenario: PlayMovieScenario!, item: ItemModel, isClickedNextView: Bool!) {
        
        self.stopPlayMovieScenario(playMovieScenario)
    }
    
    
    func playNextVideoTimerValue() -> Float64 {
        return Float64(0)
    }
    
    
    // MARK: - Override methods 
    
    
    func openRecommendedVideos(parentVC: GenericVC!, shelf: ShelfModel) {
        self.currentOpenShelf = shelf
        
        let subCategoryVM = SubCategoryVM.init(shelf: shelf)
        let subCategoryVC = SubCategoryVC.init(title: shelf.title,
                                               subCategoryVM: subCategoryVM,
                                               delegate: self)
        subCategoryVC.searchDelegate = self
        parentVC.navigationController?.pushViewController(subCategoryVC, animated: true)
        
        subCategoryVC.showLoadIndicator()
        
        // PredictiIO sends 40 results per page
        VideoService.sharedInstance.getRecommendVideos(videoID: shelf.shelfID,
                                                       offset: 0,
                                                       limit: 40,
            completion: { (items: Array<ItemModel>) -> Void in
                
                subCategoryVC.hideLoadIndicator()
                subCategoryVM.updateVideos(videos: shelf.items)
                subCategoryVC.updateViewModel(subCategoryVM: subCategoryVM)
                
        }) { (error: ErrorModel) -> Void in
            subCategoryVC.hideLoadIndicator()
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: subCategoryVC)
        }
    }
    
    
    func openItem(parentVC: GenericVC!, item: ItemModel!) {
        if self.pageViewID.characters.count > 0 {
            self.startPlayMovieScenario(parentVC: parentVC, item: item)
        }
    }
    
    
    override func loadItems(subCategoryVC: SubCategoryVC!) {
        // PredictiIO sends 40 results per page
        VideoService.sharedInstance.getRecommendVideos(videoID: self.currentOpenShelf.shelfID,
                                                       offset: subCategoryVC.viewModel.offset,
                                                       limit: 40,
                                                       completion: { (items: Array<ItemModel>) -> Void in
                                                        
                                                        subCategoryVC.viewModel.insertItems(items: items)
                                                        
                                                        DispatchQueue.main.async {
                                                            subCategoryVC.updateTableView(subCategoryVC.viewModel)
                                                            subCategoryVC.viewModel.checkIsCanDownload(items.count)
                                                        }
                                                        
        }) { (error: ErrorModel) -> Void in
            subCategoryVC.viewModel.insertItems(items: [])
            subCategoryVC.updateViewModel(subCategoryVM: subCategoryVC.viewModel)
        }
    }
}
