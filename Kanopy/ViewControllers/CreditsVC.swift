//
//  CreditsVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 03.05.17.
//
//

import UIKit

class CreditsVC: GenericSearchVC, AuthServiceDelegate {

    private(set) var creditsLeftView: UIView!
    private(set) var countLabel: UILabel!
    private(set) var isShowCreditsLeftView: Bool! = false
    private(set) var timer: Timer?
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.updateCreditsLeft()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateCreditsLeft()
        
        AuthService.sharedInstance.addObserver(observer: self)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AuthService.sharedInstance.removeObserver(observer: self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    // MARK: -
    
    
    func updateCreditsLeft() {
        
        if AuthService.sharedInstance.isHaveCredits() {
            self.addCreditsLeft()
        } else {
            self.removeCreditsLeft()
        }
        
        self.menuNavigationController()?.bringMenuToFront()
        
        if self.isOpenSearch {
            self.navigationController?.navigationBar.bringSubview(toFront: self.searchBGView!)
        }
    }
    
    
    func addCreditsLeft() {
        self.addCreditsLeftView()
        self.addCreditsBarButtonItem()
        self.view.bringSubview(toFront: self.creditsLeftView)
    }
    
    
    func removeCreditsLeft() {
        self.removeCreditsLeftView()
        self.removeCreditsBarButtonItem()
    }
    
    
    // MARK: -
    
    
    func addCreditsLeftView() {
        
        if self.creditsLeftView == nil {
            self.creditsLeftView = self.createCreditsLeftView()
            self.isShowCreditsLeftView = false
            self.view.addSubview(self.creditsLeftView)
            self.view.bringSubview(toFront: self.creditsLeftView)
        }
    }
    
    
    func addCreditsBarButtonItem() {
        
        self.navigationItem.leftBarButtonItems = [ self.navigationItem.leftBarButtonItem!,
                                                    self.createCreditBarButtonItem()]
    }
    
    
    func removeCreditsLeftView() {
        if self.creditsLeftView != nil {
            self.creditsLeftView.removeFromSuperview()
        }
    }
    
    
    func removeCreditsBarButtonItem() {
        let item = self.navigationItem.rightBarButtonItems?.first
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.rightBarButtonItem = item
    }
    
    
    // MARK: - Tools 
    
    
    func createCreditsLeftView() -> UIView {
        
        let rect = CGRect.init(x: 0, y: -28.0, width: self.view.bounds.width, height: 28.0)
        let view = UIView.init(frame: rect)
        view.backgroundColor = UIColor.init(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
        view.addSubview(self.createCreaditsLeftLabel())
        
        return view
    }
    
    
    func createCreaditsLeftLabel() -> UILabel {
        
        let labelRect = CGRect.init(x: 15.0, y: 0, width: self.view.bounds.width - 30.0, height: 28.0)
        let label = UILabel.init(frame: labelRect)
        label.textAlignment = .left
        label.font = UIFont.init(name: "AvenirNextLTPro-Medium", size: 14.0)
        label.textColor = UIColor.init(red: 96.0/255.0, green: 96.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        label.text = "CREADITS_LEFT_TEXT".localized
        
        return label
    }
    
    
    func createCreditBarButtonItem() -> UIBarButtonItem {
        
        let rect = CGRect.init(x: 0, y: 0, width: 24.0, height: 24.0)
        let view = UIView.init(frame: rect)
        
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = UIColor.mainOrangeColor().cgColor
        view.layer.cornerRadius = 4.0
        view.layer.borderWidth = 1.25
        
        let labelRect = CGRect.init(x: 0, y: 2, width: 24.0, height: 24.0)
        self.countLabel = UILabel.init(frame: labelRect)
        self.countLabel.font = UIFont.init(name: "AvenirNextLTPro-Regular", size: 14.0)
        self.countLabel.textColor = UIColor.white
        self.countLabel.textAlignment = .center
        self.countLabel.text = String(AuthService.sharedInstance.currentCreditsValue())
        
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24.0, height: 24.0))
        button.addTarget(self, action: #selector(CreditsVC.publicLibraryCreditsAction), for: .touchUpInside)
        
        view.addSubview(self.countLabel)
        view.addSubview(button)
        
        return UIBarButtonItem.init(customView: view)
    }
    
    
    // MARK: - Timer methods 
    
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(CreditsVC.timerIsFinish), userInfo: nil, repeats: false);
    }
    
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    func timerIsFinish() {
        self.hideCreditsLeftView()
    }
    
    
    // MARK: - Animation methods 
    
    
    func showCreditsLeftView() {
        UIView.animate(withDuration: 0.2, animations: {
            let rect = CGRect.init(x: 0, y: 0.0, width: self.view.bounds.width, height: 28.0)
            self.creditsLeftView.frame = rect
        }, completion: { (isTure: Bool) in
            self.isShowCreditsLeftView = true
            self.startTimer()
        })
    }
    
    
    func hideCreditsLeftView() {
        UIView.animate(withDuration: 0.2, animations: {
            let rect = CGRect.init(x: 0, y: -28.0, width: self.view.bounds.width, height: 28.0)
            self.creditsLeftView.frame = rect
        }, completion: { (isTure: Bool) in
            self.isShowCreditsLeftView = false
            self.stopTimer()
        })
    }
    
    
    // MARK: - Actions
    
    
    func publicLibraryCreditsAction() {
        
        if self.isShowCreditsLeftView {
            self.hideCreditsLeftView()
        } else {
            self.showCreditsLeftView()
        }
    }
    
    
    // MARK: - AuthServiceDelegate methods 
    
    
    func notifyAboutChangeCreditLeft() {
        self.updateCreditsLeft()
    }
    
}
