//
//  MovieScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/24/17.
//
//

import UIKit

class MovieScenario: OpenContentScenario {

    
    // MARK: - Init methods 
    
    override init(rootVC: UIViewController!, item: ItemModel!, delegate: OpenContentScenarioDelegate) {
        super.init(rootVC: rootVC, item: item, delegate: delegate)
    }
    
    
    // MARK: -
    
    
    override func start() {
        super.start()
        
        self.openMovieScreen()
    }
    
    
    override func stop() {
        super.stop()
    }
    
    
    // MARK: - Tools 
    
    
    private func openMovieScreen() {
        
        let url = URL.init(string: (self.itemModel.images?.mediumThumbURL())!)
        let contentVM = ContentVM.init(itemModel: nil, bgThumbURL: url, suggestedVideos: nil, delegate: self)
        self.contentVC = MovieVC.init(delegate: self, url: url, title: self.itemModel.title)
        self.rootVC.navigationController?.pushViewController(self.contentVC, animated: true)
        self.contentVC.updateViewModel(contentVM)
        
        self.loadItem(completion: { (item: ItemModel) in
            let contentVM = ContentVM.init(itemModel: item, bgThumbURL: url, suggestedVideos: nil, delegate: self)
            self.contentVC.updateViewModel(contentVM)
            self.contentVC.hideLoadIndicator()
            self.loadRecommendedVideos()
        }, cacheCompletion: { (item: ItemModel) in
            
        }) { (error: ErrorModel) in
            
        }
    }
    
    
    func loadRecommendedVideos() {
        
        let contentVM: ContentVM = (self.contentVC?.viewModel!)!
        
        VideoService.sharedInstance.getRecommendVideos(videoID: self.itemModel.itemID,
                                                       offset: 0, limit: Constants.shelfItemsLimit,
                                                       completion: { (items: Array<ItemModel>) in
                                                        
                                                        let newContentVM = ContentVM.init(itemModel: self.itemModel, bgThumbURL: contentVM.bgThumbURL,
                                                                                          suggestedVideos: items, delegate: self)
                                                        self.contentVC.updateViewModel(newContentVM)
        }) { (error: ErrorModel) in
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.contentVC!)
        }
    }
}
