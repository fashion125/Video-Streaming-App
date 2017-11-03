//
//  CustomAlertControllerVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/8/17.
//
//

import UIKit

protocol CustomAlertControllerVCDelegate {
    
}

class CustomAlertControllerVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var additionalButton: UIButton!
    
    // MARK: -
    
    private(set) var titleValue: String! = ""
    private(set) var messageValue: String! = ""
    private(set) var buttonTitle: String! = ""
    private(set) var additionalButtonTitle: String! = ""
    
    private(set) var buttonActionBlock: (() -> Void?)!
    private(set) var additionalButtonActionBlock: (() -> Void?)!
    
    // MARK: -
    
    
    /** Init method for AlertController with one button */
    init(title: String!, message: String!, buttonTitle: String!, actionBlock: @escaping () -> Void!) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleValue = title
        self.messageValue = message
        self.buttonTitle = buttonTitle
        self.buttonActionBlock = actionBlock
        
        self.settingsForClearViewController()
    }
    
    
    init(title: String!, message: String!, buttonTitle: String!, additionalButtonTitle: String!,
         actionBlock: @escaping () -> Void!, additionalActionBlock: @escaping () -> Void!) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleValue = title
        self.messageValue = message
        self.buttonTitle = buttonTitle
        self.additionalButtonTitle = additionalButtonTitle
        self.buttonActionBlock = actionBlock
        self.additionalButtonActionBlock = additionalActionBlock
        
        self.settingsForClearViewController()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateLabels()
    }
    
    
    // MARK: - Private tools 
    
    
    private func settingsForClearViewController() {
        self.view.backgroundColor = UIColor.clear
        self.modalPresentationStyle = .overCurrentContext
    }
    
    
    private func updateLabels() {
        
        self.titleLabel.text = self.titleValue
        self.messageLabel.text = self.messageValue
        self.titleLabel.textColor = UIColor.mainOrangeColor()
        
        self.updateMainButton()
        self.updateAdditionalButtonIfNeeded()
    }
    
    
    private func updateMainButton() {
        self.mainButton.setTitle(self.buttonTitle, for: .normal)
        self.mainButton.updateButtonForAppleTV()
    }
    
    
    private func updateAdditionalButtonIfNeeded() {
        
        self.additionalButton.isHidden = true
        
        if self.additionalButtonTitle.characters.count > 0 {
            self.additionalButton.setTitle(self.additionalButtonTitle, for: .normal)
            self.additionalButton.updateButtonForAppleTV()
            self.additionalButton.isHidden = false
        }
    }
    
    
    // MARK: - Actions 
    
    
    @IBAction func mainButtonAction(_ sender: Any) {
        self.buttonActionBlock()
    }
    
    
    
    @IBAction func additionalButtonAction(_ sender: Any) {
        self.additionalButtonActionBlock()
    }
}
