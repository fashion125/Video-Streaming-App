//
//  ItemCollectionCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 2/8/17.
//
//

import UIKit
import SDWebImage

class ItemCollectionCell: GenericCollectionCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.font = SizeStrategy.itemTitleFont()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    

    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm: ItemCellModel = self.cellModel as! ItemCellModel
        
        self.titleLabel.numberOfLines = 2
        self.titleLabel.text = cm.item.title
        self.titleLabel.addTextSpacing()
        
        
        self.thumbImageView.sd_setImage(with: URL.init(string: (cm.item.images?.smallThumbURL())!)) { (image:UIImage?, error: Error?, imageType: SDImageCacheType, url: URL?) in
                self.thumbImageView.image = image
        }
        
        self.updateType(with: cm.item.subtype)
    }
    
    private func updateType(with subtype: String!) {
        self.typeView.isHidden = true
    }
}
