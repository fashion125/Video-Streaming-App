//
//  GenericSearchVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit

protocol GenericSearchVCDelegate {
    
    /** Method is call when user tap to search button */
    func didPressSearchButton(searchVC: GenericSearchVC!)
    
    /** Optional method. Is call when user tap to 'Cancel' button on the nav bar */
    func didPressToCancelButton(searchVC: GenericSearchVC!)
    
    /** Method is call when user enter in search field text */
    func didChangeTextOnSearchBar(text: String!, searchVC: GenericSearchVC!)
    
    /** Method is call when user tap to 'search' button on the keyboard or choose title on the suggest results list
     */
    func search(text: String!, searchVC: GenericSearchVC!)
    
    /** Method is call when user clear search bar field */
    func clearTextOnSearchBar(searchVC: GenericSearchVC!)
    
    /** Method is call when user choose item on the search result list */
    func didChooseItem(item: ItemModel!, searchVC: GenericSearchVC!)
    
    func loadItems(offset: Int!, text: String!)
}

class GenericSearchVC: GenericTVC, UISearchBarDelegate, SearchViewDelegate, SearchVMDelegate {
    
    // MARK: - UI
    
    private(set) var searchBGView: UIView!
    var searchBar: UISearchBar!
    private(set) var searchView: SearchView?
    
    private var placeholder = "SEARCH_TITLE".localized
    private var width = CGFloat(0)
    private var heigth = CGFloat(0)
    
    private var keyboardHeight: CGFloat = 0
    
    private(set) var isOpenSearch: Bool! = false
    
    
    // MARK: - Property
    
    open var searchDelegate: GenericSearchVCDelegate?
    
    private(set) var searchViewModel: SearchVM!
    
    
    // MARK: - Init methods
    
    
    init(placeholder: String!, width: CGFloat, heigth: CGFloat) {
        super.init()
        self.placeholder = placeholder
        self.width = width
        self.heigth = heigth
    }
    
    
    override init() {
        super.init()
    }
    
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cyrcle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showSearchBarItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateFrames()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.searchBGView != nil {
            self.searchView?.updateToVideoResults(searchVM: self.searchViewModel)
            self.showSearchBarAnimation(isBecomeFirstResponder: false)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.searchBGView != nil {
            self.searchBar.resignFirstResponder()
            self.hideSearchBarWithNotDelete()
        }
    }
    
    
    // MARK: - Update interface methods 
    
    
    func showSearchBarItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "search_icon"), style: .plain, target: self, action: #selector(GenericSearchVC.didPressToSearchBarButtonItem))
    }
    
    
    func updateFrames() {
        
        self.updateSearchBarFrame()
        self.updateSearchViewFrame()
        self.updateSearchResultCollectionView()
    }
    
    
    func updateSearchBarFrame() {
        if self.searchBGView != nil {
            self.width = (self.navigationController?.navigationBar.bounds.width)!
            self.heigth = (self.navigationController?.navigationBar.bounds.height)!
            
            self.searchBGView.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.heigth)
            self.searchBar.frame = CGRect.init(x: 15, y: 0, width: self.searchBGView.bounds.width - 15.0, height: self.searchBGView.bounds.height)
        }
    }
    
    
    func updateSearchViewFrame() {
        
        self.searchView?.frame = CGRect.init(x: (self.view.bounds.origin.x),
                                             y: (self.view.bounds.origin.y),
                                             width: (self.view.bounds.width),
                                             height: self.view.bounds.height - self.keyboardHeight)
    }
    
    
    func updateSearchResultCollectionView() {
        
        if self.searchViewModel != nil && self.searchView != nil && !(self.searchView?.collectionView.isHidden)! {
            self.searchViewModel.generateVideoSections(videos: self.searchViewModel.videos)
            self.searchView?.reloadCollectionView(searchVM: self.searchViewModel)
        }
    }
    
    
    override func didUpdateCastState() {
        if (!self.isOpenSearch) {
            if (self.menuIconPresent) {
                self.initializeMenuBarItem()
            } else {
                self.showBackButton()
            }
        }
    }
    
    
    // MARK: - Actions
    
    
    func didPressToSearchBarButtonItem() {
        
        self.isOpenSearch = true
        self.searchDelegate?.didPressSearchButton(searchVC: self)
    }
    
    
    // MARK: - Override methods
    
    
    /** Method is call when keyboard will show */
    override func keyboardWillShow(notification: NSNotification) {
        
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let animationDuration: TimeInterval = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        self.keyboardHeight = (keyboardSize?.size.height)!
        
        UIView.animate(withDuration: animationDuration) { 
            self.searchView?.frame = CGRect.init(x: (self.searchView?.bounds.origin.x)!,
                                                y: (self.searchView?.bounds.origin.y)!,
                                                width: (self.searchView?.bounds.width)!,
                                                height: self.view.bounds.height - (keyboardSize?.height)!)
            self.searchView?.layoutIfNeeded()
        }
    }
    
    
    /** Method is call when keyboard will hide */
    override func keyboardWillHide() {
        
        self.keyboardHeight = 0
        
        UIView.animate(withDuration: 0.2) {
            self.searchView?.frame = CGRect.init(x: (self.searchView?.bounds.origin.x)!,
                                                y: (self.searchView?.bounds.origin.y)!,
                                                width: (self.searchView?.bounds.width)!,
                                                height: self.view.bounds.height)
            self.searchView?.layoutIfNeeded()
        }
    }
    
    
    override func keyboardDidShow(notification: NSNotification) {
        
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let animationDuration: TimeInterval = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        self.keyboardHeight = (keyboardSize?.size.height)!
        
        UIView.animate(withDuration: animationDuration) {
            self.searchView?.frame = CGRect.init(x: (self.searchView?.bounds.origin.x)!,
                                                 y: (self.searchView?.bounds.origin.y)!,
                                                 width: (self.view.bounds.width),
                                                 height: self.view.bounds.height - (keyboardSize?.height)!)
            self.searchView?.layoutIfNeeded()
        }
    }
    
    
    override func keyboardDidHide() {
        
        self.keyboardHeight = 0
        
        UIView.animate(withDuration: 0.2) {
            self.searchView?.frame = CGRect.init(x: (self.searchView?.bounds.origin.x)!,
                                                 y: (self.searchView?.bounds.origin.y)!,
                                                 width: (self.view.bounds.width),
                                                 height: self.view.bounds.height)
            self.searchView?.layoutIfNeeded()
        }
    }

    
    // MARK: - Open methods
    
    
    open func update(searchVM: SearchVM!) {
        self.searchViewModel = searchVM
        self.searchViewModel.delegate = self
    }
    
    open func updateIntefaceForSearch() {
        self.createSearchBGView()
        self.createSearchBar()
        self.createSearchView()
        self.searchBGView.addSubview(self.searchBar)
        
        self.showSearchBarAnimation(isBecomeFirstResponder: true)
    }
    
    
    open func updateInterfaceForDefault() {
        self.hideSearchBarAnimation()
    }
    
    
    open func updateSuggestResults(searchVM: SearchVM!) {
        
        self.update(searchVM: searchVM)
        
        if self.searchBar != nil && (self.searchBar.text?.characters.count)! > 0 && self.searchBar.isFirstResponder && self.searchBar.text == self.searchViewModel.currentSearchText  {
            self.searchView?.updateSuggestResult(searchVM: searchVM)
        }
    }
    
    
    open func updateSuggestAndOtherResults(searchVM: SearchVM!) {
        
        self.update(searchVM: searchVM)
        
        if self.searchBar != nil && (self.searchBar.text?.characters.count)! > 0 && self.searchBar.isFirstResponder && self.searchBar.text == self.searchViewModel.currentSearchText  {
            self.searchView?.updateSuggestAndOtherResult(searchVM: searchVM)
        }
    }
    
    
    open func updateVideoResults(searchVM: SearchVM!) {
        
        self.update(searchVM: searchVM)
        self.searchView?.updateToVideoResults(searchVM: searchVM)
    }
    
    
    open func updateInterfaceForClearSearchResults() {
        self.searchView?.clearText()
    }
    
    // MARK: - Tools
    
    
    /** Method create search bacgkround view if it equal to nil */
    private func createSearchBGView() {
        
        if self.searchBGView == nil {
            if (self.width == CGFloat(0) || self.heigth == CGFloat(0)) {
                self.width = (self.navigationController?.navigationBar.bounds.width)!
                self.heigth = (self.navigationController?.navigationBar.bounds.height)!
            }
            
            self.searchBGView = UIView.init(frame: CGRect.init(x: 0,
                                                               y: 0,
                                                               width: self.width,
                                                               height: self.heigth))
            self.searchBGView.backgroundColor = UIColor.navBarBackgroundColor()
        }
    }
    
    
    func search(text: String!) {
        self.searchBar.resignFirstResponder()
        self.searchView?.updateToLoadSearchResult()
        self.searchDelegate?.search(text: text, searchVC: self)
    }
    
    
    /** Method create search bar view if it equal to nil */
    private func createSearchBar() {
        
        if self.searchBar == nil {
            self.searchBar = UISearchBar.init(frame: CGRect.init(x: 15, y: 0, width: self.searchBGView.bounds.width - 15.0, height: self.searchBGView.bounds.height))
            self.searchBar.delegate = self
            self.searchBar.placeholder = "SEARCH".localized
            self.searchBar.showsCancelButton = true
            self.searchBar.backgroundImage = UIImage()
            self.searchBar.tintColor = UIColor.white
            self.searchBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.searchBar.keyboardAppearance = .dark
            
            let tf: UITextField! = self.searchBar.subviews[0].subviews[1] as! UITextField
            tf?.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2470588235, alpha: 1)
            tf?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    
    /** Method create search view if it equal to nil */
    private func createSearchView() {
        
        if self.searchView == nil {
            self.searchView = SearchView.init(frame: self.view.bounds, placeholder: self.placeholder)
            self.searchView?.delegate = self
            self.searchView?.update(searchVM: self.searchViewModel)
        }
    }
    
    
    /** Method start animation for show search view */
    private func showSearchBarAnimation(isBecomeFirstResponder: Bool!) {
        
        self.searchBGView.layer.opacity = 0.0
        self.searchView?.layer.opacity = 0.0
        
        self.navigationController?.navigationBar.addSubview(self.searchBGView)
        self.view.addSubview(self.searchView!)
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.searchBGView.layer.opacity = 1.0
            self.searchView?.layer.opacity = 1.0
            
        }) { (isCompletion: Bool) in
            
            if isBecomeFirstResponder == true && self.searchBar != nil {
                self.searchBar.becomeFirstResponder()
                self.tableView.isHidden = true
            }
        }
    }
    
    
    private func hideSearchBarAnimation() {
        
        self.tableView.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.searchBGView.layer.opacity = 0.0
            self.searchView?.layer.opacity = 0.0
            
        }) { (isCompletion: Bool) in
            
            self.searchBGView.removeFromSuperview()
            self.searchView?.removeFromSuperview()
            self.searchView = nil
            self.searchBGView = nil
            self.searchBar = nil
        }
    }
    
    
    private func hideSearchBarWithNotDelete() {
        self.tableView.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.searchBGView.layer.opacity = 0.0
            self.searchView?.layer.opacity = 0.0
            
        }) { (isCompletion: Bool) in
            
            self.removeSearchBGViewFromSuperview()
            self.removeSearchViewFromSuperview()
        }
    }
    
    
    private func removeSearchBGViewFromSuperview() {
        if  self.searchBGView != nil && self.searchBGView.superview != nil {
            self.searchBGView.removeFromSuperview()
        }
    }
    
    
    private func removeSearchViewFromSuperview() {
        if  self.searchView != nil && self.searchView?.superview != nil {
            self.searchView?.removeFromSuperview()
        }
    }
    
    
    // MARK: - Search bar delegate methods 
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.searchDelegate?.didChangeTextOnSearchBar(text: searchText, searchVC: self)
        } else {
            self.searchDelegate?.clearTextOnSearchBar(searchVC: self)
            self.searchView?.clearText()
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isOpenSearch = false
        self.searchDelegate?.didPressToCancelButton(searchVC: self)
        self.didUpdateCastState()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search(text: searchBar.text)
    }
    
    
    // MARK: - SearchViewDelegate methods 
    
    
    func didPressToSuggestResultCell(itemModel: ItemModel!, searchView: SearchView!) {
        self.searchBar.text = itemModel.title
        self.search(text: itemModel.title)
    }
    
    
    func didPressToCell(indexPath: IndexPath!, searchView: SearchView!) {
        let item = self.searchViewModel.itemModel(indexPath: indexPath)
        self.searchDelegate?.didChooseItem(item: item,
                                           searchVC: self)
    }
    
    func loadItems(offset: Int!) {
        self.searchDelegate?.loadItems(offset: offset, text: self.searchBar.text)
    }
    
    
    // MARK: - SearchVMDelegate
    
    
    func didChooseItem(item: ItemModel!, searchViewModel: SearchVM!) {
        self.searchDelegate?.didChooseItem(item: item, searchVC: self)
    }
}
