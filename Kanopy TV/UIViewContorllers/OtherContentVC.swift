//
//  OtherContentVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/28/17.
//
//

import UIKit

class OtherContentVC: GenericContentVC {

    @IBOutlet weak var bgThumbImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var contentLoadTitle: UILabel!
    
    
    // MARK: - Init methods 
    
    override init(delegate: GenericContentVCDelegate!, url: URL!, title: String!) {
        super.init(delegate: delegate, url: url, title: title)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentLoadTitle.text = self.titleValue
    }
    
    
    override func backgroundThumbImageView() -> UIImageView? {
        return self.bgThumbImageView
    }
    
    
    override func contentContainerView() -> UIView? {
        return nil
    }
    
    
    override func backgroundView() -> UIView? {
        return self.bgView
    }
    
    
    // MARK: -
    
    
    override func publicCreditsLeftView() -> UIView? {
        return nil
    }
    
    
    override func countLabel() -> UILabel? {
        return nil
    }
    
    
    override func titleLabel() -> UILabel? {
        return nil
    }
}
