//
//  CategoryVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/9/17.
//
//

import UIKit

protocol CategoryVCDelegate: class {
    
    /** This method is call when user tap to 'See more' button */
    func didPressToAllSeeButtonOnCategoryScreen(shelf: ShelfModel!, categoryVC: CategoryVC!)
    
    /** This method is call when user tap to Item */
    func didPressToItemOnCategoryScreen(item: ItemModel!, categoryVC: CategoryVC!)
    
    /** This method is call when user scroll to end list's */
    func loadItemsOnCategoryScreen(shelfCellModel: ShelfCellModel!, offset: Int!, categoryVC: CategoryVC!)
    
    /** This method is call when user tap to back button */
    func didPressToBackButton(categoryVC: CategoryVC!)
}

class CategoryVC: CreditsVC, GenericDataSourceDelegate {

    private(set) var titleValue: String!
    private weak var delegate: CategoryVCDelegate!
    private(set) var viewModel: CategoryVM!
    private(set) var isShowBackButton: Bool!
    
    // MARK: - Init methods 
    
    init(with title: String!, delegate: CategoryVCDelegate!, isShowBackButton: Bool!) {
        super.init()
        
        self.titleValue = title
        self.delegate = delegate
        self.isShowBackButton = isShowBackButton
        self.addChromecastIfPossible = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("Remove CategoryVC for: " + self.titleValue)
    }
    
    
    // MARK: - Life cyrcle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !self.isShowBackButton {
            self.showMenuBarItem()
        } else {
            self.showBackButton()
        }
        
        self.showTitle(with: self.titleValue)
        
        self.tableView.separatorStyle = .none
    }
    
    
    override func didPressToBackButton() {
        self.delegate.didPressToBackButton(categoryVC: self)
    }
    
    
    // MARK: - Open methods
    
    
    func update(with viewModel: CategoryVM!) {
        
        self.viewModel = viewModel
        
        if self.viewModel != nil {
            self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
            self.dataSource.delegate = self
            self.registerCellTypes()
        }
        
        self.tableView.reloadData()
        
        self.updateCreditsLeft()
    }
    
    
    // MARK: - Data Source delegate methods 
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
        let cm = self.viewModel.cellModel(indexPath: indexPath) as! ShelfCellModel
        let tc = tableViewCell as! ShelfTableCell
        
        tc.collectionView.setContentOffset(cm.contentOffset, animated: false)
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
        let cm = self.viewModel.cellModel(indexPath: indexPath) as! ShelfCellModel
        let tc = tableViewCell as! ShelfTableCell
        
        cm.updateContentOffset(tc.collectionView.contentOffset)
    }
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
    }
}
