//
//  OpenMovieScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 15.06.17.
//
//

import UIKit

class OpenMovieScenario: OpenContentScenario {

    // MARK: - Init method
    
    
    override init(nvc: MenuNavigationController!, item: ItemModel!, delegate: OpenContentScenarioDelegate?) {
        
        super.init(nvc: nvc, item: item, delegate: delegate)
    }
    
    
    // MARK: - Override Start/Stop methods
    
    
    override func start() {
        super.start()
        self.showMovieScreen()
    }
    
    
    override func stop() {
        super.stop()
    }
    
    
    // MARK: - Tools
    
    
    func showMovieScreen() {
        self.showContentVC(withTitle: "ABOUT_THE_MOVIE".localized)
        self.loadItem()
    }
    
    
    func loadItem() {
        
        self.loadItem(completion: { (item: ItemModel) in
            self.updateViewModel()
            self.contentVC?.hideLoadIndicator()
            self.loadRecommendedVideos()
        }, cacheCompletion: { (item: ItemModel) in
            self.updateViewModel()
            self.contentVC?.hideLoadIndicator()
        }) { (error: ErrorModel) in
            self.contentVC?.hideLoadIndicator()
        }
    }
    
    
    func loadRecommendedVideos() {
        
        let contentVM: MovieContentVM = self.contentVC?.viewModel as! MovieContentVM
        
        VideoService.sharedInstance.getRecommendVideos(videoID: self.item.itemID,
                                                       offset: 0, limit: Constants.shelfItemsLimit,
                                                       completion: { (items: Array<ItemModel>) in
                                                        
                                                        contentVM.removeLoadSection()
                                                        
                                                        if items.count > 0 {
                                                            contentVM.didLoadShelf(shelf: ShelfModel.init(shelfID: self.item.itemID,
                                                                                                          title: "RECOMMEND_VIDEO".localized,
                                                                                                          items: items))
                                                        }
                                                        
                                                        self.contentVC?.updateViewModel(contentVM: contentVM)
        }) { (error: ErrorModel) in
            contentVM.removeLoadSection()
            self.contentVC?.updateViewModel(contentVM: contentVM)
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.contentVC!)
        }
    }
    
    
    func updateViewModel() {
        let contentVM = MovieContentVM.init(item: self.item, contentVCDelegate: self)
        self.contentVC?.updateViewModel(contentVM: contentVM)
    }
}
