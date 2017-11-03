//
//  MembershipInfoVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 8/7/17.
//
//

import UIKit

protocol MembershipInfoVCDelegate {
    
    /** This method is call when user tap to select membership button */
    func didPressSelectMembershipButton(membershipInfoVC: MembershipInfoVC!)
    
    
    /** This method is call when user tap to back button */
    func didPressBackButton(membershipInfoVC: MembershipInfoVC!)
}

class MembershipInfoVC: GenericVC {

    private(set) var delegate: MembershipInfoVCDelegate!
    private(set) var viewModel: MembershipInfoVM!
    
    
    // MARK: -
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var membershipLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var userNameValueLabel: UILabel!
    @IBOutlet weak var membershipValueLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!
    
    @IBOutlet weak var chooseMembershipButton: UIButton!
    @IBOutlet weak var backButtonButton: UIButton!
    
    @IBOutlet weak var statusView: UIView!
    
    
    // MARK: - Init methods 
    
    
    init(delegate: MembershipInfoVCDelegate!, viewModel: MembershipInfoVM!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateStandardLabels()
        
        self.updateView(viewModel: self.viewModel)
    }
    
    
    // MARK: - Open tools
    
    
    open func updateView(viewModel: MembershipInfoVM!) {
        self.viewModel = viewModel
        
        self.updateValueFields()
    }
    
    
    // MARK: - Private tools
    
    
    private func updateStandardLabels() {
        
        self.backButtonButton.updateButtonForAppleTV()
        self.chooseMembershipButton.updateButtonForAppleTV()
        
        self.statusView.layer.cornerRadius = 6.0
        
        self.titleLabel.text = "MEMBERSHIP_INFORMATION".localized
        
        self.userNameLabel.text = "USERNAME".localized
        self.membershipLabel.text = "MEMBERSHIP".localized
        self.statusLabel.text = "STATUS".localized
        
        self.chooseMembershipButton.setTitle("SELECT_ANOTHER_LIBRARY".localized, for: .normal)
        self.backButtonButton.setTitle("BACK".localized, for: .normal)
    }
    
    
    private func updateValueFields() {
        self.userNameValueLabel.text = self.viewModel.userNameValue
        self.membershipValueLabel.text = self.viewModel.membershipValue
        self.statusValueLabel.text = self.viewModel.statusValue.capitalizingFirstLetter()
        
        self.statusView.backgroundColor = self.viewModel.statusColorValue
    }
    
    
    // MARK: - Actions 
    
    
    @IBAction func chooseMembershipButtonAction(_ sender: Any) {
        self.delegate.didPressSelectMembershipButton(membershipInfoVC: self)
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.delegate.didPressBackButton(membershipInfoVC: self)
    }
}
