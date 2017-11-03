//
//  PlaylistMenuTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 15.05.17.
//
//

import UIKit

class PlaylistMenuTableCell: GenericCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: -
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.titleLabel.text = self.pmCM.titleText
        self.iconView.image = UIImage.init(named: self.pmCM.iconName)
    }
    
    
    var pmCM: PlaylistMenuCellModel {
        get {
            return self.cellModel as! PlaylistMenuCellModel
        }
    }
}
