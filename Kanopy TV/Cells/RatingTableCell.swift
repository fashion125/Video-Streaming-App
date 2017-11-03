//
//  RatingTableCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/26/17.
//
//

import UIKit

class RatingTableCell: GenericCell {

    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    @IBOutlet weak var closeCaptionIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        self.closeCaptionIcon.isHidden = !self.ratingCM.isHaveCaption
        self.updateRating(value: self.ratingCM.ratingCount)
    }
    
    
    var ratingCM: RatingCellModel {
        get {
            return self.cellModel as! RatingCellModel
        }
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
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
    }
}
