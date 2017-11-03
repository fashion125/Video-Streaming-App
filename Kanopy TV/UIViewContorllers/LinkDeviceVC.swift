//
//  LinkDeviceVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/14/17.
//
//

import UIKit

protocol LinkDeviceVCDelegate {
    
    /** This method is call when user tap "Get new code" button*/
    func didPressGetCodeButton()
    
    /** This method is call when user tap "Watch now" button*/
    func didPressWatchNow()
    
    /** This method is call when user will show LinkDeviceVC */
    func willShow(_ linkDeviceVC: LinkDeviceVC!)
    
    /** This method is call when user did hide LinDeviceVC */
    func didHide(_ linkDeviceVC: LinkDeviceVC!)
}

class LinkDeviceVC: UIViewController {

    private(set) var delegate: LinkDeviceVCDelegate!
    private(set) var viewModel: LinkDeviceVM!
    
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var firstCodeLabel: UILabel!
    @IBOutlet weak var secondCodeLabel: UILabel!
    @IBOutlet weak var thirdCodeLabel: UILabel!
    @IBOutlet weak var fourthCodeLabel: UILabel!
    @IBOutlet weak var fifthCodeLabel: UILabel!
    @IBOutlet weak var sixthCodeLabel: UILabel!
    
    // MARK: - Init methods 
    
    
    init(delegate: LinkDeviceVCDelegate!, vm: LinkDeviceVM!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        self.viewModel = vm
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Init methods 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Link device"
        
        self.getCodeButton.updateButtonForAppleTV()
        self.update(vm: self.viewModel)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.delegate.willShow(self)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.delegate.didHide(self)
    }
    
    
    open func update(vm: LinkDeviceVM!) {
        self.viewModel = vm
        
        self.titleLabel.text = self.viewModel.title
        self.updateDescriptionLabel()
        self.iconImageView.image = UIImage.init(named: self.viewModel.iconImage)
        self.getCodeButton.setTitle(self.viewModel.buttonTitle, for: .normal)
        
        if (self.viewModel.authCode != nil) {
            self.showCodeLabels(code: self.viewModel.authCode!)
        } else {
            self.hideCodeLabels()
        }
        
        self.getCodeButton.isUserInteractionEnabled = self.viewModel.buttonIsEnabled
        self.updateFocusIfNeeded()
        self.setNeedsFocusUpdate()
        
        self.getCodeButton.titleLabel?.sizeToFit()
        
        self.getCodeButton.frame = CGRect.init(x: self.getCodeButton.bounds.origin.x,
                                               y: self.getCodeButton.bounds.origin.y,
                                               width: (self.getCodeButton.titleLabel?.bounds.width)! + 40.0,
                                               height: 68.0)
    }
    
    
    open func updateDescriptionLabel() {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        
        let attrString = NSMutableAttributedString(string: self.viewModel.descriptionText)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        self.descriptionLabel.attributedText = attrString
    }
    
    // MARK: -
    
    
    private func codeLabels() -> Array<UILabel> {
        return [self.firstCodeLabel, self.secondCodeLabel, self.thirdCodeLabel, self.fourthCodeLabel, self.fifthCodeLabel, self.sixthCodeLabel]
    }
    
    
    private func showCodeLabels(code: String!) {
        for (index, label) in self.codeLabels().enumerated() {
            label.isHidden = false
            let c = code.character(i: index)
            label.text = String(c)
        }
    }
    
    
    private func hideCodeLabels() {
        for label in self.codeLabels() {
            label.isHidden = true
        }
    }
    
    
    // MARK: - 
    
    
    @IBAction func getCodeButtonAction(_ sender: Any) {
        self.viewModel.command.execute()
    }
}
