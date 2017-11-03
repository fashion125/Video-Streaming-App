//
//  GenericTVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 1/31/17.
//
//

import UIKit

class GenericTVC: KeyboardVC {

    var tableView: UITableView!
    
    private(set) var tapGesture: UITapGestureRecognizer!
    
    /// Keyboard height value
    open var kbHeight: CGFloat = 0.0
    open var topMargin: CGFloat = 0.0
    /// Data source for table view
    private var _dataSource: GenericTableDatasource!
    var dataSource: GenericTableDatasource! {
        set {
            _dataSource = newValue
            self.tableView.delegate = _dataSource
            self.tableView.dataSource = _dataSource
        }
        get {
            return _dataSource
        }
    }
    
    // MARK: - Init methods
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        /// Default UITableViewStyle is plain
        self.tableView = self.newTableView(style: UITableViewStyle.plain)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /// Default UITableViewStyle is plain
        self.tableView = self.newTableView(style: UITableViewStyle.plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateTableViewFrame()
    }
    
    // MARK: - Tools
    
    private func newTableView(style: UITableViewStyle!) -> UITableView {
        let tv: UITableView = UITableView(frame: CGRect.zero, style: style)
        tv.tableFooterView = UIView()
        tv.backgroundColor = UIColor.clear
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        tv.estimatedRowHeight = 10.0
        
        return tv
    }
    
    open func updateTableViewFrame() {
        self.tableView.frame = CGRect(x: self.view.bounds.origin.x,
                                      y: self.view.bounds.origin.y + self.topMargin ,
                                      width: self.view.bounds.size.width,
                                      height: self.view.bounds.size.height - self.kbHeight - self.topMargin)
    }
    
    func registerCellTypes() {
        for sm: SectionModel in (self.dataSource?.sectionModels)! {
            for cm: GenericCellModel in sm.cellModels {
                self.tableView?.register(UINib(nibName: cm.cellID, bundle: nil),
                                         forCellReuseIdentifier: cm.cellID)
            }
        }
    }
    
    open func reloadCell(with indexPath: IndexPath!) {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath!],
                                  with: UITableViewRowAnimation.none)
        self.tableView.endUpdates()
    }
    
    
    // MARK: - Keyboard notifications
    
    
    override func keyboardWillShow(notification: NSNotification) {
        let duration: TimeInterval = TimeInterval((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue)
        // Save kb height
        self.kbHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        // But we still should display accurate animation of table view resizing
        UIView.animate(withDuration: duration) {
            self.updateTableViewFrame()
            self.view.setNeedsLayout()
        }
        
        UIView.animate(withDuration: duration,
                       animations: { 
                        self.updateTableViewFrame()
                        self.view.setNeedsDisplay()
                        self.scrollToCell()
        }) { (isTrue: Bool) in
            self.scrollToCell()
        }
    }
    
    
    override func keyboardWillHide() {
        self.kbHeight = 0.0
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame = self.view.bounds
            self.view.setNeedsLayout()
        }
    }
    
    
    override func keyboardDidShow(notification: NSNotification) {
        
    }
    
    
    override func keyboardDidHide() {
        
    }
    
    
    // MARK: - Actions 
    
    
    func tapGestureAction() {
        self.view.endEditing(true)
    }
    
    
    func scrollToCell() {
        
    }
}
