//
//  SearchScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/12/17.
//
//

import UIKit

protocol SearchScenarioDelegate {
    
    /** Method is call when user tap to 'Cancel' button and stop search */
    func didStopSearchScenario(searchScenario: SearchScenario, searchVC: GenericSearchVC!)
    
    /** Method is call when user choose item on the result list */
    func didChooseItem(item: ItemModel!, searchScenario: SearchScenario!)
}

class SearchScenario: Scenario, GenericSearchVCDelegate {
    
    private(set) var searchVC: GenericSearchVC!
    
    var delegate: SearchScenarioDelegate!
    
    
    // MARK: - Init method
    
    
    init(searchVC: GenericSearchVC!, delegate: SearchScenarioDelegate!) {
        super.init()
        
        self.delegate = delegate
        self.searchVC = searchVC
        
        let searchVM = SearchVM()
        self.searchVC.update(searchVM: searchVM)
    }
    
    
    // MARK: - Override Start/Stop methods
    
    
    override func start() {
        
        self.searchVC.searchDelegate = self
        self.searchVC.updateIntefaceForSearch()
    }
    
    
    override func stop() {
        self.delegate = nil
        self.searchVC = nil
    }
    
    
    // MARK: - GenericSearchVCDelegate methods 
    
    
    func didPressSearchButton(searchVC: GenericSearchVC!) {
        
    }
    
    
    func didPressToCancelButton(searchVC: GenericSearchVC!) {
        
        searchVC.updateInterfaceForDefault()
        self.delegate.didStopSearchScenario(searchScenario: self, searchVC: searchVC)
    }
    
    
    func didChangeTextOnSearchBar(text: String!, searchVC: GenericSearchVC!) {
        
        RequestService.sharedInstance.breakAllRequests()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        SearchService.sharedInstance.searchVideos(text: text, offset: 0, limit: Constants.searchLimit,
                                                  completion: { (videos: Array<ItemModel>, count: Int) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if videos.count > 0 {
                    searchVC.searchViewModel.updateSuggestResultVideos(videos: videos)
                    searchVC.searchViewModel.updateCurrentSearchText(text: text)
                    searchVC.updateSuggestResults(searchVM: searchVC.searchViewModel)
                } else {
                    searchVC.updateInterfaceForClearSearchResults()
                }
                
        }) { (error: ErrorModel) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: searchVC)
        }
    }
    
    
    func search(text: String!, searchVC: GenericSearchVC!) {
        
        RequestService.sharedInstance.breakAllRequests()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        SearchService.sharedInstance.searchVideos(text: text, offset: 0, limit: Constants.searchLimit,
                                                  completion: { (videos: Array<ItemModel>, count: Int) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                    
                if videos.count > 0 {
                    searchVC.searchViewModel.updateVideoResult(videos: videos, count: count)
                    searchVC.updateVideoResults(searchVM: searchVC.searchViewModel)
                } else {
                    searchVC.updateInterfaceForClearSearchResults()
                }
                                                    
        }) { (error: ErrorModel) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: searchVC)
        }
    }
    
    
    func clearTextOnSearchBar(searchVC: GenericSearchVC!) {
        RequestService.sharedInstance.breakAllRequests()
    }
    
    
    func didChooseItem(item: ItemModel!, searchVC: GenericSearchVC!) {
        self.delegate.didChooseItem(item: item, searchScenario: self)
    }
    
    
    func loadItems(offset: Int!, text: String!) {
        
        SearchService.sharedInstance.searchVideos(text: text, offset: offset, limit: Constants.searchLimit,
                                                  completion: { (videos: Array<ItemModel>, count: Int) in
                                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                    
                                                    if self.searchVC != nil || self.searchVC.searchViewModel != nil {
                                                        self.searchVC.searchViewModel.updateVideos(videos: videos)
                                                        self.searchVC.updateVideoResults(searchVM: self.searchVC.searchViewModel)
                                                    }
                                                    
        }) { (error: ErrorModel) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.searchVC)
        }
    }
}
