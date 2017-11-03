//
//  ThirdPageVC.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 15/06/2017.
//
//

import UIKit


/// Protocol for home view controller
protocol ThirdPageVCDelegate: class {
    
    func didClickSignUp()
    
    func didClickLogIn()
    
    func didClickBrowseAsGuest()
}


class ThirdPageVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alreadyAMemberLabel: UILabel!
    @IBOutlet weak var browseAsGuestLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    var delegate: ThirdPageVCDelegate!
    var firstLayout: Bool! = true
    
    
    // MARK: - Init methods
    
    
    init(delegate: ThirdPageVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func rotated() {
        if (backgroundImage != nil) {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                backgroundImage.image = UIImage.init(named: "start_screen_3_ipad_landscape")
            default:
                backgroundImage.image = UIImage.init(named: "start_screen_3_ipad_portait")
            }
        }
    }
    
    
    // MARK: - Life cyrcle
    
    
    override func viewWillAppear(_ animated: Bool) {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            self.rotated()
            NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidLayoutSubviews() {
        if (self.firstLayout) {
            let titleAttributedText = titleLabel.attributedText?.mutableCopy() as! NSMutableAttributedString
            titleAttributedText.mutableString.setString("FIRST_START_TITLE_THIRD_PAGE".localized)
            titleLabel.attributedText = titleAttributedText
            
            let alreadyMemberAttributedText = alreadyAMemberLabel.attributedText?.mutableCopy() as! NSMutableAttributedString
            alreadyMemberAttributedText.mutableString.setString("FIRST_START_ALREADY_A_MEMBER_THIRD_PAGE".localized + " " + "SIGN_IN".localized)
            alreadyMemberAttributedText.setColorForText("SIGN_IN".localized, with: UIColor.mainOrangeColor())
            alreadyAMemberLabel.attributedText = alreadyMemberAttributedText
            
            let browseGuestAttributedText = browseAsGuestLabel.attributedText?.mutableCopy() as! NSMutableAttributedString
            browseGuestAttributedText.mutableString.setString("FIRST_START_BROWSE_AS_GUEST_THIRD_PAGE".localized)
            browseAsGuestLabel.attributedText = browseGuestAttributedText
            
            signUpButton.setTitle("SIGN_UP".localized, for: .normal)
            
            let tapAlreadyAMember = UITapGestureRecognizer(target: self, action: #selector(self.logInButtonAction))
            alreadyAMemberLabel.isUserInteractionEnabled = true
            alreadyAMemberLabel.addGestureRecognizer(tapAlreadyAMember)
            
            let tapBrowseAsGuest = UITapGestureRecognizer(target: self, action: #selector(self.browseAsGuestButtonAction))
            browseAsGuestLabel.isUserInteractionEnabled = true
            browseAsGuestLabel.addGestureRecognizer(tapBrowseAsGuest)
            
            self.firstLayout = false;
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
    }

    
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        self.delegate.didClickSignUp()
    }
    
    
    func logInButtonAction() {
        self.delegate.didClickLogIn()
    }
    
    
    func browseAsGuestButtonAction() {
        self.delegate.didClickBrowseAsGuest()
    }
}
