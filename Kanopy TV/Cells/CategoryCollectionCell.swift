//
//  CategoryCollectionCell.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/19/17.
//
//

import UIKit

class CategoryCollectionCell: GenericCollectionCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backgroundCustomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundCustomView.layer.cornerRadius = 4.0
        self.backgroundCustomView.backgroundColor = UIColor.init(red: 58/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1.0)
        self.backgroundCustomView.frame = CGRect.init(x: 14, y: 10, width: 240 - 28.0, height: 100 - 20)
    }
    
    
    override func configure(cellModel: GenericCellModel) {
        super.configure(cellModel: cellModel)
        
        let cm = self.cellModel as! CategoryCollectionCellModel
        self.title.text = cm.category.name
        self.updateFocus(animate: false)
    }
    
    
    var ctCM : CategoryCollectionCellModel {
        get {
            return self.cellModel as! CategoryCollectionCellModel
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        self.updateFocus(animate: true)
    }
    
    
    private func updateFocus(animate: Bool!) {
        if self.isFocused {
            self.focusedAnimation(animate: animate)
        } else {
            self.notFocusedAnimation(animate: animate)
        }
    }
    
    private func focusedAnimation(animate: Bool!) {
        
        if animate == false {
            self.backgroundCustomView.backgroundColor = UIColor.mainOrangeColor()
            self.backgroundCustomView.frame = CGRect.init(x: 5, y: 5, width: 240 - 10.0, height: 100 - 10)
        }
        
        UIView.animate(withDuration: 0.2) { 
            self.backgroundCustomView.backgroundColor = UIColor.mainOrangeColor()
            self.backgroundCustomView.frame = CGRect.init(x: 5, y: 5, width: 240 - 10.0, height: 100 - 10)
        }
    }
    
    
    private func notFocusedAnimation(animate: Bool!) {
        
        if animate == false {
            if self.ctCM.isSelected {
                self.backgroundCustomView.backgroundColor = UIColor.init(red: 207/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1.0)
            } else {
                self.backgroundCustomView.backgroundColor = UIColor.init(red: 58/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1.0)
            }
            
            self.backgroundCustomView.frame = CGRect.init(x: 14, y: 10, width: 240 - 28.0, height: 100 - 20)
        }
        
        
        UIView.animate(withDuration: 0.2) {
            
            if self.ctCM.isSelected {
                self.backgroundCustomView.backgroundColor = UIColor.init(red: 207/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1.0)
            } else {
                self.backgroundCustomView.backgroundColor = UIColor.init(red: 58/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1.0)
            }
            
            self.backgroundCustomView.frame = CGRect.init(x: 14, y: 10, width: 240 - 28.0, height: 100 - 20)
        }
    }
}
