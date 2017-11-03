//
//  LinkYourRokuVC.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 01/06/2017.
//
//

import UIKit

protocol LinkYourRokuVCDelegate {
    
    func didValidCodeRoku(code: String!)
    
    func didPressToBackButton(linkYourRokuVC: LinkYourRokuVC!)
}


class LinkYourRokuVC: GenericTVC {
    
    var delegate: LinkYourRokuVCDelegate!
    private(set) var viewModel: LinkYourRokuVM!
    
    
    // MARK: - Init methods
    
    
    init(delegate: LinkYourRokuVCDelegate!) {
        super.init()
        
        self.delegate = delegate
        self.addChromecastIfPossible = false
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
    
    
    func update(with viewModel: LinkYourRokuVM!) {
        self.viewModel = viewModel
        
        self.showTitle(with: self.viewModel.title)
        
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.registerCellTypes()
        self.tableView.reloadData()
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
        self.delegate?.didPressToBackButton(linkYourRokuVC: self)
    }
}

