//
//  ActivationVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 4/7/17.
//
//

import UIKit
import WebKit
import MBProgressHUD

protocol MembershipsVCDelegate {
    /** This method is call when user tap on Add your library or Connect membership button */
    func autologinTo(destination: String, hashtag: String)
}


protocol ActivationVCDelegate: MembershipsVCDelegate {
    /** This method is call when user tap on Add your library or Connect membership button */
    func showSearchInstitution()
    
    /** This method is call when user tap to resend email button */
    func resendEmail()
    
    /** This method is call when user tap to sign out button */
    func signOut()
    
    /** This method is call when user tap to exit button */
    func exit()
    
    /** This method is call when user tap to back button */
    func didPressToBackButton()
    
    /** This method is call when a first popup is opened */
    func blockRefreshing()
    
    /** This method is call when the first opened popup is closed */
    func unblockRefreshing()
}


class ActivationVC: GenericTVC, WKUIDelegate, WKNavigationDelegate, WKWebViewVCDelegate {

    private(set) var webView: WKWebView!
    private(set) var webViewTag: Int! = 42
    
    var delegate: ActivationVCDelegate?
    private(set) var viewModel: ActivationVM!
    private(set) var statusModel: StatusActivationModel!
    
    var loadingNotification: MBProgressHUD? = nil
    
    
    // MARK: - Init method 
    
    
    init(delegate: ActivationVCDelegate?) {
        
        super.init()
        
        self.delegate = delegate
        self.addChromecastIfPossible = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.isScrollEnabled = false
        
        self.showLogo()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.webView == nil) {
            self.updateNavigationBar()
            self.showBackButton()
            
            let frame = CGRect.init(x: 0,
                                    y: self.view.bounds.origin.y,
                                    width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.height - self.kbHeight - (self.navigationController?.navigationBar.frame.size.height)! - UIApplication.shared.statusBarFrame.size.height)
            
            let webConfiguration = WKWebViewConfiguration()
            
            // Put inAppBrowser in the user agent so the site is shown whitout header and footer
            webConfiguration.applicationNameForUserAgent = "inAppBrowser"
            
            var jscript = ""
            
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                // Display the mobile version on iPad and disable zooming
                jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=" + (UIScreen.main.bounds.size.width/1.5).description + ", user-scalable=no'); meta.setAttribute('shrink-to-fit', 'YES'); document.getElementsByTagName('head')[0].appendChild(meta);"
            } else {
                // Disable zooming for other devices
                jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'); meta.setAttribute('shrink-to-fit', 'YES'); document.getElementsByTagName('head')[0].appendChild(meta);"
            }
            
            let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            let wkUController = WKUserContentController()
            wkUController.addUserScript(userScript)
            
            webConfiguration.userContentController = wkUController
            
            
            /*
             Data Store in non persistent mode to not write files on the filesystem
             We are unsure as of why this is required but this is necessary to make work on device
             This is to prevent authentication issues related to cookies
             The behaviour was different between the simulator and on device leading to weird access denied errors on the backend
             See issue KI-395
             */
            webConfiguration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
            
            self.webView = WKWebView.init(frame: frame, configuration: webConfiguration)
            self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.webView.tag = webViewTag
            self.webView.uiDelegate = self
            self.webView.navigationDelegate = self
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    func update(with viewModel: ActivationVM!) {
        self.viewModel = viewModel
        self.dataSource = GenericTableDatasource(sections: self.viewModel.sections)
        self.registerCellTypes()
        self.tableView.reloadData()
    }
    
    
    override func updateTableViewFrame() {
        self.tableView.frame = CGRect(x: 0,
                                      y: self.view.bounds.origin.y + self.topMargin ,
                                      width: UIScreen.main.bounds.width,
                                      height: UIScreen.main.bounds.height - self.kbHeight - self.topMargin)
    }

    
    
    /** Method update navigation bar */
    func updateNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        /// Change backgorund for navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        /// Change bar tint and tint color
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarBackgroundColor()
        self.navigationController?.navigationBar.tintColor = UIColor.navBarTintColor()
        
        /// is transculent is false
        self.navigationController?.navigationBar.isTranslucent = false
        
        //navigationItem.leftBarButtonItem = self.customBackButton()
        navigationItem.hidesBackButton = true;
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
        /*
         AFO
         Little trick used here to pop the view controller if the current url is the same than the previous one but with a hashtag
         @todo : improve this here or remove the pushed url when opening an url with an hashtag on the server side
         */
        
        if self.webView == nil {
            self.delegate?.didPressToBackButton()
            return
        }
        
        let previousUrl = self.webView.url?.relativeString
        
        if (self.webView.superview != nil && self.webView.canGoBack) {
            // Go back on the previous website page
            self.webView.goBack()
            
            let currentUrl = self.webView.url?.relativeString
            let substringCurrentUrl = currentUrl?.substring(to: (previousUrl?.characters.count)!)
            if (substringCurrentUrl != nil && previousUrl == substringCurrentUrl && currentUrl?.index(string: "#", startPos: currentUrl?.startIndex, options: .literal) != nil) {
                // Go back in the app
                self.delegate?.didPressToBackButton()
            }
        } else {
            // Go back in the app
            self.delegate?.didPressToBackButton()
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if (self.tableView.viewWithTag(self.webViewTag) == nil) {
            self.loadingNotification?.hide(animated: true)
            self.tableView.addSubview(self.webView)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        self.delegate?.blockRefreshing()
        
        let webview = WKWebView.init(frame: self.view.bounds, configuration: configuration)
        webview.tag = webViewTag+1
        
        let vc = WKWebViewVC.init(delegate: self, webView: webview)
        vc.updateUrl(url: (navigationAction.request.url?.absoluteString)!)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        return webview
    }
    
    
    func openWebViewWithUrl(url: String!) {
        self.webView.load(URLRequest(url: URL(string: url)!))
    }
    
    
    func removeWebView() {
        self.webView.removeFromSuperview()
    }
    
    
    // MARK: - WKWebViewVCDelegate method
    
    
    /** This method is called when user tap to back button */
    func didPressBackButton(wkWebViewVC: WKWebViewVC!) {
        self.navigationController?.popViewControllerWithHandler {
            self.delegate?.unblockRefreshing()
        }
    }
    
    
    /** This method is called when the webview has totally disappeared */
    func webviewDidDisappear(wkWebViewVC: WKWebViewVC!) {
        self.delegate?.unblockRefreshing()
    }
}
