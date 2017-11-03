//
//  LoadVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/8/17.
//
//

import UIKit

class LoadVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Init methods
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.clear
        self.modalPresentationStyle = .overCurrentContext
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgView.addBlur(.dark)
        self.loadIndicator.startAnimating()
    }
}
