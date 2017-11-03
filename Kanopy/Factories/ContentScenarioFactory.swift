//
//  ContentScenarioFactory.swift
//  Kanopy
//
//  Created by Boris Esanu on 15.06.17.
//
//

import UIKit

class ContentScenarioFactory: NSObject {

    class func scenario(withItem item: ItemModel!, nvc: MenuNavigationController!, delegate: OpenContentScenarioDelegate) -> OpenContentScenario? {
        if (item != nil) {
            if item.isMovie() {
                return OpenMovieScenario.init(nvc: nvc, item: item, delegate: delegate)
            } else if item.isPlaylist() {
                return OpenPlaylistScenario.init(nvc: nvc, item: item, delegate: delegate)
            } else if item.isEpisodes() {
                return OpenEpisodeScenario.init(nvc: nvc, item: item, delegate: delegate)
            } else if item.isCommercialPlaylist() {
                return OpenCommercialPlaylistScenario.init(nvc: nvc, item: item, delegate: delegate)
            } else if item.isSupplier() {
                return OpenSupplierScenario.init(nvc: nvc, item: item, delegate: delegate)
            }
            
            return OpenContentScenario.init(nvc: nvc, item: item, delegate: delegate)
        }
        
        return nil
    }
}
