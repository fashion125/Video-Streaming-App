//
//  ShelfTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/3/17.
//
//

import UIKit

class ShelfTableCell: GenericCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private(set) var sectionModels: [SectionModel] = []
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.font = SizeStrategy.shelfTitleFont()
        
        self.setupSeeMoreButton()
        self.setupCollectionView()
    }
    
    
    private func setupSeeMoreButton() {
        self.seeMoreButton.imageEdgeInsets = UIEdgeInsetsMake(3, 10, 0, 0)
        self.seeMoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4)
        self.seeMoreButton.titleLabel?.font = SizeStrategy.seeMoreButtonFont()
        self.seeMoreButton.setTitle("SEE_MORE".localized, for: .normal)
        self.seeMoreButton.titleLabel?.addTextSpacing()
    }
    
    
    private func setupCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize.init(width: 160.0, height: 90.0)
        self.collectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 15.0, bottom: 0, right: 15.0)
    }
    
    // MARK: -
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.shelfCM.shelf.title
        self.sectionModels = self.shelfCM.videoSecitons
        
        self.reloadCollectionView()
    }
    
    
    var shelfCM: ShelfCellModel {
        get {
            return self.cellModel as! ShelfCellModel
        }
    }
    
    
    private func reloadCollectionView() {
        
        for sm in self.sectionModels {
            for cm in sm.cellModels {
                self.collectionView.register(UINib.init(nibName: cm.cellID, bundle: nil), forCellWithReuseIdentifier: cm.cellID)
            }
        }
        
        self.collectionView.reloadData()
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
        let sm: SectionModel = self.sectionModels[indexPath.section]
        
        if let cm: ItemCellModel = sm.cellModels[indexPath.row] as? ItemCellModel {
            cm.didPressToItem()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //let sm: SectionModel = self.sectionModels[section]
        
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //let sm: SectionModel = self.sectionModels[section]
        
        return 8.0
    }
    
    
    // MARK: -
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if (scrollView.contentSize.width - (self.bounds.width + scrollView.contentOffset.x)) < 200.0 && self.cellModel != nil && scrollView.contentSize.width > self.bounds.width {
            
            self.shelfCM.needLoadItems()
        }
    }
    
    
    // MARK: - Actions 
    
    
    @IBAction func didPressToSeeAllButton(_ sender: Any) {
        
        let cm: ShelfCellModel = self.cellModel as! ShelfCellModel
        cm.didPressSeeAllButton()
    }
    
}
