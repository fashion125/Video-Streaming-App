//
//  GenericScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/20/17.
//
//

import UIKit

class GenericScenario: Scenario, SubCategoryVCDelegate, OpenContentScenarioDelegate, GenericSearchVCDelegate, SearchScenarioDelegate {

    open var nvc: MenuNavigationController!
    public var currentOpenShelf: ShelfModel!
    private var loadingItems: Bool! = false
    
    var subCategoryVC: SubCategoryVC?
    
    // MARK: -
    
    /** Start the current scenario. */
    override func start() {
        
    }
    
    /** Stop the current scenario. */
    override func stop() {
        
        
    }
    
    
    // MARK: -
    
    
    /** Method open sub category screen
     - parameter parentVC: generic view controller on the which push sub category screen
     - parameter shelf: ShelfModel object which in store all info about category (shelf)
     */
    open func openSubCategoryScreen(parentVC: GenericVC!, shelf: ShelfModel!) {
        
        self.currentOpenShelf = shelf
        
        let subCategoryVM = SubCategoryVM.init(shelf: shelf)
        self.subCategoryVC = SubCategoryVC.init(title: shelf.title,
                                               subCategoryVM: subCategoryVM,
                                               delegate: self)
        self.subCategoryVC?.searchDelegate = self
        parentVC.navigationController?.pushViewController(self.subCategoryVC!, animated: true)
        
        self.subCategoryVC?.showLoadIndicator()
        
        ShelvesService.sharedInstance.shelf(shelfHash: shelf.shelfID,
                                            completion: { (shelf: ShelfModel) in
                                                self.subCategoryVC?.hideLoadIndicator()
                                                subCategoryVM.updateVideos(videos: shelf.items)
                                                self.subCategoryVC?.updateViewModel(subCategoryVM: subCategoryVM)
                                                
                                                
                                                /*
                                                 AFO
                                                 Little trick used here to load 14 (2*7) or 18 (2*9) films depending on the shelf configuration.
                                                 This is due to a limitation of the API which doesn't allow us to select the number of element per page
                                                 that we want. The problem is that 7 or 9 elements is too small for iPads or iPhone Plus so it doesn't
                                                 load more.
                                                 @todo: remove this trick once the API allow us to choose the number of element per page that we want
                                                */
                                                self.loadItems(subCategoryVC: self.subCategoryVC)
        }) { (error: ErrorModel) in
            self.subCategoryVC?.hideLoadIndicator()
            UIAlertController.showAlert(title: "ERROR".localized,
                                        message: error.messageError!,
                                        fromVC: self.subCategoryVC!)
        }
    }
    
    
    
    
    
    /** Method start OpenContentScenario
     - parameter parentVC: generic view controller on the which push item screen
     - parameter item: ItemModel object which in store all info about content
     */
    open func openItemScreen(parentVC: GenericVC!, item: ItemModel!) {
        
        let openContentScenario = ContentScenarioFactory.scenario(withItem: item,
                                                                  nvc: self.nvc,
                                                                  delegate: self)
        if (openContentScenario != nil) {
            openContentScenario!.start()
        }
    }
    
    
    // MARK: - SubCategoryVCDelegate methods
    
    
    func didPressToBackButton(subcategoryVC: SubCategoryVC!) {
        _ = subcategoryVC.navigationController?.popViewController(animated: true)
    }
    
    
    func didPressToItem(item: ItemModel!, subcategoryVC: SubCategoryVC!) {
        self.openItemScreen(parentVC: subcategoryVC, item: item)
    }
    
    
    func loadItems(subCategoryVC: SubCategoryVC!) {
        if (!self.loadingItems) {
            self.loadingItems = true
            ShelvesService.sharedInstance.shelfItems(shelfID: self.currentOpenShelf.shelfID,
                                                     offset: subCategoryVC.viewModel.offset,
                                                     limit: Constants.shelfItemsLimit,
                                                     completion: { (items: Array<ItemModel>) in
                                                        
                                                        subCategoryVC.viewModel.insertItems(items: items)
                                                        
                                                        
                                                        print("This is run on the main queue, after the previous code in outer block")
                                                        
                                                        DispatchQueue.main.async {
                                                            subCategoryVC.updateTableView(subCategoryVC.viewModel)
                                                            subCategoryVC.viewModel.checkIsCanDownload(items.count)
                                                        }
                                                        
                                                        self.loadingItems = false
                                                        
                                                        //subCategoryVC.updateViewModel(subCategoryVM: subCategoryVC.viewModel)
                                                        
                                                        
            }) { (error: ErrorModel) in
                subCategoryVC.viewModel.insertItems(items: [])
                subCategoryVC.updateViewModel(subCategoryVM: subCategoryVC.viewModel)
            }
 
        }
    }
    
    
    // MARK: - GenericSearchVCDelegate methods
    
    
    func didPressSearchButton(searchVC: GenericSearchVC!) {
        let searchScenario = SearchScenario.init(searchVC: searchVC, delegate: self)
        searchScenario.start()
    }
    
    
    // MARK: - SearchScenarioDelegate methods
    
    
    func didStopSearchScenario(searchScenario: SearchScenario, searchVC: GenericSearchVC!) {
        
        searchVC.searchDelegate = self
        searchScenario.stop()
    }
    
    
    func didChooseItem(item: ItemModel!, searchScenario: SearchScenario!) {
        self.openItemScreen(parentVC: searchScenario.searchVC, item: item)
//        self.openItem(parentVC: searchScenario.searchVC, item: item)
    }
    
    func loadItems(offset: Int!, text: String!) {
        
    }
    
    func didPressToCancelButton(searchVC: GenericSearchVC!) {
        
    }
    
    func didChangeTextOnSearchBar(text: String!, searchVC: GenericSearchVC!) {
        
    }
    
    func search(text: String!, searchVC: GenericSearchVC!) {
        
    }
    
    func clearTextOnSearchBar(searchVC: GenericSearchVC!) {
        
    }
    
    func didChooseItem(item: ItemModel!, searchVC: GenericSearchVC!) {
        
    }
}
