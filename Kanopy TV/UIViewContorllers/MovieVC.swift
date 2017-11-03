//
//  MovieVC.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/24/17.
//
//

import UIKit

class MovieVC: GenericContentVC, GenericCollectionDataSourceDelegate {

    @IBOutlet weak var bgThumbImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieSubtitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    @IBOutlet weak var closeCaptionIcon: UIImageView!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    
    @IBOutlet weak var loadViewContainer: UIView!
    @IBOutlet weak var contentLoadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentLoadTitle: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addToWatchlistButton: UIButton!
    @IBOutlet weak var showMoreButton: UIButton!
    
    @IBOutlet weak var suggestedTitle: UILabel!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBOutlet weak var suggestedLoadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var buttonsCollectionView: UICollectionView!
    
    @IBOutlet weak var publicCreditsView: UIView!
    @IBOutlet weak var publicCreditsTitleLabel: UILabel!
    @IBOutlet weak var publicCreditsValueLabel: UILabel!
    
    private(set) var collectionDataSource: GenericCollectionDataSource!
    private(set) var buttonsCollectionDataSource: GenericCollectionDataSource!
    
    
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
        
        self.movieTitleLabel.accessibilityIdentifier = "Title_text"
        self.buttonsCollectionView.remembersLastFocusedIndexPath = true
        self.showLoadIndicator()
    }
    
    
    override func updateViewModel(_ viewModel: ContentVM!) {
        
        super.updateViewModel(viewModel)
        
        if  self.viewModel.itemModel != nil {
            self.hideLoadIndicator()
            self.updateContent()
            self.animatedShowContent()
        }
    }
    
    
    override func backgroundThumbImageView() -> UIImageView? {
        return self.bgThumbImageView
    }
    
    
    override func backgroundView() -> UIView? {
        return self.bgView
    }
    
    
    override func contentContainerView() -> UIView? {
        return self.contentView
    }
    
    
    override func showLoadIndicator() {
        self.contentLoadTitle.text = self.titleValue
        self.loadViewContainer.isHidden = false
        self.loadIndicator?.startAnimating()
    }
    
    
    override func hideLoadIndicator() {
        self.loadViewContainer.isHidden = true
    }
    
    
    // MARK: - Tools 
    
    
    private func animatedShowContent() {
        
        if  self.contentView.isHidden == false {
            return
        }
        
        self.contentView.layer.opacity = 0.0
        self.contentView.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.contentView.layer.opacity = 1.0
        }
    }
    
    
    private func updateContent() {
        
        self.movieTitleLabel.text = self.viewModel.itemModel?.title
        self.movieSubtitleLabel.text = self.viewModel.itemModel?.tagline
        self.yearLabel.text = self.viewModel.itemModel?.yearOfProduction
        
        self.closeCaptionIcon.isHidden = !(self.viewModel.itemModel?.hasCaptions)!
        
        self.movieImageView.sd_setImage(with: URL.init(string: (self.viewModel.itemModel?.images?.mediumThumbURL())!)) { (image: UIImage?, error: Error?, cache: SDImageCacheType, url: URL?) in
            self.movieImageView.image = image
        }
        
        self.descriptionTextLabel.text = self.viewModel.itemModel?.descriptionText
        self.updateRating(value: (self.viewModel.itemModel?.rating.average)!)
        
//        self.updateButtonDesign(button: self.addToWatchlistButton)
//        self.updateButtonDesign(button: self.playButton)
//        self.updateButtonDesign(button: self.showMoreButton)
        
        self.updateSuggestedVideos()
        self.reloadButtonCollectionView()
    }
    
    
    /** Method return all stars in array */
    private func stars() -> [UIImageView] {
        return [self.firstStar, self.secondStar, self.thirdStar, self.fourthStar, self.fifthStar]
    }
    
    
    private func updateRating(value: Int) {
        
        for (index, element) in self.stars().enumerated() {
            
            if index > Int.init(value - 1) {
                element.image = #imageLiteral(resourceName: "non_select_star_icon")
            } else {
                element.image = #imageLiteral(resourceName: "select_star_icon")
            }
        }
    }
    
    
    private func updateSuggestedVideos() {
        
        if self.viewModel.suggestedVideos != nil {
            self.reloadCollectionView()
            self.suggestedLoadIndicator.isHidden = true
            self.suggestedCollectionView.isHidden = false
            self.suggestedTitle.isHidden = false
        } else {
            self.suggestedLoadIndicator.isHidden = false
            self.suggestedCollectionView.isHidden = true
            self.suggestedTitle.isHidden = true
        }
    }
    
    
    private func reloadCollectionView() {
        
        self.collectionDataSource = GenericCollectionDataSource.init(sections: self.viewModel.sections)
        self.suggestedCollectionView.dataSource = self.collectionDataSource
        self.suggestedCollectionView.delegate = self.collectionDataSource
        self.collectionDataSource.delegate = self
        
        for sm in self.collectionDataSource.sectionModels {
            for cm in sm.cellModels {
                self.suggestedCollectionView.register(UINib.init(nibName: cm.cellID, bundle: nil), forCellWithReuseIdentifier: cm.cellID)
            }
        }
        
        self.suggestedCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 50.0, bottom: 0, right: 50.0)
        
        self.suggestedCollectionView.reloadData()
    }
    
    
    private func reloadButtonCollectionView() {
        
        self.buttonsCollectionDataSource = GenericCollectionDataSource.init(sections: self.viewModel.buttonsSections)
        self.buttonsCollectionView.dataSource = self.buttonsCollectionDataSource
        self.buttonsCollectionView.delegate = self.buttonsCollectionDataSource
        self.buttonsCollectionDataSource.delegate = self
        
        for sm in self.buttonsCollectionDataSource.sectionModels {
            for cm in sm.cellModels {
                self.buttonsCollectionView.register(UINib.init(nibName: cm.cellID, bundle: nil), forCellWithReuseIdentifier: cm.cellID)
            }
        }
        
        self.buttonsCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0.0, bottom: 0, right: 0.0)
        
        self.buttonsCollectionView.reloadData()
    }
    
    
    // MARK: -
    
    
    func didPressToCell(indexPath: IndexPath!, dataSource: GenericCollectionDataSource!) {
        
        if dataSource == self.buttonsCollectionDataSource {
            let sm = self.viewModel.buttonsSections[indexPath.section]
            let cm = sm.cellModels[indexPath.row]
            
            cm.didSelect()
        } else {
            let sm = self.viewModel.sections[indexPath.section]
            let cm = sm.cellModels[indexPath.row]
            
            cm.didSelect()
        }
    }
    
    
    func collectionScrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
    // MARK: -
    
    
    override func publicCreditsLeftView() -> UIView? {
        return self.publicCreditsView
    }
    
    
    override func countLabel() -> UILabel? {
        return self.publicCreditsValueLabel
    }
    
    
    override func titleLabel() -> UILabel? {
        return self.publicCreditsTitleLabel
    }
}
