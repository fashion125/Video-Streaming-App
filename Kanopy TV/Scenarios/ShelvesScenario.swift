//
//  ShelvesScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/31/17.
//
//

import UIKit

protocol ShelvesScenarioDelegate {
    
}

class ShelvesScenario: Scenario, HomeVCDelegate, OpenContentScenarioDelegate {

    private(set) var rootVC: UITabBarController!
    private(set) var delegate: ShelvesScenarioDelegate!
    
    open var homeVC: HomeVC!
    open var homeVCNC: UINavigationController!
    
    open var shelves: [ShelfModel]!
    open var categories: [CategoryModel]!
    
    open var currentCategory: String!
    
    // MARK: - Init method
    
    
    init(rootVC: UITabBarController!, delegate: ShelvesScenarioDelegate) {
        super.init()
        
        self.rootVC = rootVC
        self.delegate = delegate
    }
    
    
    override func start() {
        
    }
    
    
    override func stop() {
        
    }
    
    
    // MARK: -
    
    
    func loadForAnother(category: CategoryModel!) {
        
        let vm = HomeVM.init(shelves: [ShelfModel](), categories: self.categories, delegate: self, currentSelectedCategory: category.termID)
        self.homeVC.update(vm)
        
        self.homeVC.showLoadIndicator()
        
        ShelvesService.sharedInstance.shelves(categoryID: category.termID,
                                              completion: { (shelves: Array<ShelfModel>) in
                                                let vm = HomeVM.init(shelves: shelves, categories: self.categories, delegate: self, currentSelectedCategory: category.termID)
                                                self.homeVC.update(vm)
                                                
                                                self.homeVC.hideLoadIndicator()
        }) { (error: ErrorModel) in
            self.homeVC.hideLoadIndicator()
        }
    }
    
    
    func didPressToItem(item: ItemModel!) {
        ContentScenarioFactory.scenario(withItem: item, rootVC: self.homeVC, delegate: self)?.start()
    }
    
    
    // MARK: -
    
    
    func didPressToCategory(category: CategoryModel!) {
        
        if category.termID == self.currentCategory {
            return
        }
        
        if category.termID == "0" {
            self.updateForMain(cateogory: category)
        } else {
            self.loadForAnother(category: category)
        }
        
        self.currentCategory = category.termID
    }
    
    
    func updateForMain(cateogory: CategoryModel!) {
        let vm = HomeVM.init(shelves: self.shelves, categories: self.categories, delegate: self, currentSelectedCategory: cateogory.termID)
        self.homeVC.update(vm)
    }
    
    
    func loadItemForShelf(shelfCM: ShelfCellModel!) {
        
        weak var cm = shelfCM
        
        ShelvesService.sharedInstance.shelfItems(shelfID: cm?.shelf.shelfID,
                                                 offset: cm?.offset,
                                                 limit: Constants.shelfItemsLimit,
                                                 completion: { (items: Array<ItemModel>) in
                                                    
                                                    cm?.updateShelfItems(items: items)
                                                    self.reloadCell(shelfCM: cm!)
        }) { (error: ErrorModel) in
            //            shelfCM?.updateShelfItems(items: [])
        }
    }
    
    
    func reloadCell(shelfCM: ShelfCellModel) {
        
        let indexPath: IndexPath? = self.homeVC.viewModel.indexPath(cellModel: shelfCM)
        
        if indexPath != nil {
            let tc: ShelfTableCellTV = self.homeVC.tableView.cellForRow(at: indexPath!) as! ShelfTableCellTV
            tc.configure(cellModel: shelfCM)
        }
    }
}
