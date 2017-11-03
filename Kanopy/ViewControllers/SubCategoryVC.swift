//
//  SubCategoryVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/9/17.
//
//

import UIKit

protocol SubCategoryVCDelegate {
    
    /** Method is call when user tap to back button */
    func didPressToBackButton(subcategoryVC: SubCategoryVC!)
    
    /** Method is call when user tap to cell and choose item on the table view */
    func didPressToItem(item: ItemModel!, subcategoryVC: SubCategoryVC!)
    
    func loadItems(subCategoryVC: SubCategoryVC!)
}

class SubCategoryVC: CreditsVC, GenericDataSourceDelegate, SubCategoryVMDelegate {

    // MARK: - UI
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    // MARK: -
    
    private(set) var delegate: SubCategoryVCDelegate!
    private(set) var titleValue: String!
    private(set) var viewModel: SubCategoryVM!
    
    private(set) var isCan: Bool = false
    
    
    // MARK: - Init methods 
    
    
    init(title: String!, subCategoryVM: SubCategoryVM!, delegate: SubCategoryVCDelegate!) {
        super.init(nibName: "SubCategoryVC", bundle: nil)
        
        self.delegate = delegate
        self.titleValue = title
        self.viewModel = subCategoryVM
        self.addChromecastIfPossible = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showBackButton()
        self.showTitle(with: self.titleValue)
        self.updateInterfaceToDefault()
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets.init(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    override func didPressToBackButton() {
        self.delegate.didPressToBackButton(subcategoryVC: self)
    }
    
    
    // MARK: - Update interface methods 
    
    
    private func updateInterfaceToDefault() {
        self.updateCreditsLeft()
    }
    
    
    // MARK: -
    
    
    open func updateViewModel(subCategoryVM: SubCategoryVM!) {
        
        self.viewModel = subCategoryVM
        self.viewModel.delegate = self
//        self.countLabel.text = String(self.viewModel.countVideos()) + " " + "VIDEOS".localized
        
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.dataSource.delegate = self
        self.registerCellTypes()
        
        self.tableView.reloadData()
        self.updateCreditsLeft()
        self.isCan = true
    }
    
    
    open func updateTableView(_ viewModel: SubCategoryVM!) {
        
        self.dataSource.updateSectionModels(sections: self.viewModel.sections)
        self.tableView.reloadData()
        self.isCan = true
    }
    
    
    // MARK: - Actions 
    
    
    @IBAction func changeTypeButtonAction(_ sender: Any) {
        
    }
    
    
    // MARK: - GenericDataSourceDelegate methods 
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.delegate.didPressToItem(item: self.viewModel.itemModel(indexPath: indexPath),
                                         subcategoryVC: self)
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
    
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
        if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height)) < 100 && (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height)) > 0 {
            
            //NSLog(@" scroll to bottom!");
            if(self.viewModel.isCanDownload && self.isCan){ // no need to worry about threads because this is always on main thread.
                self.viewModel.isCanDownload = false
                self.isCan = false
                self.delegate.loadItems(subCategoryVC: self)
            }
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    }
    
    
    // MARK: -
    
    
    func reloadData(subCategoryVM: SubCategoryVM!) {
        self.tableView.reloadData()
    }
}
