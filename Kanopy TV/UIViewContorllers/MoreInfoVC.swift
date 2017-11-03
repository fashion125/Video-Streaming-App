//
//  MoreInfoVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

protocol MoreInfoVCDelegate {
    
}

class MoreInfoVC: GenericVC {

    private(set) var viewModel: MoreInfoVM!
    private(set) var delegate: MoreInfoVCDelegate!
    
    @IBOutlet weak var bgBlurView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private(set) var tableDataSource: GenericTableDatasource!
    
    // MARK: - Init methods 
    
    
    init(viewModel: MoreInfoVM!, delegate: MoreInfoVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        self.view.backgroundColor = UIColor.clear
        self.modalPresentationStyle = .overCurrentContext
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgBlurView.addBlur(.dark)
        self.backButton.setTitle("Back", for: .normal)
        self.updateButtonDesign(button: self.backButton)
    }
    
    
    open func updateViewModel(_ viewModel: MoreInfoVM!) {
        self.viewModel = viewModel
        
        self.reloadTableView()
    }
    
    
    private func reloadTableView() {
        
        self.tableDataSource = GenericTableDatasource.init(sections: self.viewModel.sections)
        self.tableView.dataSource = self.tableDataSource
        self.tableView.delegate = self.tableDataSource
        self.tableDataSource.canFocus = true
        
        for sm in self.tableDataSource.sectionModels {
            for cm in sm.cellModels {
                self.tableView?.register(UINib(nibName: cm.cellID, bundle: nil),
                                         forCellReuseIdentifier: cm.cellID)
            }
        }
        
        self.tableView.isScrollEnabled = true
        self.tableView.reloadData()
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
    }
    
    private func updateButtonDesign(button: UIButton!) {
        
        button.setBackgroundImage(UIImage.init(color: UIColor.mainOrangeColor()), for: .focused)
        button.setBackgroundImage(UIImage.init(color: UIColor.init(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0)), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .focused)
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
