//
//  ContentScenarioFactory.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/24/17.
//
//

import UIKit

class ContentScenarioFactory: NSObject {
    
    class func scenario(withItem item: ItemModel!, rootVC: UIViewController!, delegate: OpenContentScenarioDelegate) -> OpenContentScenario? {
        if (item != nil) {
            if item.isMovie() {
                return MovieScenario.init(rootVC: rootVC, item: item, delegate: delegate)
            } 
            else if item.isPlaylist() {
                return OtherContentScenario.init(rootVC: rootVC, itemModel: item, delegate: delegate, title: "Playlist")
            } else if item.isEpisodes() {
                return OtherContentScenario.init(rootVC: rootVC, itemModel: item, delegate: delegate, title: "Series")
            } else if item.isCommercialPlaylist() {
                return OtherContentScenario.init(rootVC: rootVC, itemModel: item, delegate: delegate, title: "Commercial Playlist")
            } else if item.isSupplier() {
                return OtherContentScenario.init(rootVC: rootVC, itemModel: item, delegate: delegate, title: "Collection")
            }
            
            return OpenContentScenario.init(rootVC: rootVC, item: item, delegate: delegate)
        }
        
        return nil
    }
}
