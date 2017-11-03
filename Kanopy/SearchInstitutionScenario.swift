//
//  SearchInstitutionScenario.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 22/05/2017.
//
//

import UIKit

protocol SearchInstitutionScenarioDelegate {
    
    /** Method is call when user tap to 'Cancel' button and stop search */
    func didStopSearchInstitutionScenario(searchInstitutionScenario: SearchInstitutionScenario, searchVC: GenericSearchVC!)
    
    /** Method is call when user choose item on the result list */
    func didChooseItem(item: ItemModel!, searchInstitutionScenario: SearchInstitutionScenario!)
}

class SearchInstitutionScenario: Scenario, GenericSearchVCDelegate {
    
    private(set) var searchVC: GenericSearchVC!
    
    var delegate: SearchInstitutionScenarioDelegate!
    
    
    // MARK: - Init method
    
    
    init(searchVC: GenericSearchVC!, delegate: SearchInstitutionScenarioDelegate!) {
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
        self.delegate.didStopSearchInstitutionScenario(searchInstitutionScenario: self, searchVC: searchVC)
    }
    
    
    func didChangeTextOnSearchBar(text: String!, searchVC: GenericSearchVC!) {
        RequestService.sharedInstance.breakAllRequests()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        SearchService.sharedInstance.searchInstitutions(text: text,
                                                  completion: { (suggestedInstitutions: Array<ItemModel>, otherInstitutions: Array<ItemModel>) in
                                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                    
                                                    if suggestedInstitutions.count > 0 || otherInstitutions.count > 0 {
                                                        searchVC.searchViewModel.updateSuggestedAndOtherInstitutionRestults(suggestedInstitutions: suggestedInstitutions, otherInstitutions: otherInstitutions)
                                                        searchVC.searchViewModel.updateCurrentSearchText(text: text)
                                                        searchVC.updateSuggestAndOtherResults(searchVM: searchVC.searchViewModel)
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
    }
    
    
    func clearTextOnSearchBar(searchVC: GenericSearchVC!) {
        RequestService.sharedInstance.breakAllRequests()
    }
    
    
    func didChooseItem(item: ItemModel!, searchVC: GenericSearchVC!) {
        self.delegate.didChooseItem(item: item, searchInstitutionScenario: self)
    }
    
    
    func loadItems(offset: Int!, text: String!) {
        
        SearchService.sharedInstance.searchVideos(text: text, offset: offset, limit: 16,
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
