//
//  MenuVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit

protocol MenuVCDelegate: class {
}

class MenuVC: GenericTVC, GenericDataSourceDelegate {
    
    private weak var delegate: MenuVCDelegate?
    private(set) var viewModel: MenuVM!
    private(set) var contentOffset: CGFloat = 0
    
    // MARK: - Init methods
    
    init(delegate: MenuVCDelegate?) {
        super.init()
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 13.0/255.0, green: 13.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        
        self.tableView.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        
    }
    
    override func keyboardWillHide() {
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Open methods
    
    
    func update(with viewModel: MenuVM!) {
        self.viewModel = viewModel
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.dataSource.delegate = self
        self.registerCellTypes()
        self.tableView.reloadData()
    }
    
    
    func setContentOffset() {
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: self.contentOffset), animated: false)
    }
    
    
    // MARK: - GenericDataSourceDelegate methods
    
    
    func didPressToCell(with indexPath:IndexPath!, dataSource: GenericTableDatasource!) {
        
        let cm = self.viewModel.cellModel(indexPath: indexPath)
        
        if cm?.cellID == TableCellIDs.loadTableCell || cm == nil {
            return
        }
        
        let cmm: MenuCellModel = cm as! MenuCellModel
        
        if cmm.isEnableSelected {
            
            /// Unselect current menu cell
            self.viewModel.unselectedCurrentMenuCell()
            
            /// Select new menu cell
            _ = self.viewModel.selectMenuCell(with: indexPath)
            self.tableView.reloadData()
        }
        
        cm?.didSelect()
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
    }
}
