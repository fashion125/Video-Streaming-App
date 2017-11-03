//
//  ShelfTableCellTV.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/19/17.
//
//

import UIKit

class ShelfTableCellTV: GenericCell, GenericCollectionDataSourceDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private(set) var collectionDataSource: GenericCollectionDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.remembersLastFocusedIndexPath = true
    }

    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.shelfCM.shelf.title
        
        self.reloadCollectionView()
    }
    
    
    var shelfCM: ShelfCellModel {
        get {
            return self.cellModel as! ShelfCellModel
        }
    }
    
    
    private func reloadCollectionView() {
        self.collectionDataSource = GenericCollectionDataSource.init(sections: self.shelfCM.sections)
        
        self.collectionView.dataSource = self.collectionDataSource
        self.collectionView.delegate = self.collectionDataSource
        self.collectionDataSource.delegate = self
        
        for sm in self.collectionDataSource.sectionModels {
            for cm in sm.cellModels {
                self.collectionView.register(UINib.init(nibName: cm.cellID, bundle: nil), forCellWithReuseIdentifier: cm.cellID)
            }
        }
        
        self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 26.0, bottom: 0, right: 26.0)
        
        self.collectionView.reloadData()
    }
    
    
    // MARK: - GenericCollectionDataSourceDelegate methods 
    
    
    func didPressToCell(indexPath: IndexPath!, dataSource: GenericCollectionDataSource!) {
        let sm = self.collectionDataSource.sectionModels[indexPath.section]
        let cm = sm.cellModels[indexPath.row]
        
        cm.didSelect()
    }
    
    
    func collectionScrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentSize.width - (self.bounds.width + scrollView.contentOffset.x)) < 400.0 && self.cellModel != nil && scrollView.contentSize.width > self.bounds.width {
            
            self.shelfCM.loadItems()
        }
    }
}
