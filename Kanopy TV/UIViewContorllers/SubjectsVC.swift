//
//  SubjectsVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/28/17.
//
//

import UIKit

protocol SubjectsVCDelegate {
    
    /** Method is call when user tap to category model */
    func didChooseCategoryModel(categoryModel: CategoryModel!)
}


class SubjectsVC: GenericVC, GenericDataSourceDelegate {

    private(set) var delegate: SubjectsVCDelegate!
    private(set) var viewModel: SubjectsVM!
    private(set) var tableDataSource: GenericTableDatasource!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: - Init method
    
    
    init(delegate: SubjectsVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgView.addBlur(.dark)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    open func updateViewModel(_ viewModel: SubjectsVM!) {
        self.viewModel = viewModel
        
        self.reloadTableView()
    }
    
    
    // MARK: - Tools 
    
    
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
    
    
    // MARK: - GenericDataSourceDelegate methods 
    
    
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
