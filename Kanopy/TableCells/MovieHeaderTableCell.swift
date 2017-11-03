//
//  MovieHeaderTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/16/17.
//
//

import UIKit
import SDWebImage
import GoogleCast

class MovieHeaderTableCell: GenericCell {

    @IBOutlet weak var ccImageView: UIImageView!
    @IBOutlet weak var thumbView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    
    // MARK: - 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorHeight.constant = 0.5
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: HeaderCellModel = self.cellModel as! HeaderCellModel
        
        self.nameLabel.text = cm.name
        self.yearLabel.text = cm.year
        self.timeLabel.text = cm.timeValue
        
        self.thumbImageView.sd_setImage(with: URL.init(string: cm.thumbURL)) { (image: UIImage?, error: Error?, imageType: SDImageCacheType, url: URL?) in
            self.thumbImageView.image = image
        }
        
        self.updateRating(value: cm.ratingCount)
        
        self.ccImageView.isHidden = !cm.isHasCaption
    }
    
    
    // MARK: -
    
    
    /** Method return all stars in array */
    private func stars() -> [UIImageView] {
        return [self.firstStar, self.secondStar, self.thirdStar, self.fourthStar, self.fifthStar]
    }
    
    
    private func updateRating(value: Int) {
        
        for (index, element) in self.stars().enumerated() {
            
            if index > Int.init(value - 1) {
                element.image = #imageLiteral(resourceName: "star_ns_icon")
            } else {
                element.image = #imageLiteral(resourceName: "star_icon")
            }
        }
    }
    
    
    @IBAction func playButtonAction(_ sender: Any) {
        let cm: HeaderCellModel = self.cellModel as! HeaderCellModel
        cm.didPressToPlayButton()
    }
}
