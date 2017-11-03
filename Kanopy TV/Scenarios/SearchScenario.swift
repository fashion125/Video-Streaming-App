//
//  SearchScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/28/17.
//
//

import UIKit

protocol SearchScenarioDelegate {
    
}

class SearchScenario: Scenario, SearchVCDelegate, UISearchBarDelegate, OpenContentScenarioDelegate {

    private(set) var rootVC: UITabBarController!
    private(set) var delegate: SearchScenarioDelegate!
    private(set) var searchVC: SearchVC!
    private(set) var searchVCNC: UINavigationController!
    private(set) var currentSearchText: String! = ""
    private(set) var vc: UISearchContainerViewController!
    
    
    // MARK: - Init methods
    
    
    init(rootVC: UITabBarController!, delegate: SearchScenarioDelegate) {
        super.init()
        
        self.rootVC = rootVC
        self.delegate = delegate
        
        self.createSearchVC()
    }
    
    
    // MARK: -
    
    
    override func start() {
        
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: -
    
    
    private func createSearchVC() {
        
        // configure a UIViewController to display search results
        // needs to conform to the UISearchResultsUpdating protocol
        self.searchVC = SearchVC.init(delegate: self)
        
        // setup UISearchController and hook up to search results UIViewController
        let searchController = UISearchController(searchResultsController: self.searchVC)
//        searchController.searchResultsUpdater = searchResultsViewController as? UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.mainOrangeColor()
        searchController.searchBar.tintColor = UIColor.mainOrangeColor()
        searchController.view.backgroundColor = UIColor.black
        searchController.searchBar.delegate = self
        
        // create a search container that will hold the UISearchController
        self.vc = UISearchContainerViewController(searchController: searchController)
        
        // set up a nav bar to hold the UISearchContainerViewController
        self.searchVCNC = UINavigationController(rootViewController: self.vc)
        self.searchVCNC.tabBarItem = UITabBarItem.init(title: "SEARCH".localized, image: nil, tag: 1)
        self.vc.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    private func showSearchVC() {
        
    }
    
    
    // MARK: - SearchBarDelegate methods 
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchVC?.hideLoadIndicator()
        
        self.searchVC.currentSearchText = searchText
        self.searchVC?.searchView.isHidden = true
        
        if searchText == "" || !(searchText.characters.count > 0) {
            self.searchVC?.hideLoadIndicator()
            return
        }
        
        self.searchVC?.showLoadIndicator()
        
        SearchService.sharedInstance.searchVideos(text: searchText, offset: 0, limit: Constants.searchLimit,
                                                  completion: { (videos: Array<ItemModel>, count: Int) in
                                                    
                                                    if self.searchVC.currentSearchText == searchText {
                                                        let title = String(count) + " results for '" + searchText + "'"
                                                        let vm = SearchVM.init(title: title,
                                                                               items: videos,
                                                                               delegate: self)
                                                        self.searchVC?.updateViewModel(vm)
                                                        self.searchVC?.hideLoadIndicator()
                                                        self.searchVC?.searchView.isHidden = false
                                                    } else {
                                                        self.searchVC?.hideLoadIndicator()
                                                    }
                                                    
        }) { (error: ErrorModel) in
            
            self.searchVC?.hideLoadIndicator()
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.searchVC)
        }
    }
    
    
    // MARK: -
    
    
    func didPressToItem(item: ItemModel!) {
        ContentScenarioFactory.scenario(withItem: item, rootVC: self.vc, delegate: self)?.start()
    }
    
    
    func loadItems(offset: Int!, text: String!) {
        
        self.searchVC.viewModel.isCanDownload = false
        
        SearchService.sharedInstance.searchVideos(text: text, offset: offset, limit: Constants.searchLimit,
                                                  completion: { (videos: Array<ItemModel>, count: Int) in
                                                    
                                                    if self.searchVC != nil || self.searchVC.viewModel != nil {
                                                        
                                                        if videos.count > 0 {
                                                            var itms = [ItemModel]()
                                                            itms.append(contentsOf: self.searchVC.viewModel.items)
                                                            itms.append(contentsOf: videos)
                                                        
                                                            let vm = SearchVM.init(title: self.searchVC.viewModel.titleText,
                                                                               items: itms,
                                                                               delegate: self)
                                                            self.searchVC.updateViewModel(vm)
                                                            self.searchVC.viewModel.isCanDownload = true
                                                        } else {
                                                            self.searchVC.viewModel.isCanDownload = false
                                                        }
                                                    }
                                                    
        }) { (error: ErrorModel) in
            
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.searchVC)
        }
    }
}
