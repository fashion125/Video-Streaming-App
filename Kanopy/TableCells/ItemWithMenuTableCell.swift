//
//  ItemWithMenuTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 14.05.17.
//
//

import UIKit
import SDWebImage

class ItemWithMenuTableCell: GenericCell {

    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: ReadMoreLabel!
    @IBOutlet weak var menuButton: UIButton!
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.itemCM.item.title
        self.titleLabel.sizeToFit()
        
        self.descriptionTextLabel.text = self.itemCM.item.descriptionText
        self.descriptionTextLabel.adjustsFontSizeToFitWidth = true
        
        self.thumbView.sd_setImage(with: URL.init(string: (self.itemCM.item.images?.smallThumbURL())!)) { (image:UIImage?, error: Error?, imageType:SDImageCacheType, url: URL?) in
            self.thumbView.image = image
        }
    }
    
    
    var itemCM: MyPlaylistItemCellModel {
        get {
            return self.cellModel as! MyPlaylistItemCellModel
        }
    }
    
    // MARK: - Actions
    
    
    @IBAction func menuButtonAction(_ sender: Any) {
        self.itemCM.didPressToMenuButton()
    }
}
