//
//  MembershipListVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

protocol MembershipListVCDelegate {
    
    /** This method is call when user choose membership */
    func didChooseIdentity(identity: IdentityModel!)
}

class MembershipListVC: GenericVC, GenericDataSourceDelegate {

    private(set) var delegate: MembershipListVCDelegate!
    private(set) var viewModel: MembershipListVM!
    private(set) var tableDataSource: GenericTableDatasource!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Init methods 
    
    
    init(delegate: MembershipListVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateLabels()
    }
    
    
    // MARK: - Open tools 
    
    
    open func updatViewModel(viewModel: MembershipListVM!) {
        self.viewModel = viewModel
        
        self.reloadTableView()
    }
    
    
    // MARK: - Private tools 
    
    
    private func updateLabels() {
        self.titleLabel.text = "MY_MEMBERSHIPS".localized
        self.descriptionLabel.text = "SELECT_ANOTHER_LIBRARY_DESCRIPTION".localized
    }
    
    
    private func reloadTableView() {
        
        self.tableDataSource = GenericTableDatasource.init(sections: self.viewModel.sections)
        self.tableView.dataSource = self.tableDataSource
        self.tableView.delegate = self.tableDataSource
        self.tableDataSource.canFocus = true
        self.tableDataSource.delegate = self
        
        for sm in self.tableDataSource.sectionModels {
            for cm in sm.cellModels {
                self.tableView?.register(UINib(nibName: cm.cellID, bundle: nil),
                                         forCellReuseIdentifier: cm.cellID)
            }
        }
        
        self.tableView.isScrollEnabled = true
        self.tableView.reloadData()
    }
    
    
    // MARK: -
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        let sm = self.tableDataSource.sectionModels[indexPath.section]
        let cm = sm.cellModels[indexPath.row]
        
        cm.didSelect()
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
    }
}
