//
//  HomeVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/14/17.
//
//

import UIKit

protocol HomeVCDelegate {
    
    /** This method is call when user tap to category cell */
    func didPressToCategory(category: CategoryModel!)
    
    /** This method is call when needed load items for shelf */
    func loadItemForShelf(shelfCM: ShelfCellModel!)
    
    /** This method is call when user tap to item cell */
    func didPressToItem(item: ItemModel!)
}


class HomeVC: PublicCreditsLeftVC, GenericCollectionDataSourceDelegate, GenericDataSourceDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var publicCreditsView: UIView!
    @IBOutlet weak var publicCreditsTitleLabel: UILabel!
    @IBOutlet weak var publicCreditsValueLabel: UILabel!
    
    private(set) var collectionDataSource: GenericCollectionDataSource!
    private(set) var tableDataSource: GenericTableDatasource!
    private(set) var delegate: HomeVCDelegate!
    private(set) var viewModel: HomeVM!
    
    
    
    // MARK: - Init methods
    
    
    init(delegate: HomeVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.remembersLastFocusedIndexPath = true
        self.collectionView.remembersLastFocusedIndexPath = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    open func update(_ viewModel: HomeVM!) {
        self.viewModel = viewModel
        
        if self.tableView != nil {
            self.tableView.remembersLastFocusedIndexPath = true
            self.collectionView.remembersLastFocusedIndexPath = true
            
            self.reloadCollectionView()
            self.reloadTableView()
        }
    }
    
    
    private func reloadCollectionView() {
        
        self.collectionDataSource = GenericCollectionDataSource.init(sections: self.viewModel.topSections)
        self.collectionView.dataSource = self.collectionDataSource
        self.collectionView.delegate = self.collectionDataSource
        self.collectionDataSource.delegate = self
        
        for sm in self.collectionDataSource.sectionModels {
            for cm in sm.cellModels {
                self.collectionView.register(UINib.init(nibName: cm.cellID, bundle: nil), forCellWithReuseIdentifier: cm.cellID)
            }
        }
        
        self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 54.0, bottom: 0, right: 54.0)
        
        self.collectionView.reloadData()
    }
    
    
    private func reloadTableView() {
        
        self.tableDataSource = GenericTableDatasource.init(sections: self.viewModel.sections)
        self.tableView.dataSource = self.tableDataSource
        self.tableView.delegate = self.tableDataSource
        self.tableDataSource.delegate = self
        
        for sm in self.tableDataSource.sectionModels {
            for cm in sm.cellModels {
                self.tableView?.register(UINib(nibName: cm.cellID, bundle: nil),
                                         forCellReuseIdentifier: cm.cellID)
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - DataSourceDelegate methods
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
        let cm = self.viewModel.cellModel(indexPath: indexPath)
        
        if cm != nil && cm?.cellID == TableCellIDs.shelfTableCellTV {
            let scm = cm as! ShelfCellModel
            let tc = tableViewCell as! ShelfTableCellTV
            tc.collectionView.setContentOffset(scm.contentOffset, animated: false)
        }
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
        let cm = self.viewModel.cellModel(indexPath: indexPath)
        
        if cm != nil && cm?.cellID == TableCellIDs.shelfTableCellTV {
            let scm = cm as! ShelfCellModel
            let tc = tableViewCell as! ShelfTableCellTV
            scm.updateContentOffset(tc.collectionView.contentOffset)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
    }

    
    // MARK: -
    
    
    func didPressToCell(indexPath: IndexPath!, dataSource: GenericCollectionDataSource!) {
        let sm = self.viewModel.topSections[indexPath.section]
        let cm = sm.cellModels[indexPath.row]
        
        cm.didSelect()
    }
    
    
    func collectionScrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
    // MARK: - 
    
    
    override func publicCreditsLeftView() -> UIView? {
        return self.publicCreditsView
    }
    
    
    override func countLabel() -> UILabel? {
        return self.publicCreditsValueLabel
    }
    
    
    override func titleLabel() -> UILabel? {
        return self.publicCreditsTitleLabel
    }
}
