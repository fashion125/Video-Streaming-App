//
//  ChooseItemVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/27/17.
//
//

import UIKit

protocol ChooseItemVCDelegate {
    
    func didPressToBackButton(chooseItemVC: ChooseItemVC!)
    
    func didPressToCell(indexPath: IndexPath!, chooseItemVC: ChooseItemVC!)
}


class ChooseItemVC: GenericTVC, GenericDataSourceDelegate {

    private(set) var delegate: ChooseItemVCDelegate!
    private(set) var viewModel: ChooseItemVM!
    
    
    // MARK: - Init method 
    
    
    init(delegate: ChooseItemVCDelegate!) {
        super.init()
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.navigationItem.leftBarButtonItem = self.customBackButton()
    }
    
    
    /** This method return custom back button */
    func customBackButton() -> UIBarButtonItem {
        
        let icon = UIImage.init(named: "back_without_text_icon")
        let backItem = UIBarButtonItem.init(image: icon,
                                            style: UIBarButtonItemStyle.plain,
                                            target: self,
                                            action: #selector(ActivationVC.didPressToBackButton))
        
        return backItem
    }
    
    
    override func didPressToBackButton() {
        self.delegate?.didPressToBackButton(chooseItemVC: self)
    }

    
    // MARK: -
    
    
    func update(with viewModel: ChooseItemVM!) {
        
        self.viewModel = viewModel
        
        self.showTitle(with: self.viewModel.title)
        
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.dataSource.delegate = self
        self.registerCellTypes()
        self.tableView.reloadData()
    }
    
    
    // MARK: - GenericDataSourceDelegate methods 
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        
        let cm = self.viewModel.cellModel(indexPath: indexPath)
        
        if cm?.cellID != TableCellIDs.titleHeaderTableCell {
            self.delegate.didPressToCell(indexPath: indexPath, chooseItemVC: self)
        }
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
    }
}
