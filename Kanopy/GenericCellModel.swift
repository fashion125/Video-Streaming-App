//
//  GenericCell.swift
//  optum-soft-install-app
//
//  Created by Ilya Katrenko on 9/26/16.
//  Copyright © 2016 Design and Test Lab. All rights reserved.
//

import UIKit

class GenericCellModel: NSObject {
    
    private(set) var cellID: String! = ""
    private(set) var height: CGFloat! = UITableViewAutomaticDimension
    private(set) var width: CGFloat! = 0.0
    private(set) var isHideSeparator: Bool = true
    open var command: GeneralCommand?
    open var isSelected: Bool! = false
    open var isCanFocus: Bool! = true
    
    /// For collection view cell
    
    private(set) var lineSpacing: CGFloat! = 0.0
    private(set) var interitemSpacing: CGFloat! = 0.0
    
    private(set) var contentOffset: CGPoint! = CGPoint.init(x: 0, y: 0)
    
    init(_ cellID: String!, height: CGFloat!) {
        super.init()
        
        self.cellID = cellID
        self.height = height
    }
    
    
    init(_ cellID: String!, height: CGFloat!, isHideSeparator: Bool!) {
        
        super.init()
        
        self.cellID = cellID
        self.height = height
        self.isHideSeparator = isHideSeparator
    }

    
    init(_ cellID: String!, width: CGFloat!, height: CGFloat!) {
        super.init()
        
        self.cellID = cellID
        self.width = width
        self.height = height
    }
    
    init(_ cellID: String!, width: CGFloat!, height: CGFloat!, lineSpacing: CGFloat!, interitemSpacing: CGFloat!) {
        super.init()
        
        self.cellID = cellID
        self.width = width
        self.height = height
        self.lineSpacing = lineSpacing
        self.interitemSpacing = interitemSpacing
    }
    
    
    open func didSelect() {
        
        if self.command != nil {
            self.command?.execute()
        }
    }
    
    
    func fireAction() {
        
    }

    
    func updateHeight(_ newHeight: CGFloat) {
        self.height = newHeight
    }
    
    func updateContentOffset(_ newContentOffset: CGPoint!) {
        self.contentOffset = newContentOffset
    }
}
