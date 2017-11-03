//
//  TextWithLinksCellModel.swift
//  Kanopy
//
//  Created by Boris Esanu on 19.06.17.
//
//

import UIKit

class TextWithLinksCellModel: GenericCellModel {

    private(set) var text: String!
    private(set) var links: Array<TextLinkModel>!
    
    
    // MARK: - Init method
    
    
    init(text: String!, links: Array<TextLinkModel>!, height: CGFloat!) {
        super.init(TableCellIDs.textWithLinksTableCell, height: height)
        
        self.text = text
        self.links = links
    }
    
    
    // MARK: - Tools 
    
    
    func didPressToLink(linkText: String!) {
        
        for l in links {
            if l.key == linkText {
                l.command.execute()
            }
        }
    }
}
