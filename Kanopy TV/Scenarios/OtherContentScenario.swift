//
//  OtherContentScenario.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/28/17.
//
//

import UIKit

class OtherContentScenario: OpenContentScenario {

    private(set) var title: String!
    
    
    // MARK: - Init methods 
    
    
    init(rootVC: UIViewController!, itemModel: ItemModel!, delegate: OpenContentScenarioDelegate!, title: String!) {
        super.init(rootVC: rootVC, item: itemModel, delegate: delegate)
        
        self.title = title
    }
    
    
    // MARK: -
    
    
    override func start() {
        super.start()
        
        self.showContentVC()
    }
    
    
    override func stop() {
        super.stop()
    }
    
    
    // MARK: -
    
    
    private func showContentVC() {
        let url = URL.init(string: (self.itemModel.images?.mediumThumbURL())!)
        self.contentVC = OtherContentVC.init(delegate: self, url: url, title: self.title)
        self.rootVC.navigationController?.pushViewController(self.contentVC, animated: true)
    }
}
