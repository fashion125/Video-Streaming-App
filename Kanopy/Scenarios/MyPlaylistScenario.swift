//
//  MyPlaylistScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 14.05.17.
//
//

import UIKit
import MBProgressHUD

protocol MyPlaylistScenarioDelegate {
    
}

class MyPlaylistScenario: GenericScenario, PlaylistVCDelegate {

    private(set) var delegate: MyPlaylistScenarioDelegate!
    private(set) var playlistModel: PlaylistModel!
    private(set) var playlistVC: PlaylistVC!
    
    
    // MARK: - Init method
    
    
    init(nvc: MenuNavigationController!, delegate: MyPlaylistScenarioDelegate!, playlistModel: PlaylistModel!) {
        
        super.init()
        
        self.nvc = nvc
        self.delegate = delegate
        self.playlistModel = playlistModel
    }
    
    
    // MARK: - Override methods 
    
    
    override func start() {
        self.showPlaylistScreen()
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: - Tools 
    
    
    func showPlaylistScreen() {
        
        self.playlistVC = PlaylistVC.init(title: "MY_WATCHLIST".localized, delegate: self)
        self.playlistVC?.searchDelegate = self
        
        self.nvc.setViewControllers([self.playlistVC], animated: false)
        self.firstLoadData()
    }
    
    
    func firstLoadData() {
        
        self.playlistVC?.showLoadIndicator()
        
        PlaylistService.sharedInstance.playlistDetails(playlistID: playlistModel.playlistID,
                                                       offset: 0,
                                                       limit: Constants.itemsLimit,
                                                       completion: { (videos: [ItemModel]) in
                                                        self.createViewModel(videos)
                                                        
                                                        /*
                                                         AFO
                                                         Little trick used here to load 14 (2*7).
                                                         This is due to a limitation of the API which doesn't allow us to select the number of element per page
                                                         that we want. The problem is that 7 elements is too small for iPads or iPhone Plus so it doesn't
                                                         load more.
                                                         @todo: remove this trick once the API allow us to choose the number of element per page that we want
                                                         */
                                                        if (videos.count > 0 && videos.count >= Constants.itemsLimit) {
                                                            self.loadItems(playlistVC: self.playlistVC)
                                                        }
        }, cachedCompletion: { (videos: [ItemModel]) in
            self.createViewModel(videos)
        }) { (error: ErrorModel) in
            self.playlistVC?.hideLoadIndicator()
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.playlistVC!)
        }
    }
    
    
    func createViewModel(_ videos: [ItemModel]) {
        let playlistVM = PlaylistVM.init(playlistModel: self.playlistModel, items: videos, delegate: self)
        self.playlistVC?.updateViewModel(contentVM: playlistVM)
        self.playlistVC?.hideLoadIndicator()
    }
    
    
    // MARK: - PlaylistVCDelegate
    
    
    func didPressToMenuButton(item: MyPlaylistItemCellModel!) {
        let menuVM = PlaylistMenuVM.init(itemCM: item, delegate: self)
        self.playlistVC.openMenu(withMenuViewModel: menuVM)
    }
    
    
    func didPressToItem(item: ItemModel!) {
        self.openItemScreen(parentVC: self.playlistVC, item: item)
    }
    
    
    func loadItems(playlistVC: PlaylistVC!) {
        
        PlaylistService.sharedInstance.playlistDetails(playlistID: self.playlistModel.playlistID,
                                                       offset: playlistVC.viewModel.offset,
                                                       limit: Constants.itemsLimit,
                                                       completion: { (videos: [ItemModel]) in
                                                        playlistVC.viewModel.insertItems(items: videos)
                                                        playlistVC.updateViewModel(contentVM: playlistVC.viewModel)
        }, cachedCompletion: { (videos: [ItemModel]) in
            
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.playlistVC!)
        }
    }
    
    
    func didPressToRemoveButton() {
        
        let loadingNotification = MBProgressHUD.showAdded(to: (self.playlistVC?.view)!, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        
        PlaylistService.sharedInstance.removeItemFromPlaylist(itemID: self.playlistVC.menuViewModel.itemCM.item.itemID,
                                                              playlistID: self.playlistVC.viewModel.playlistModel.playlistID,
                                                              completion: {
                                                                
                                                                loadingNotification.hide(animated: true)
                                                                self.playlistVC.viewModel.removeItem(cellModel: self.playlistVC.menuViewModel.itemCM)
                                                                self.playlistVC.updateViewModel(contentVM: self.playlistVC.viewModel)
                                                                self.playlistVC.hideMenu()
        }) { (error: ErrorModel) in
            
            loadingNotification.hide(animated: true)
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.playlistVC!)
        }
        
    }
    
    
    func didPressToCancelButton() {
        self.playlistVC.hideMenu()
    }
}
