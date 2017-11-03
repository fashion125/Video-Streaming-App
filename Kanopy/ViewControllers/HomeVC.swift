//
//  HomeVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit

/// Protocol for home view controller
protocol HomeVCDelegate: class {
    
    /** This method is call when user tap to 'See more' button */
    func didPressToAllSeeButton(shelf: ShelfModel!)
    
    /** This method is call when user tap to Item */
    func didPressToItem(item: ItemModel!)
    
    /** This method is call when user scroll to end list's */
    func loadItems(shelfCellModel: ShelfCellModel!, offset: Int!)
}

class HomeVC: CreditsVC, GenericDataSourceDelegate {
    
    private weak var delegate: HomeVCDelegate?
    private(set) var viewModel: HomeVM!
    
    // MARK: - Init methods
    
    init(delegate: HomeVCDelegate?) {
        super.init()
        self.delegate = delegate
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showMenuBarItem()
        self.showLogo()
        
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
    }
    
    
    // MARK: - Open methods 
    
    
    func update(with viewModel: HomeVM!) {
        self.viewModel = viewModel
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.dataSource.delegate = self
        self.registerCellTypes()
        self.tableView.reloadData()
        self.updateCreditsLeft()    
    }
    
    
    // MARK: - DataSourceDelegate methods 
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
        let cm = self.viewModel.cellModel(indexPath: indexPath)
        
        if cm != nil && cm?.cellID == TableCellIDs.shelfCell {
            let scm = cm as! ShelfCellModel
            let tc = tableViewCell as! ShelfTableCell
            tc.collectionView.setContentOffset(scm.contentOffset, animated: false)
        }
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
        let cm = self.viewModel.cellModel(indexPath: indexPath)
        
        if cm != nil && cm?.cellID == TableCellIDs.shelfCell {
            let scm = cm as! ShelfCellModel
            let tc = tableViewCell as! ShelfTableCell
            scm.updateContentOffset(tc.collectionView.contentOffset)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
    }
    
    
    // MARK: -
}
