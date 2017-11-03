//
//  ItemTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/10/17.
//
//

import UIKit
import SDWebImage

class ItemTableCell: GenericCell {

    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: ReadMoreLabel!
    @IBOutlet weak var showMoreButton: UIButton!
        
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        if highlighted == true {
            self.backgroundColor = UIColor.mainBackgroundDarkGreyColor()
            self.contentView.backgroundColor = UIColor.mainBackgroundDarkGreyColor()
        } else {
            self.backgroundColor = UIColor.clear
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    
    override func didSelectCell() {
        let cm: ListItemCellModel = self.cellModel as! ListItemCellModel
        cm.didSelect()
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: ListItemCellModel = self.cellModel as! ListItemCellModel
        
        self.titleLabel.text = cm.item.title
        self.titleLabel.sizeToFit()
        
        self.descriptionTextLabel.text = cm.shortDescriptionText
        self.descriptionTextLabel.adjustsFontSizeToFitWidth = true
        
        self.thumbView.sd_setImage(with: URL.init(string: (cm.item.images?.smallThumbURL())!)) { (image:UIImage?, error: Error?, imageType:SDImageCacheType, url: URL?) in
            self.thumbView.image = image
        }
    }
    
    
    private func updateDescriptionLabel() {
        
        let cm: ListItemCellModel = self.cellModel as! ListItemCellModel
        
        if cm.item.descriptionText.characters.count > 0 {
            
            self.showMoreButton.isHidden = false
            
            cm.showMoreButtonHeight = self.showMoreButton.bounds.height
            cm.titleLabelHeight = self.titleLabel.bounds.height
            cm.thumbViewHeight = self.thumbView.bounds.height
            
            self.descriptionTextLabel.numberOfLines = cm.numberOfLines()
            self.descriptionTextLabel.lineBreakMode = cm.lineBreakMode()
            
            self.descriptionTextLabel.text = cm.descriptionText(width: self.descriptionTextLabel.bounds.width)
            
        } else {
            self.showMoreButton.isHidden = true
            self.descriptionTextLabel.text = ""
        }
    }
    
    
    private func updateType(with subtype: String!) {
        self.typeView.isHidden = true
    }
    
    
    @IBAction func showMoreButtonAction(_ sender: Any) {
        
        let cm: ListItemCellModel = self.cellModel as! ListItemCellModel
        cm.changeSize(cellWidth: self.descriptionTextLabel.bounds.width)
    }
    
}
