//
//  WatchlistScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/9/17.
//
//

import UIKit

protocol WatchlistScenarioDelegate {
    
}

class WatchlistScenario: Scenario, WatchlistVCDelegate, GenericVCDelegate, OpenContentScenarioDelegate {

    private(set) var rootVC: UITabBarController!
    private(set) var delegate: WatchlistScenarioDelegate!
    private(set) var watchlistVC: WatchlistVC!
    private(set) var watchlistVCNC: UINavigationController!
    private(set) var watchlist: PlaylistModel!
    
    
    // MARK: - Init methods 
    
    
    init(rootVC: UITabBarController!, delegate: WatchlistScenarioDelegate!) {
        super.init()
        
        self.rootVC = rootVC
        self.delegate = delegate
        
        self.createWatchlistVC()
    }
    
    
    // MARK: - 
    
    
    override func start() {
        self.loadWatchlistVideos {
            self.getItemsForPlaylist()
        }
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: - Private tools 
    
    
    private func createWatchlistVC() {
        self.watchlistVC = WatchlistVC.init(delegate: self)
        self.watchlistVC.genericVCDelegate = self
        self.watchlistVCNC = UINavigationController.init(rootViewController: self.watchlistVC)
        self.watchlistVCNC.tabBarItem = UITabBarItem.init(title: "Watchlist".localized, image: nil, tag: 1)
        
        self.watchlistVC.showLoadIndicator()
    }
    
    
    private func loadWatchlistVideos(completion: @escaping () -> Void) {
        
        PlaylistService.sharedInstance.myPlaylist(completion: { (playlists: Array<PlaylistModel>) in
            
            self.watchlist = self.getMyPlaylist(playlists: playlists)
            completion()
            
        }) { (error: ErrorModel) in
            
            self.watchlistVC.hideLoadIndicator()
            UIAlertController.showAlert(title: error.titleError, message: error.messageError!, fromVC: self.watchlistVC)
        }
    }

    
    private func getItemsForPlaylist() {
        
        PlaylistService.sharedInstance.playlistDetails(playlistID: self.watchlist.playlistID,
                                                       offset: 0, limit: 100,
                                                       completion: { (items: [ItemModel]) in
             
                                                        self.watchlistVC.hideLoadIndicator()
                                                        
                                                        let vm = WatchlistVM.init(delegate: self,
                                                                                  playlist: self.watchlist,
                                                                                  items: items)
                                                        
                                                        self.watchlistVC.updateViewModel(vm)
                                                        
        }, cachedCompletion: { (items: [ItemModel]) in
            
        }) { (error: ErrorModel) in
            self.watchlistVC.hideLoadIndicator()
             UIAlertController.showAlert(title: error.titleError, message: error.messageError!, fromVC: self.watchlistVC)
        }
    }
    
    
    private func getMyPlaylist(playlists: Array<PlaylistModel>) -> PlaylistModel? {
        
        for pm in playlists {
            if pm.playlistID == AuthService.sharedInstance.user.myWathclistID {
                return pm
            }
        }
        
        return nil
    }
    
    
    // MARK: - GenericVCDelegate methods 
    
    
    func viewWillAppear() {
        self.start()
    }
    
    
    // MARK: -
    
    
    func didPressToItem(item: ItemModel!) {
        ContentScenarioFactory.scenario(withItem: item, rootVC: self.watchlistVC, delegate: self)?.start()
    }
}
