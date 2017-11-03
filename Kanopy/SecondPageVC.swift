//
//  SecondPageVC.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 15/06/2017.
//
//

import UIKit

class SecondPageVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    var firstLayout: Bool! = true
    
    
    // MARK: - Init methods
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func rotated() {
        if (backgroundImage != nil) {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                backgroundImage.image = UIImage.init(named: "start_screen_2_ipad_landscape")
            default:
                backgroundImage.image = UIImage.init(named: "start_screen_2_ipad_portait")
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
            titleAttributedText.mutableString.setString("FIRST_START_TITLE_SECOND_PAGE".localized)
            titleLabel.attributedText = titleAttributedText
            
            self.firstLayout = false;
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
    }
}
