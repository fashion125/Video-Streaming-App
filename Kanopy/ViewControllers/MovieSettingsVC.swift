//
//  MovieSettingsVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 3/20/17.
//
//

import UIKit

protocol MovieSettingsVCDelegate {
    
    /** Method is call when user tap to close button */
    func didPressToCloseButton(movieSettingsVC: MovieSettingsVC!)
    
    /** Method is call when user choose caption on the table view */
    func didChooseCaption(indexPath: IndexPath!, movieSettingsVC: MovieSettingsVC!)
}

class MovieSettingsVC: UIViewController, GenericDataSourceDelegate {

    
    private(set) var delegate: MovieSettingsVCDelegate?
    private var captionsDataSource: GenericTableDatasource!
    private(set) var viewModel: MovieSettingsVM!
    
    @IBOutlet weak var captionsTableView: UITableView!
    
    
    // MARK: - Init method 
    
    
    init(delegate: MovieSettingsVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: -
    
    
    open func updateView(newViewModel: MovieSettingsVM!) {
        self.viewModel = newViewModel
        
        self.captionsDataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.captionsDataSource.delegate = self
        self.captionsTableView.dataSource = self.captionsDataSource
        self.captionsTableView.delegate = self.captionsDataSource
        
        self.registerCellTypes()
        self.captionsTableView.reloadData()
    }
    
    
    func registerCellTypes() {
        for sm: SectionModel in (self.captionsDataSource?.sectionModels)! {
            for cm: GenericCellModel in sm.cellModels {
                self.captionsTableView?.register(UINib(nibName: cm.cellID, bundle: nil),
                                         forCellReuseIdentifier: cm.cellID)
            }
        }
    }

    
    // MARK: - GenericTableDataSourceDelegate 
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        
        self.delegate?.didChooseCaption(indexPath: indexPath,
                                        movieSettingsVC: self)
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
    }
    
    
    // MARK: - Actions 
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.delegate?.didPressToCloseButton(movieSettingsVC: self)
    }
}
