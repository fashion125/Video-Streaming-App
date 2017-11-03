//
//  OpenEpisodeScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 15.06.17.
//
//

import UIKit

class OpenEpisodeScenario: OpenContentScenario {

    // MARK: - Init method
    
    
    override init(nvc: MenuNavigationController!, item: ItemModel!, delegate: OpenContentScenarioDelegate?) {
        
        super.init(nvc: nvc, item: item, delegate: delegate)
    }
    
    
    // MARK: - Override Start/Stop methods
    
    
    override func start() {
        super.start()
        self.showEpisodesScreen()
    }
    
    
    override func stop() {
        super.stop()
    }
    
    
    // MARK: - Tools
    
    
    func showEpisodesScreen() {
        self.showContentVC(withTitle: "COLLECTION_PLAYLIST".localized)
        self.loadItem()
    }
    
    
    func loadItem() {
        
        self.loadItem(completion: { (item: ItemModel) in
            self.updateViewModel()
            self.contentVC?.hideLoadIndicator()
            self.loadVideosForItem(self.contentVC!, viewModel: self.contentVC?.viewModel)
        }, cacheCompletion: { (item: ItemModel) in
            self.updateViewModel()
            self.contentVC?.hideLoadIndicator()
        }) { (error: ErrorModel) in
            self.contentVC?.hideLoadIndicator()
        }
    }
    
    
    func updateViewModel() {
        let contentVM = EpisodesCollectionContentVM.init(item: item, contentVCDelegate: self)
        self.contentVC?.updateViewModel(contentVM: contentVM)
    }
    
    
    // MARK: - Override methods 
    
    
    override func playNextVideoTimerValue() -> Float64 {
        return Float64(45)
    }
    
    
    override func didFinishVideoPlaying(playMovieScenario: PlayMovieScenario!, item: ItemModel, isClickedNextView: Bool!) {
        
        self.openNextVideo(playMovieScenario: playMovieScenario,
                           item: self.nextVideo(item: item))
    }
}
