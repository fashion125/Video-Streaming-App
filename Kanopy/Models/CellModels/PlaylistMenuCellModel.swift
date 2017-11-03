//
//  PlaylistMenuCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 14.05.17.
//
//

import UIKit

class PlaylistMenuCellModel: GenericCellModel {
    
    private(set) var titleText: String! = ""
    private(set) var iconName: String! = ""
    
    // MARK: - Init method

    
    init(titleText: String!, iconName: String!, command: GeneralCommand!) {
        super.init(TableCellIDs.playlistMenuTableCell, height: 44.0)
        
        self.titleText = titleText
        self.iconName = iconName
        self.command = command
    }
    
    
    override func didSelect() {
        self.command?.execute()
    }
}
