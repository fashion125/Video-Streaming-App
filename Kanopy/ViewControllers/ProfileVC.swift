//
//  ProfileVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/28/17.
//
//

import UIKit

protocol ProfileVCDelegate: MembershipsVCDelegate {
    func continueOnboarding()
    
    func didChooseMembership(identity: IdentityModel!)
    
    func willEnterBackground(profileVC: ProfileVC!)
    
    func didPressToBackButton(profileVC: ProfileVC!)
}


class ProfileVC: GenericTVC, GenericDataSourceDelegate, RefreshServiceDelegate {

    var delegate: ProfileVCDelegate!
    private(set) var viewModel: ProfileVM!
    
    
    // MARK: - Init methods
    
    
    init(delegate: ProfileVCDelegate!) {
        super.init()
        
        self.delegate = delegate
        self.addChromecastIfPossible = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.showBackButton()
        self.showTitle(with: "PROFILE".localized)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RefreshService.sharedInstance.addObserver(observer: self)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        RefreshService.sharedInstance.removeObserver(observer: self)
    }
    
    
    func update(with viewModel: ProfileVM!) {
        self.viewModel = viewModel
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.dataSource.delegate = self
        self.registerCellTypes()
        self.tableView.reloadData()
    }
    
    
    override func didPressToBackButton() {
        self.delegate.didPressToBackButton(profileVC: self)
    }
    
    // MARK: - 
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        
        let cm = self.viewModel.cellModel(indexPath: indexPath)
        cm?.didSelect()
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
    }
    
    
    // MARK: - RefreshServiceDelegate methods 
    
    
    func appWillEnterForeground() {
        self.delegate.willEnterBackground(profileVC: self)
    }
    
    func refreshSideMenu() {
        
    }
}
