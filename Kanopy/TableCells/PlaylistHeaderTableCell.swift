//
//  PlaylistHeaderTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/20/17.
//
//

import UIKit
import SDWebImage
import GoogleCast

class PlaylistHeaderTableCell: GenericCell {

    @IBOutlet weak var thumbView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.separatorHeight.constant = 0.5
    }

    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: HeaderCellModel = self.cellModel as! HeaderCellModel
        
        self.nameLabel.text = cm.name
        self.timeLabel.text = cm.timeValue
        self.partLabel.text = cm.partTitle
        self.subtitleLabel.text = cm.subtitle
        self.itemLabel.text = cm.itemTitle
        
        self.thumbImageView.sd_setImage(with: URL.init(string: cm.thumbURL)) { (image: UIImage?, error: Error?, imageType: SDImageCacheType, url: URL?) in
            self.thumbImageView.image = image
        }
        
        self.updateRating(value: cm.ratingCount)
        self.itemLabel.addShadow()
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
