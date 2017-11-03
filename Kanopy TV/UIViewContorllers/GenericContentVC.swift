//
//  GenericContentVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/24/17.
//
//

import UIKit

protocol GenericContentVCDelegate {
    
    /** Method is call when user tap to item */
    func didPressToItem(itemModel: ItemModel!)

    func didPressToPlayButton()
    
    func didPressToWatchlistButton()
    
    func didPressShowMoreButton() 
}


class GenericContentVC: PublicCreditsLeftVC {

    var viewModel: ContentVM!
    
    private(set) var bgURL: URL!
    private(set) var titleValue: String!
    private(set) var delegate: GenericContentVCDelegate!
    
    
    // MARK: - Init methods 
    
    
    init(delegate: GenericContentVCDelegate!, url: URL!, title: String!) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        self.bgURL = url
        self.titleValue = title
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentContainerView()?.isHidden = true
        self.backgroundView()?.addBlur(.dark)
        self.updateBackground()
    }
    
    
    // MARK: - Update interface methods 
    
    
    open func updateViewModel(_ viewModel: ContentVM!) {
        self.viewModel = viewModel
    }
    
    
    private func updateBackground() {
        self.backgroundThumbImageView()?.sd_setImage(with: self.bgURL,
        completed: { (image: UIImage?, error: Error?, cache: SDImageCacheType, url: URL?) in
            self.backgroundThumbImageView()?.image = image
        })
    }
    
    
    // MARK: - Tools 
    
    
    open func backgroundThumbImageView() -> UIImageView? {
        assertionFailure("Must be implemented in subclass")
        
        return nil
    }
    
    
    open func backgroundView() -> UIView? {
        assertionFailure("Must be implemented in subclass")
        
        return nil
    }
    
    
    open func contentContainerView() -> UIView? {
        assertionFailure("Must be implemented in subclass")
        
        return nil
    }
    
    
    open func updateButtonDesign(button: UIButton!) {
        
        button.setBackgroundImage(UIImage.init(color: UIColor.mainOrangeColor()), for: .focused)
        button.setBackgroundImage(UIImage.init(color: UIColor.init(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0)), for: .normal)
        button.layer.cornerRadius = 8.0
    }
}
