//
//  SearchView.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/12/17.
//
//

import UIKit

protocol SearchViewDelegate {
    
    /** Method is call when user tap to suggest result cell */
    func didPressToSuggestResultCell(itemModel: ItemModel!, searchView: SearchView!)
    
    func didPressToCell(indexPath: IndexPath!, searchView: SearchView!)
    
    func loadItems(offset: Int!)
}


class SearchView: UIView, GenericCollectionDataSourceDelegate, GenericDataSourceDelegate {

    var view: UIView!
    var delegate: SearchViewDelegate?
    
    // MARK: -
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    private(set) var sortByTableView: UITableView!
    
    private var placeholder = "SEARCH_TITLE".localized

    // MARK: -
    
    private var viewModel: SearchVM!
    
    private var tableViewDataSource: GenericTableDatasource!
    private var sortByDataSource: GenericTableDatasource?
    private var collectionDataSource: GenericCollectionDataSource!
    
    // MARK: - Init methods
    
    
    override init(frame: CGRect) {
    
        super.init(frame: frame)
        
        /// Setup view from .xib file
        self.xibSetup()
    }
    
    init (frame: CGRect, placeholder: String!) {
        
        super.init(frame: frame)
        self.placeholder = placeholder
        
        /// Setup view from .xib file
        self.xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        /// Setup view from .xib file
        self.xibSetup()
    }
    
    
    // MARK: - Load methods 
    
    
    private func xibSetup() {
        
        self.view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        self.view.frame = bounds
        // Make the view stretch with containing view
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.view.backgroundColor = UIColor.mainBackgroundGreyColor()
        self.setupView()
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.addSubview(view)
    }
    
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SearchView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    private func setupView() {
        
        self.placeholderLabel.text = self.placeholder
        self.placeholderLabel.isHidden = false
    }
    
    
    // MARK: -
    
    
    open func update(searchVM: SearchVM!) {
        self.viewModel = searchVM
    }
    
    
    open func updateSuggestResult(searchVM: SearchVM!) {
        
        self.placeholderLabel.isHidden = true
        self.resultView.isHidden = true
        self.tableView.isHidden = false
        self.loadIndicator.isHidden = true
        self.collectionView.isHidden = true
        
        self.viewModel = searchVM
        
        self.tableViewDataSource = GenericTableDatasource(sections: self.viewModel.suggestResultSections)
        self.tableViewDataSource.delegate = self
        self.registerCellsForTable(tableView: self.tableView, sections: self.tableViewDataSource.sectionModels)
        
        self.tableView.dataSource = self.tableViewDataSource
        self.tableView.delegate = self.tableViewDataSource
        
        self.tableView.reloadData()
    }
    
    
    open func updateSuggestAndOtherResult(searchVM: SearchVM!) {
        
        self.placeholderLabel.isHidden = true
        self.resultView.isHidden = true
        self.tableView.isHidden = false
        self.loadIndicator.isHidden = true
        self.collectionView.isHidden = true
        
        self.viewModel = searchVM
        
        var sections = self.viewModel.suggestResultSections
        
        for sectionModel in self.viewModel.otherResultSections {
            sections.append(sectionModel)
        }
        
        self.tableViewDataSource = GenericTableDatasource(sections: sections)
        self.tableViewDataSource.delegate = self
        self.registerCellsForTable(tableView: self.tableView, sections: self.tableViewDataSource.sectionModels)
        
        self.tableView.dataSource = self.tableViewDataSource
        self.tableView.delegate = self.tableViewDataSource
        
        self.tableView.reloadData()
    }
    
    
    open func updateToLoadSearchResult() {
        self.tableView.isHidden = true
        self.placeholderLabel.isHidden = true
        self.resultView.isHidden = false
        self.loadIndicator.isHidden = false
        self.collectionView.isHidden = true
        
        self.updateInterfaceToDefault()
    }
    
    
    open func updateToVideoResults(searchVM: SearchVM!) {
        
        self.collectionView.contentInset = UIEdgeInsets.init(top: 8.0, left: 0, bottom: 0, right: 0.0)
        self.tableView.isHidden = true
        self.placeholderLabel.isHidden = true
        self.resultView.isHidden = false
        self.loadIndicator.stopAnimating()
        self.loadIndicator.isHidden = true
        self.collectionView.isHidden = false
        
        self.reloadCollectionView(searchVM: searchVM)
    }
    
    
    open func reloadCollectionView(searchVM: SearchVM!) {
        
        self.viewModel = searchVM
        
        self.countLabel.text = String(self.viewModel.count) + " " + "VIDEOS".localized
        
        self.collectionDataSource = GenericCollectionDataSource(sections: self.viewModel.sections)
        self.collectionDataSource.delegate = self
        self.registerCellsForCollectionView()
        
        self.collectionView.dataSource = self.collectionDataSource
        self.collectionView.delegate = self.collectionDataSource
        
        self.collectionView.reloadData()
    }
    
    
    open func clearText() {
        
        self.loadIndicator.isHidden = false
        self.resultView.isHidden = true
        self.tableView.isHidden = true
        self.placeholderLabel.isHidden = false
        self.collectionView.isHidden = true
    }
    
    
    // MARK: - Tools 
    
    
    private func registerCellsForTable(tableView: UITableView!, sections: Array<SectionModel>) {
        
        for sm in sections {
            for cm in sm.cellModels {
                tableView.register(UINib(nibName: cm.cellID, bundle: nil),
                                               forCellReuseIdentifier: cm.cellID)
            }
        }
    }
    
    
    private func registerCellsForCollectionView() {
        for sm in self.collectionDataSource.sectionModels {
            for cm in sm.cellModels {
                self.collectionView.register(UINib(nibName: cm.cellID, bundle: nil),
                                             forCellWithReuseIdentifier: cm.cellID)
            }
        }
    }
    
    
    private func updateInterfaceToDefault() {
        
        /// Bring subview to front top view
        self.view.bringSubview(toFront: self.topView)
        
        /// Changed text on the labels
        self.sortByLabel.text = "SORT_BY".localized
        self.countLabel.text = "0 "+"VIDEOS".localized
        
        self.tableView.separatorStyle = .none
        
        self.topView.backgroundColor = UIColor.mainBackgroundGreyColor()
        self.separatorView.isHidden = true
        
        /// Create sort by tableView
        if self.sortByTableView == nil {
            self.sortByTableView = UITableView(frame: CGRect.init(x: 0, y: 46.0, width: self.view.frame.size.width, height: 0.0), style: .plain)
            self.sortByTableView.tableFooterView = UIView()
            self.sortByTableView.backgroundColor = UIColor.clear
            self.sortByTableView.estimatedRowHeight = 10.0
            self.sortByTableView.separatorStyle = .none
            
            self.topView.addSubview(self.sortByTableView)
        }
        
        /// Reload sort by table view
        self.sortByDataSource = GenericTableDatasource.init(sections: self.viewModel.sortBySections)
        self.sortByDataSource?.delegate = self
        
        self.registerCellsForTable(tableView: self.sortByTableView, sections: (self.sortByDataSource?.sectionModels)!)
        
        self.sortByTableView.delegate = self.sortByDataSource
        self.sortByTableView.dataSource = self.sortByDataSource
        
        self.sortByTableView.reloadData()
    }
    
    
    /** Method show top menu for choose sort type */
    private func showSortByMenu() {
        
        self.separatorView.layer.opacity = 0.0
        self.separatorView.isHidden = false
        
        self.sortByTableView.isHidden = false
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        
                        self.topView.frame = CGRect.init(x: self.topView.frame.origin.x,
                                                         y: self.topView.frame.origin.y,
                                                         width: self.topView.frame.size.width,
                                                         height: 182.0)
                        
                        self.sortByTableView.frame = CGRect.init(x: self.sortByTableView.frame.origin.x,
                                                                 y: self.sortByTableView.frame.origin.y,
                                                                 width: self.sortByTableView.frame.size.width,
                                                                 height: 136.0)
                        self.countLabel.layer.opacity = 0.0
                        self.separatorView.layer.opacity = 0.25
                        
                        self.arrowIcon.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                        
                        self.topView.backgroundColor = UIColor.mainBackgroundDarkGreyColor()
                        
                        //self.topView.layoutIfNeeded()
                        
        }) { (isAnimated: Bool) in
            self.countLabel.isHidden = true
        }
    }
    
    
    /** Method hide top menu for choose sort type */
    private func hideSortByMenu() {
        
        self.countLabel.layer.opacity = 0.0
        self.countLabel.isHidden = false
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        
                        self.topView.frame = CGRect.init(x: self.topView.frame.origin.x,
                                                         y: self.topView.frame.origin.y,
                                                         width: self.topView.frame.size.width,
                                                         height: 46.0)
                        
                        self.sortByTableView.frame = CGRect.init(x: self.sortByTableView.frame.origin.x,
                                                                 y: self.sortByTableView.frame.origin.y,
                                                                 width: self.sortByTableView.frame.size.width,
                                                                 height: 0)
                        
                        self.countLabel.layer.opacity = 1.0
                        self.separatorView.layer.opacity = 0.0
                        
                        self.arrowIcon.transform = CGAffineTransform(rotationAngle: -2*CGFloat(Double.pi))
                        
                        self.topView.backgroundColor = UIColor.mainBackgroundGreyColor()
                        
                        self.topView.layoutIfNeeded()
                        
        }) { (isAnimated: Bool) in
            
            self.separatorView.isHidden = true
            self.sortByTableView.isHidden = true
        }
    }
    
    
    // MARK: - GenericDataSourceDelegate methods 
    
    
    func didPressToCell(with indexPath: IndexPath!, dataSource: GenericTableDatasource!) {
        
        if self.sortByDataSource == dataSource {
            
            let si = self.viewModel.didSelectCell(indexPath: indexPath)
            self.typeLabel.text = si.title
            self.sortByTableView.reloadData()
            
            self.viewModel.sortVideos(sortedKey: si.actionKey,
                                        completion: {
                                            //self.updateViewModel(subCategoryVM: self.viewModel)
            })
            
            self.hideSortByMenu()
        } else if dataSource == self.tableViewDataSource {
            
            if indexPath.section == 0 && indexPath.row == 0 {
                return
            }
        
            let item: ItemModel = self.viewModel.suggestResultItemModel(indexPath: indexPath)
            self.delegate?.didPressToSuggestResultCell(itemModel: item, searchView: self)
        }
    }
    
    
    private func setupCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize.init(width: UIScreen.main.bounds.width - 30.0/2.1, height: (UIScreen.main.bounds.width)/4.05)
        self.collectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        //self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 15.0, bottom: 0, right: 15.0)
    }
    
    
    // MARK: - Actions 
    
    
    @IBAction func sortByButtonAction(_ sender: Any) {
        
        if self.topView.frame.size.height == 46 {
            self.showSortByMenu()
        } else {
            self.hideSortByMenu()
        }
    }
    
    
    // MARK: - GenericCollectionDataSourceDelegate methods
    
    
    func didPressToCell(indexPath: IndexPath!, dataSource: GenericCollectionDataSource!) {
        self.delegate?.didPressToCell(indexPath: indexPath, searchView: self)
    }
    
    
    func willDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func didEndDisplayCell(with tableView: UITableView!, tableViewCell: UITableViewCell!, indexPath: IndexPath!) {
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView!) {
        
    }
    
    
    func collectionScrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height)) < 100 && (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height)) > 0 && scrollView == self.collectionView {
            
            //NSLog(@" scroll to bottom!");
            if(self.viewModel.isCanDownload){ // no need to worry about threads because this is always on main thread.
                self.viewModel.isCanDownload = false
                self.delegate?.loadItems(offset: self.viewModel.offset)
            }
        }
    }
}
