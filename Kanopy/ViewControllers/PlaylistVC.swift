//
//  PlaylistVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/27/17.
//
//

import UIKit

protocol PlaylistVCDelegate {
    
    /** Method is call when user tap to item model on the shelf cell */
    func didPressToItem(item: ItemModel!)
    
    /** This method is call when user tap to menu button on the cell */
    func didPressToMenuButton(item: MyPlaylistItemCellModel!)
    
    /** This method is call when user scroll to bottom */
    func loadItems(playlistVC: PlaylistVC!)
    
    /** This method is call when user tap to remove button on the menu */
    func didPressToRemoveButton()
    
    /** This method is call when user tap to cancel button on the menu */
    func didPressToCancelButton()
}

class PlaylistVC: CreditsVC, GenericDataSourceDelegate {

    var delegate: PlaylistVCDelegate!
    var titleValue: String! = ""
    var viewModel: PlaylistVM!
    var menuViewModel: PlaylistMenuVM!
    
    private(set) var menuDataSource: GenericTableDatasource!
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var countVideosLabel: UILabel!
    
    // MARK: - Init methods
    
    
    init(title: String!, delegate: PlaylistVCDelegate!) {
        super.init()
        
        self.titleValue = title
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topMargin = 40.0
        self.countVideosLabel.text = "LOADING".localized
        self.tableView.separatorStyle = .none
        self.showMenuBarItem()
        self.showTitle(with: self.titleValue)
        self.view.bringSubview(toFront: self.menuTableView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.menuTableView.frame = CGRect.init(x: 0, y: self.view.bounds.height,
                                           width: self.menuTableView.bounds.width,
                                           height: self.menuTableView.bounds.height)
        self.view.bringSubview(toFront: self.menuTableView)
    }
    
    
    open func updateViewModel(contentVM: PlaylistVM!) {
        self.viewModel = contentVM
        self.countVideosLabel.text = String(self.viewModel.playlistModel.itemsCount) + " " + "VIDEOS".localized
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.dataSource.delegate = self
        self.registerCellTypes()
        self.tableView.reloadData()
        self.updateCreditsLeft()
    }
    
    
    override func updateCreditsLeft() {
        
        if AuthService.sharedInstance.isHaveCredits() {
            self.addCreditsLeft()
        } else {
            self.removeCreditsLeft()
        }
        
        if self.isOpenSearch {
            self.navigationController?.navigationBar.bringSubview(toFront: self.searchBGView!)
        }
    }
    
    
    // MARK: - Menu 
    
    
    func openMenu(withMenuViewModel viewModel: PlaylistMenuVM!) {
        
        self.menuViewModel = viewModel
        self.menuDataSource = GenericTableDatasource(sections: self.menuViewModel.sections)
        self.menuDataSource.delegate = self
        self.registerMenuCellTypes()
        self.menuTableView.dataSource = self.menuDataSource
        self.menuTableView.delegate = self.menuDataSource
        self.menuTableView.reloadData()
        
        self.showMenu()
    }
    
    
    func registerMenuCellTypes() {
        for sm: SectionModel in (self.menuDataSource?.sectionModels)! {
            for cm: GenericCellModel in sm.cellModels {
                self.menuTableView?.register(UINib(nibName: cm.cellID, bundle: nil),
                                         forCellReuseIdentifier: cm.cellID)
            }
        }
    }
    
    
    func showMenu() {
        
        self.view.bringSubview(toFront: self.menuTableView)
        self.tableView.isUserInteractionEnabled = false
        self.menuTableView.separatorStyle = .none
        
        UIView.animate(withDuration: 0.2) { 
            self.menuTableView.frame = CGRect.init(x: 0, y: self.view.bounds.height - self.menuViewModel.tableHeight,
                                                   width: self.menuTableView.bounds.width,
                                                   height: self.menuViewModel.tableHeight)
            self.view.bringSubview(toFront: self.menuTableView)
            self.view.layoutIfNeeded()
        }
    }
    
    
    func hideMenu() {
        
        self.tableView.isUserInteractionEnabled = true
    
        UIView.animate(withDuration: 0.2) {
            self.menuTableView.frame = CGRect.init(x: 0, y: self.view.bounds.height,
                                                   width: self.menuTableView.bounds.width,
                                                   height: self.menuTableView.bounds.height)
        }
    }
    
    
    // MARK: - GenericDataSourceDelegate methods 
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        
        if dataSource == self.dataSource {
            let cellModel: GenericCellModel? = self.viewModel.cellModel(indexPath: indexPath)
            cellModel?.didSelect()
        } else {
            let cellModel: GenericCellModel? = self.menuViewModel.cellModel(indexPath: indexPath)
            cellModel?.didSelect()
        }
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
        if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height)) < 100 && (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height)) > 0 {
            
            //NSLog(@" scroll to bottom!");
            if(self.viewModel.isCanDownload){ // no need to worry about threads because this is always on main thread.
                self.viewModel.isCanDownload = false
                self.delegate.loadItems(playlistVC: self)
            }
        }
    }
}
