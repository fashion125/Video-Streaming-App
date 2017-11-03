//
//  ContentVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/16/17.
//
//

import UIKit

protocol ContentVCDelegate {
    
    /** This method is call when user tap to 'See more' button */
    func didPressToAllSeeRecommendButton(shelf: ShelfModel!)
    
    /** This method is call when user tap to Item */
    func didPressToRecommendItem(item: ItemModel!)
    
    /** This method is call when user scroll to end list's */
    func loadRecommendItems(shelfCellModel: ShelfCellModel!, offset: Int!)
    
    func loadItemsForItem(contentVC: ContentVC!)
    
    /** Method is call when user click back button */
    func didPressToBackButton(contentVC: ContentVC!)
    
    /** Method is call when user tap to item model on the shelf cell */
    func didPressToItem(item: ItemModel!, contentVC: ContentVC!)
    
    /** Method is call when user tap to play button on header cell */
    func didPressToPlayButton(item: ItemModel!, contentVC: ContentVC!)
    
    // MARK: - Actions for additional panel
    
    /** Method is call when user tap 'Add to watch list' button */
    func didPressAddToWatchlistButton()
    
    
    func didPressRemoveFromWatchlistButton()
}

class ContentVC: CreditsVC, GenericContentVMDelegate, GenericDataSourceDelegate {

    var delegate: ContentVCDelegate?
    var titleValue: String! = ""
    var viewModel: GenericContentVM!
    
    // MARK: - Init methods
    
    
    init(title: String!, delegate: ContentVCDelegate?) {
        super.init()
        
        self.titleValue = title
        self.delegate = delegate
        self.addChromecastIfPossible = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateInterfaceMethod()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Open methods 
    
    
    open func updateViewModel(contentVM: GenericContentVM!) {
        self.viewModel = contentVM
        self.viewModel.delegate = self
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.dataSource.delegate = self
        self.registerCellTypes()
        self.tableView.reloadData()
        self.updateCreditsLeft()
    }
    
    // MARK: - Tools 
    
    
    private func updateInterfaceMethod() {
        
        self.showTitle(with: self.titleValue)
        self.showBackButton()
        self.tableView.separatorStyle = .none
    }
    
    
    // MARK: - Actions 
    
    
    override func didPressToBackButton() {
        self.delegate?.didPressToBackButton(contentVC: self)
    }
    
    
    // MARK: - GenericContentVMDelegate methods 
    
    
    func reloadData(isScrollToTop: Bool!, viewModel: GenericContentVM!) {
        self.tableView.reloadData()
        
        if isScrollToTop == true {
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    
    func reloadCell(indexPath: IndexPath, viewModel: GenericContentVM!) {
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    
    func didPressToSeeMoreButton(shelf: ShelfModel!, vievModel: GenericContentVM!) {
//        self.delegate?.didPressToSeeMoreButton(shelf: shelf, contentVC: self)
    }
    
    
    func didPressToItem(item: ItemModel!, viewModel: GenericContentVM!) {
        self.delegate?.didPressToItem(item: item, contentVC: self)
    }
    
    
    func didPressToPlayButton(item: ItemModel!, viewModel: GenericContentVM!) {
        self.delegate?.didPressToPlayButton(item: item, contentVC: self)
    }
    
    
    // MARK: - DataSourceDelegate methods 
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        let cm = self.viewModel.cellModel(indexPath: indexPath)
        
        if cm?.cellID != TableCellIDs.additionalPanelTableCell {
            let cellModel: GenericCellModel? = self.viewModel.cellModel(indexPath: indexPath)
            cellModel?.didSelect()
        }
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
        if scrollView.contentSize.height - (scrollView.contentOffset.y + self.tableView.bounds.height) < 200.0 && scrollView.contentSize.height > self.tableView.bounds.height && self.viewModel.isCanDownload {
            
            self.viewModel.isCanDownload = false
            self.delegate?.loadItemsForItem(contentVC: self)
        }
    }
}
