//
//  SettingsVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/25/17.
//
//

import UIKit

protocol SettingsVCDelegate {
    
    func didPressSignOutButton()
    
    func didPressSignInButton()
    
    func didUpdateCellularDataUsage(_ value: Bool!)
    
    func didUpdateClosedCaptions(_ value: Bool!)
    
    func didPressVideoQuality()
    
    func didPressFeedback()
    
    func didPressBackButton(settingsVC: SettingsVC!)
}


class SettingsVC: GenericTVC, GenericDataSourceDelegate {

    var delegate: SettingsVCDelegate!
    
    private(set) var viewModel: SettingsVM!
    
    
    // MARK: - Init method 
    
    
    init(delegate: SettingsVCDelegate!) {
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

        self.showBackButton()
        self.showTitle(with: "SETTINGS".localized)
        self.tableView.separatorStyle = .none
    }
    
    
    func update(with viewModel: SettingsVM!) {
        
        self.viewModel = viewModel
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.dataSource.delegate = self
        self.registerCellTypes()
        self.tableView.reloadData()
    }
    
    
    override func didPressToBackButton() {
        self.delegate.didPressBackButton(settingsVC: self)
    }
    
    
    // MARK: - GenericDataSourceDelegate methods 
    
    
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
}
