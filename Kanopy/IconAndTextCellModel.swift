//
//  IconAndTextCellModel.swift
//  Kanopy
//
//  Created by Abdelaziz Founas on 22/06/2017.
//
//

import Foundation

import UIKit

class IconAndTextCellModel: GenericCellModel {
    
    private(set) var icon: UIImage?
    private(set) var title: String! = ""
    private(set) var descriptionText: String! = ""
    
    
    // MARK: - Init
    
    
    init(title: String!, descriptionText: String!, icon: UIImage!, height: CGFloat!) {
        super.init(TableCellIDs.iconAndTextTableCell, height: height)
        
        self.icon = icon
        self.title = title
        self.descriptionText = descriptionText
    }
}
