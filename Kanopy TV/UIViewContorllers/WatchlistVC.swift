//
//  WatchlistVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/9/17.
//
//

import UIKit

protocol WatchlistVCDelegate {
    
    /** This method is call when user select to item */
    func didPressToItem(item: ItemModel!)
}

class WatchlistVC: PublicCreditsLeftVC, GenericCollectionDataSourceDelegate {

    private(set) var delegate: WatchlistVCDelegate!
    private(set) var collectionDataSource: GenericCollectionDataSource!
    private(set) var viewModel: WatchlistVM!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var publicCreditsView: UIView!
    @IBOutlet weak var publicCreditsTitleLabel: UILabel!
    @IBOutlet weak var publicCreditsValueLabel: UILabel!
    
    @IBOutlet weak var countItemsLabel: UILabel!
    @IBOutlet weak var titleVCLabel: UILabel!
    
    // MARK: - Init methods
    
    
    init(delegate: WatchlistVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.titleVCLabel.text = "My Watchlist".localized
    }
    
    
    // MARK: - Open tools 
    
    
    open func updateViewModel(_ viewModel: WatchlistVM!) {
        
        self.viewModel = viewModel
        
        self.reloadCollectionView()
        self.countItemsLabel.text = String(self.viewModel.playlist.itemsCount) + " videos"
    }
    
    
    // MARK: - Private tools
    
    
    private func reloadCollectionView() {
        
        self.collectionView.remembersLastFocusedIndexPath = true
        self.collectionDataSource = GenericCollectionDataSource.init(sections: self.viewModel.sections)
        self.collectionView.dataSource = self.collectionDataSource
        self.collectionView.delegate = self.collectionDataSource
        self.collectionDataSource.delegate = self
        
        for sm in self.collectionDataSource.sectionModels {
            for cm in sm.cellModels {
                self.collectionView.register(UINib.init(nibName: cm.cellID, bundle: nil), forCellWithReuseIdentifier: cm.cellID)
            }
        }
        
        self.collectionView.contentInset = UIEdgeInsets.init(top: 30.0, left: 90.0, bottom: 100.0, right: 90.0)
        
        self.collectionView.reloadData()
    }
    
    
    // MARK: - PublicCreditsLeft methods
    
    
    override func countLabel() -> UILabel? {
        
        return self.publicCreditsValueLabel
    }
    
    
    override func titleLabel() -> UILabel? {
        
        return self.publicCreditsTitleLabel
    }
    
    
    override func publicCreditsLeftView() -> UIView? {
        
        return self.publicCreditsView
    }
    
    
    // MARK: - GenericCollectionDataSourceDelegate methods 
    
    
    func didPressToCell(indexPath: IndexPath!, dataSource: GenericCollectionDataSource!) {
        
        let sm = self.viewModel.sections[indexPath.section]
        let cm = sm.cellModels[indexPath.row]
            
        cm.didSelect()
    }
    
    
    func collectionScrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
