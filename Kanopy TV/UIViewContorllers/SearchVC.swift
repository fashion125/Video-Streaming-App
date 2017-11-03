//
//  SearchVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/28/17.
//
//

import UIKit

protocol SearchVCDelegate {
    /** This method is call when user select to item */
    func didPressToItem(item: ItemModel!)
    
    func loadItems(offset: Int!, text: String!)
}


class SearchVC: GenericVC, GenericCollectionDataSourceDelegate {

    private(set) var delegate: SearchVCDelegate!
    private(set) var collectionDataSource: GenericCollectionDataSource!
    private(set) var viewModel: SearchVM!
    
    open var currentSearchText: String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!

    
    // MARK: - Init methods 
    
    
    init(delegate: SearchVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchView.isHidden = true
    }
    
    
    // MARK: -
    
    
    open func updateViewModel(_ viewModel: SearchVM!) {
        
        self.viewModel = viewModel
        
        self.reloadCollectionView()
        self.titleLabel.text = self.viewModel.titleText
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
    
    
    // MARK: -
    
    
    // MARK: - GenericCollectionDataSourceDelegate methods
    
    
    func didPressToCell(indexPath: IndexPath!, dataSource: GenericCollectionDataSource!) {
        
        let sm = self.viewModel.sections[indexPath.section]
        let cm = sm.cellModels[indexPath.row]
        
        cm.didSelect()
    }
    
    
    func collectionScrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height)) < 100 && (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height)) > 0 && scrollView == self.collectionView {
            
            //NSLog(@" scroll to bottom!");
            if(self.viewModel.isCanDownload){ // no need to worry about threads because this is always on main thread.
                self.viewModel.isCanDownload = false
                self.delegate?.loadItems(offset: self.viewModel.items.count, text: self.currentSearchText)
            }
        }
    }
}
