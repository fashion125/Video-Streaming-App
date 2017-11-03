//
//  GenericCollectionDataSource.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/8/17.
//
//

import UIKit

protocol GenericCollectionDataSourceDelegate {
    
    /** Method is call when user tap to cell on the collection view */
    func didPressToCell(indexPath: IndexPath!, dataSource: GenericCollectionDataSource!)
    
    func collectionScrollViewDidScroll(_ scrollView: UIScrollView)
}

class GenericCollectionDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: GenericCollectionDataSourceDelegate?
    
    private(set) var sectionModels: [SectionModel] = []
    
    
    // MARK: - Init methods 
    
    
    init(sections: Array<SectionModel>!) {
        super.init()
        
        self.sectionModels = sections
    }
    
    
    // MARK: - UICollectionView 
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sm = self.sectionModels[section]
        return sm.cellModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sm: SectionModel = self.sectionModels[indexPath.section]
        let cm: GenericCellModel = sm.cellModels[indexPath.row]
        let cell: GenericCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cm.cellID, for: indexPath) as! GenericCollectionCell
        cell.configure(cellModel: cm)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sm: SectionModel = self.sectionModels[indexPath.section]
        let cm: GenericCellModel = sm.cellModels[indexPath.row]
        
        return CGSize.init(width: cm.width, height: cm.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didPressToCell(indexPath: indexPath, dataSource: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sm: SectionModel = self.sectionModels[section]
        return sm.sectionLineSpacing
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //let sm: SectionModel = self.sectionModels[section]
        
        return 0.0
    }
    
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        
        var indexPath: IndexPath? = nil
        
        for sm in self.sectionModels {
            for cm in sm.cellModels {
                if cm.isSelected {
                    indexPath = IndexPath.init(row: sm.cellModels.index(of: cm)!, section: self.sectionModels.index(of: sm)!)
                }
            }
        }
        
        if indexPath != nil {
            return indexPath
        }
        
        return IndexPath.init(row: 0, section: 0)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.collectionScrollViewDidScroll(scrollView)
    }
}
